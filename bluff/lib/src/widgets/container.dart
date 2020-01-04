import 'dart:async';

import 'package:bluff/src/base/keys.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

import 'package:bluff/src/base/decoration.dart';

import '../build_context.dart';
import 'widget.dart';

class Container extends Widget {
  final Widget child;
  final BoxDecoration decoration;
  final double width;
  final double height;

  const Container({
    Key key,
    this.child,
    this.decoration,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  FutureOr<html.HtmlElement> render(BuildContext context) async {
    final result = await super.render(context);
    if (child != null) {
      result.childNodes.add(await child.render(context));
    }
    return result;
  }

  @override
  FutureOr<html.CssStyleDeclaration> renderCss(BuildContext context) {
    final style = html.DivElement().style;

    style.display = 'flex';
    if (width != null) style.width = '${width}px';
    if (height != null) style.height = '${height}px';
    if (decoration?.color != null) {
      final color = decoration.color.toCss();
      style.backgroundColor = color;
    }

    return style;
  }

  @override
  FutureOr<html.HtmlElement> renderHtml(BuildContext context) {
    return html.DivElement();
  }
}
