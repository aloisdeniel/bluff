import 'dart:async';

import 'package:bluff/src/base/keys.dart';
import 'package:meta/meta.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

import '../build_context.dart';
import 'widget.dart';

enum ClickState {
  inactive,
  hover,
  active,
}

class Click extends Widget {
  final String url;
  final WidgetValueBuilder<ClickState> builder;
  final bool newTab;

  Click({
    Key key,
    this.newTab = false,
    @required this.url,
    @required this.builder,
  })  : assert(url != null),
        assert(builder != null),
        assert(newTab != null),
        super(
          key: key,
        );

  @override
  FutureOr<html.HtmlElement> renderHtml(BuildContext context) async {
    final result = html.AnchorElement();
    result.className = 'click';

    result.href = url;
    if (newTab) {
      result.target = '_blank';
    }

    final inactive =
        await builder(context, ClickState.inactive).render(context);
    final active = await builder(context, ClickState.active).render(context);
    final hover = await builder(context, ClickState.hover).render(context);

    inactive.className += ' inactive';
    active.className += ' active';
    hover.className += ' hover';

    result.childNodes.add(inactive);
    result.childNodes.add(active);
    result.childNodes.add(hover);

    return result;
  }
}
