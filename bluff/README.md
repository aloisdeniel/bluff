# Bluff

Bluff is a static website generator written in dart that is inspired by Flutter widgets.
 
I started this project because I was tired of switching to a js environment everytime I need to write a small static website. I wanted the concept to be nearest of Flutter as possible, again, to keep the same way of developing interfaces.

> Why not simply use Flutter for web ?

Just because I wanted a really lightweight website with good SEOs (which are not the case at the moment).

**Diclaimer :** this is a weekend hack, use at your own risk!

## Usage

A simple usage example:

```dart
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
      Route(
        title: (context) {
          final locale = Localizations.localeOf(context);
          if (locale.languageCode == 'fr') return 'Accueil';
          return 'Home';
        },
        relativeUrl: 'index',
        builder: (context) => Home(),
      ),
    ],
  );
  ;

  await publish(
    application: app,
  );
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Flex(
          direction: mediaQuery.size == MediaSize.small
              ? Axis.vertical
              : Axis.horizontal,
          children: <Widget>[
            Expanded(
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFF00FF00),
                ),
              ),
            ),
            Text('Hello world!'),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFF0000FF),
              ),
            ),
          ],
        )
      ],
    );
  }
}
```
