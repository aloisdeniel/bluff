import 'dart:async';
import 'package:bluff/src/base/locale.dart';
import 'package:bluff/src/widgets/localizations.dart';

import 'package:meta/meta.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

import 'build_context.dart';
import 'helpers/css_base.dart';
import 'helpers/css_reset.dart';
import 'widgets/theme.dart';
import 'widgets/widget.dart';
import 'widgets/media_query.dart';

class Breakpoint {
  final int minSize;
  final MediaSize size;
  const Breakpoint(this.size, this.minSize);

  static Breakpoint defaultBreakpoint(MediaSize size) {
    switch (size) {
      case MediaSize.xsmall:
        return Breakpoint(size, 0);
      case MediaSize.small:
        return Breakpoint(size, 600);
      case MediaSize.large:
        return Breakpoint(size, 1440);
      case MediaSize.xlarge:
        return Breakpoint(size, 1920);
      default:
        return Breakpoint(MediaSize.medium, 1024);
    }
  }
}

typedef ApplicationPlugin = Future<void> Function(
  Application application,
  html.HtmlHtmlElement document,
);

typedef ApplicationThemeBuilder = ThemeData Function(BuildContext context);

class Application extends Widget {
  final String currentRoute;
  final List<Route> routes;
  final List<MediaSize> availableSizes;
  final List<Locale> supportedLocales;
  final List<ApplicationPlugin> plugins;
  final List<String> stylesheetLinks;
  final List<String> scriptLinks;
  final ApplicationThemeBuilder theme;
  final WidgetChildBuilder builder;

  /// This list collectively defines the localized resources objects that can
  /// be retrieved with [Localizations.of].
  final List<LocalizationsDelegate<dynamic>> delegates;

  Application({
    @required this.routes,
    this.currentRoute,
    this.theme,
    this.builder,
    this.stylesheetLinks = const <String>[],
    this.scriptLinks = const <String>[],
    this.plugins = const <ApplicationPlugin>[],
    this.delegates = const <LocalizationsDelegate<dynamic>>[],
    this.supportedLocales = const <Locale>[
      Locale('en', 'US'),
    ],
    List<MediaSize> availableSizes = MediaSize.values,
  })  : assert(availableSizes != null && availableSizes.isNotEmpty),
        availableSizes = <MediaSize>[...availableSizes]
          ..sort((x, y) => x.index.compareTo(y.index));

  Application withCurrentRoute(String currentRoute) {
    return Application(
      routes: routes,
      currentRoute: currentRoute,
      theme: theme,
      stylesheetLinks: stylesheetLinks,
      scriptLinks: scriptLinks,
      plugins: plugins,
      delegates: delegates,
      supportedLocales: supportedLocales,
      availableSizes: availableSizes,
      builder: builder,
    );
  }

  String _mediaClassForMediaSize(MediaSize size) {
    final availableIndex = availableSizes.indexOf(size);
    final min = availableIndex == 0
        ? Breakpoint(size, 0)
        : Breakpoint.defaultBreakpoint(size);
    final max = availableIndex + 1 >= availableSizes.length
        ? null
        : Breakpoint.defaultBreakpoint(availableSizes[availableIndex + 1]);

    final minString = '(min-width: ${min.minSize}px)';
    final maxString =
        max == null ? '' : ' and (max-width: ${max.minSize - 1}px)';
    final buffer = StringBuffer();
    buffer.write('@media all and $minString$maxString {');
    for (var current in availableSizes) {
      buffer.write(
          '.size${current.index} {display: ${size == current ? "block" : "none"}; } ');
    }
    buffer.write('}');
    return buffer.toString();
  }

  @override
  FutureOr<html.HtmlElement> renderHtml(BuildContext context) async {
    assert(this.currentRoute != null);
    final document = html.HtmlHtmlElement();
    final currentRoute =
        routes.firstWhere((x) => x.relativeUrl == this.currentRoute);
    final head = html.HeadElement();
    head.childNodes.add(html.MetaElement()..setAttribute('charset', 'UTF-8'));
    head.childNodes.add(html.MetaElement()
      ..setAttribute('name', 'viewport')
      ..setAttribute('content', 'width=device-width, initial-scale=1'));

    document.childNodes.add(head);

    for (var link in stylesheetLinks) {
      head.childNodes.add(html.LinkElement()
        ..href = link
        ..rel = 'stylesheet');
    }

    currentRoute.head(context, head);

    final styles = html.StyleElement();
    styles.childNodes.add(html.Text(resetCss));
    styles.childNodes.add(html.Text(baseCss));
    document.childNodes.add(styles);

    final body = html.BodyElement();
    document.childNodes.add(body);

    for (var mediaSize in availableSizes) {
      styles.childNodes.add(html.Text(_mediaClassForMediaSize(mediaSize)));
      final sizeDiv = html.DivElement();
      sizeDiv.className = 'size' + mediaSize.index.toString();
      final root = MediaQuery(
        data: MediaQueryData(size: mediaSize),
        child: Builder(
          builder: (context) => Theme(
            data: theme(context),
            child:
                builder != null ? builder(context, currentRoute) : currentRoute,
          ),
        ),
      );

      sizeDiv.childNodes.add(await root.render(context));
      body.childNodes.add(sizeDiv);

      for (var link in scriptLinks) {
        body.childNodes.add(html.ScriptElement()
          ..src = link
          ..async = true
          ..defer = true);
      }
    }

    return document;
  }

  @override
  FutureOr<html.HtmlElement> render(BuildContext context) async {
    final result = await super.render(context);
    final styles = result.childNodes.firstWhere((x) => x is html.StyleElement);

    context.styles.entries.forEach((e) {
      styles.childNodes.add(html.Text('.${e.key} { ${e.value.toString()} }'));
    });

    for (var plugin in plugins) {
      await plugin(this, result as html.HtmlHtmlElement);
    }

    return result;
  }
}

typedef TitleBuilder = String Function(BuildContext context);

class Route extends Widget {
  final TitleBuilder title;
  final String relativeUrl;
  final WidgetBuilder builder;

  const Route({
    @required this.title,
    @required this.relativeUrl,
    @required this.builder,
  });

  void head(BuildContext context, html.HeadElement head) {
    head.childNodes.add(html.TitleElement()..text = title(context));
  }

  @override
  FutureOr<html.HtmlElement> renderHtml(BuildContext context) {
    return builder(context).render(context);
  }
}
