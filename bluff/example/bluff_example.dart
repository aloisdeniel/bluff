import 'package:bluff/bluff.dart';

import 'routes/home.dart';

Future main() async {
  final app = Application(
    availableSizes: [
      MediaSize.small,
      MediaSize.medium,
    ],
    supportedLocales: [
      Locale('fr', 'FR'),
      Locale('en', 'US'),
    ],
    routes: [
      homeRoute,
    ],
  );
  ;

  await publish(app);
}
