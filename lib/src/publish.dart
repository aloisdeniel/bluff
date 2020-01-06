import 'dart:io';

import 'package:path/path.dart' as path;

import 'app.dart';
import 'assets.dart';
import 'build_context.dart';
import 'widgets/localizations.dart';
import 'widgets/widget.dart';

Future<void> publish(
  Widget widget, {
  Directory directory,
  Directory assets,
}) async {
  directory ??= Directory('build');
  assets ??= Directory('assets');

  print('B L U F F');
  print('...');

  final context = BuildContext(
    assets: Assets(),
  );

  if (widget is StatelessWidget) {
    widget = (widget as StatelessWidget).build(context);
  }

  Application application;

  if (widget is Application) {
    application = widget;
  } else {
    application = Application(routes: [
      Route(
        title: (context) => 'Index',
        builder: (context) => widget,
        relativeUrl: 'index',
      )
    ]);
  }

  for (var locale in application.supportedLocales) {
    print('[Locale($locale)]');
    final localeDirectory =
        Directory(path.join(directory.path, locale.toString()));
    await localeDirectory.create(recursive: true);

    // Copying all assets
    if (assets != null && await assets.exists()) {
      print('  [Assets]');
      final localAssetDestination =
          Directory(path.join(localeDirectory.path, 'assets'));
      await localAssetDestination.create(recursive: true);

      final items = await assets.list(recursive: true);
      for (var item in await items.toList()) {
        if (item is File) {
          final relativePath = item.path.replaceFirst(
            assets.path + '/',
            '',
          );
          final destination = File(
            path.join(localAssetDestination.path, relativePath),
          );
          await destination.create(recursive: true);
          print("   - '${item.path}' > '${destination.path}'");
          await item.copy(destination.path);
        }
      }
    }

    for (var route in application.routes) {
      print('  [Route(${route.relativeUrl})]');
      final routedApp = application.withCurrentRoute(route.relativeUrl);
      final localizedApp = Localizations(
        locale: locale,
        delegates: application.delegates,
        child: routedApp,
      );
      final result = await localizedApp.render(context);
      final file =
          File(path.join(localeDirectory.path, route.relativeUrl + '.html'));
      print("   - '${file.path}");
      await file.writeAsString(result.outerHtml);
    }
  }
}
