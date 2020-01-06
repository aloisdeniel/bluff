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
      value: data ?? ThemeData.base(context),
      child: child,
    );
  }
}

class ThemeData {
  final ThemeTextData text;
  const ThemeData({
    @required this.text,
  });

  static double defaultParagraphFontSize(MediaSize size) {
    switch (size) {
      case MediaSize.xsmall:
        return 9;
      case MediaSize.small:
        return 10;
      default:
        return 12;
    }
  }

  static double defaultHeader1FontSize(MediaSize size) {
    switch (size) {
      case MediaSize.xsmall:
        return 18;
      case MediaSize.small:
        return 24;
      default:
        return 32;
    }
  }

  static double defaultHeader2FontSize(MediaSize size) {
    switch (size) {
      case MediaSize.xsmall:
        return 14;
      case MediaSize.small:
        return 18;
      default:
        return 24;
    }
  }

  static double defaultHeader3FontSize(MediaSize size) {
    switch (size) {
      case MediaSize.xsmall:
        return 10;
      case MediaSize.small:
        return 12;
      default:
        return 16;
    }
  }

  factory ThemeData.base(BuildContext context, {String fontFamily}) {
    final size = MediaQuery.of(context).size;
    return ThemeData(
      text: ThemeTextData(
        paragraph: TextStyle(
          color: const Color(0xFF000000),
          fontSize: defaultParagraphFontSize(size),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w400,
          fontFamilyFallback: ['sans-serif'],
        ),
        header1: TextStyle(
          color: const Color(0xFF000000),
          fontSize: defaultHeader1FontSize(size),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w700,
          fontFamilyFallback: ['sans-serif'],
        ),
        header2: TextStyle(
          color: const Color(0xFF000000),
          fontSize: defaultHeader2FontSize(size),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w700,
          fontFamilyFallback: ['sans-serif'],
        ),
        header3: TextStyle(
          color: const Color(0xFF000000),
          fontSize: defaultHeader3FontSize(size),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w700,
          fontFamilyFallback: ['sans-serif'],
        ),
        activeLink: TextStyle(
          color: const Color(0xFF000000),
          fontSize: defaultParagraphFontSize(size),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w400,
          fontFamilyFallback: ['sans-serif'],
        ),
        inactiveLink: TextStyle(
          color: const Color(0xFF000000),
          fontSize: defaultParagraphFontSize(size),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w400,
          fontFamilyFallback: ['sans-serif'],
        ),
        hoverLink: TextStyle(
          color: const Color(0xFF000000),
          fontSize: defaultParagraphFontSize(size),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w400,
          fontFamilyFallback: ['sans-serif'],
        ),
      ),
    );
  }
}

class ThemeTextData {
  final TextStyle paragraph;
  final TextStyle header1;
  final TextStyle header2;
  final TextStyle header3;
  final TextStyle inactiveLink;
  final TextStyle activeLink;
  final TextStyle hoverLink;
  const ThemeTextData({
    @required this.paragraph,
    @required this.header1,
    @required this.header2,
    @required this.header3,
    @required this.inactiveLink,
    @required this.activeLink,
    @required this.hoverLink,
  });
}
