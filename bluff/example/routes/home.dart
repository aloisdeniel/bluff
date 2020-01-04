import 'package:bluff/bluff.dart';

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
