import 'dart:async';

import 'package:bluff/src/base/keys.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

import '../build_context.dart';
import 'widget.dart';

class ConstrainedBox extends Widget {
  /// The additional constraints to impose on the child.
  final BoxConstraints constraints;

  final Widget child;

  const ConstrainedBox({
    Key key,
    this.child,
    this.constraints,
  }) : super(key: key);

  @override
  FutureOr<html.CssStyleDeclaration> renderCss(BuildContext context) {
    final style = html.DivElement().style;
    if (constraints != null) {
      style.margin = 'auto';
      if (constraints.maxHeight != null) {
        style.maxHeight = '${constraints.maxHeight}px';
      }
      if (constraints.maxWidth != null) {
        style.maxWidth = '${constraints.maxWidth}px';
      }
      if (constraints.minHeight != null) {
        style.minHeight = '${constraints.minHeight}px';
      }
      if (constraints.minWidth != null) {
        style.minWidth = '${constraints.minWidth}px';
      }
    }
    return style;
  }

  @override
  FutureOr<html.HtmlElement> renderHtml(BuildContext context) async {
    return await child.render(context);
  }
}

class BoxConstraints {
  /// The minimum width that satisfies the constraints.
  final double minWidth;

  /// The maximum width that satisfies the constraints.
  ///
  /// Might be [double.infinity].
  final double maxWidth;

  /// The minimum height that satisfies the constraints.
  final double minHeight;

  /// The maximum height that satisfies the constraints.
  ///
  /// Might be [double.infinity].
  final double maxHeight;

  BoxConstraints({
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
  });
}
