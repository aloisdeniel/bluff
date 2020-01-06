# Bluff

## Diclaimer : I built this for my own needs, so don't expect it to be complete. It is a weekend hack, use at your own risk!

Bluff is a static website generator written in dart that is inspired by Flutter widgets.
 
 > Why ?

I started this project because I was tired of switching to a js environment everytime I need to write a small static website. I wanted the concept to be nearest of Flutter as possible, again, to keep the same way of developing user interfaces and not loosing time relearning paradigms again and again.

> Why not using Flutter for web ?

Just because I wanted a really lightweight website with good SEOs. The migration to Flutter for web should be pretty simple though.

## Usage

A simple usage example:

```dart
import 'package:bluff/bluff.dart';

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

final homeRoute = Route(
  title: (context) {
    final locale = Localizations.localeOf(context);
    if (locale.languageCode == 'fr') return 'Accueil';
    return 'Home';
  },
  relativeUrl: 'index',
  builder: (context) => Home(),
);

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
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
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ImageProvider.asset('images/logo_dart_192px.svg'),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text('Hello world!'),
            ),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF0000FF),
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xAA0000FF),
                    blurRadius: 10,
                    offset: Offset(10, 10),
                  ),
                ],
              ),
            ),
            Image.asset(
              'images/logo_dart_192px.svg',
              fit: BoxFit.cover,
            ),
            Click(
              newTab: true,
              url: 'https://www.google.com',
              builder: (context, state) {
                return Container(
                  child: Text(
                    'Button',
                    style: theme.text.paragraph.merge(
                      TextStyle(
                        color: state == ClickState.hover
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFF0000FF),
                      ),
                    ),
                  ),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: state == ClickState.hover
                        ? const Color(0xFF0000FF)
                        : const Color(0x440000FF),
                    borderRadius: BorderRadius.circular(5),
                  ),
                );
              },
            )
          ],
        )
      ],
    );
  }
}

```
