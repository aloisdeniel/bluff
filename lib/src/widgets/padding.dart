import 'dart:async';

import 'package:bluff/bluff.dart';
import 'package:bluff/src/base/keys.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

import '../build_context.dart';
import 'widget.dart';

class Padding extends Widget {
  final Widget child;
  final EdgeInsets padding;

  const Padding({
    Key key,
    this.child,
    this.padding,
  }) : super(key: key);

  @override
  FutureOr<html.CssStyleDeclaration> renderCss(BuildContext context) {
    final style = html.DivElement().style;
    style.display = 'flex';
    if (padding != null) {
      style.margin =
          '${padding.top}px ${padding.right}px ${padding.bottom}px ${padding.left}px';
    }
    return style;
  }

  @override
  FutureOr<html.HtmlElement> renderHtml(BuildContext context) async {
    if (child == null) return html.DivElement();
    return await child.render(context);
  }
}
