import 'dart:async';

import 'package:bluff/src/base/text.dart';
import 'package:meta/meta.dart';

import '../build_context.dart';
import 'click.dart';
import 'text.dart';
import 'widget.dart';

class TextLink extends StatelessWidget {
  final String url;
  final String title;
  final TextStyle inactiveStyle;
  final TextStyle activeStyle;
  final TextStyle hoverStyle;

  TextLink(
      {@required this.url,
      @required this.title,
      @required this.inactiveStyle,
      this.activeStyle,
      this.hoverStyle});

  @override
  FutureOr<Widget> build(BuildContext context) {
    return Click(
      url: url,
      builder: (context, state) {
        TextStyle style;

        switch (state) {
          case ClickState.active:
            style = activeStyle ?? hoverStyle ?? inactiveStyle;
            break;
          case ClickState.hover:
            style = hoverStyle ?? activeStyle ?? inactiveStyle;
            break;
          default:
            style = inactiveStyle;
            break;
        }

        return Text(
          title,
          style: style,
        );
      },
    );
  }
}
