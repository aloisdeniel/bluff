import 'dart:async';

import 'package:bluff/bluff.dart';
import 'package:bluff/src/base/keys.dart';
import 'package:bluff/src/base/text.dart';
import 'package:bluff/src/widgets/provider.dart';
import 'package:meta/meta.dart';

class Theme extends StatelessWidget {
  final ThemeData data;
  final Widget child;

  const Theme({
    Key key,
    @required this.child,
    @required this.data,
  }) : super(
          key: key,
        );

  static ThemeData of(BuildContext context) {
    return Provider.of<ThemeData>(context);
  }

  @override
  Widget build(BuildContext context) {
    return ValueProvider<ThemeData>(
      value: data ?? ThemeData.base(),
      child: child,
    );
  }
}

class ThemeData {
  final ThemeTextData text;
  const ThemeData({
    @required this.text,
  });

  factory ThemeData.base() => ThemeData(
        text: ThemeTextData(
          paragraph: TextStyle(
            color: const Color(0xFF000000),
            fontSize: 11,
            fontWeight: FontWeight.w400,
            fontFamilyFallback: ['sans-serif'],
          ),
        ),
      );
}

class ThemeTextData {
  final TextStyle paragraph;
  const ThemeTextData({
    @required this.paragraph,
  });
}
