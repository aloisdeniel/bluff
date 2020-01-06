import 'dart:async';

import 'package:bluff/bluff.dart';
import 'package:bluff/src/widgets/decorated_box.dart';
import 'package:bluff/src/widgets/sized_box.dart';

import 'padding.dart';

class Container extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final BoxDecoration decoration;
  final EdgeInsets padding;
  final BoxConstraints constraints;

  const Container({
    Key key,
    this.width,
    this.height,
    this.decoration,
    this.constraints,
    this.padding,
    this.child,
  }) : super(
          key: key,
        );

  @override
  FutureOr<Widget> build(BuildContext context) {
    var result = child;

    if (padding != null) {
      result = Padding(
        child: result,
        padding: padding,
      );
    }

    if (decoration != null) {
      result = DecoratedBox(
        child: result,
        decoration: decoration,
      );
    }

    if (constraints != null) {
      result = ConstrainedBox(
        child: result,
        constraints: constraints,
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: result,
    );
  }
}
