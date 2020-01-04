import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;

import 'app.dart';
import 'build_context.dart';
import 'widgets/localizations.dart';

Future<void> publish({
  @required Application application,
  Directory directory,
}) async {
  directory ??= Directory('build');

  for (var locale in application.supportedLocales) {
    final localeDirectory =
        Directory(path.join(directory.path, locale.toString()));
    await localeDirectory.create(recursive: true);
    for (var route in application.routes) {
      final routedApp = application.withCurrentRoute(route.relativeUrl);
      final localizedApp = Localizations(
        locale: locale,
        delegates: application.delegates,
        child: routedApp,
      );
      final context = BuildContext();
      final result = await localizedApp.render(context);
      final file =
          File(path.join(localeDirectory.path, route.relativeUrl + '.html'));
      await file.writeAsString(result.outerHtml);
    }
  }
}
