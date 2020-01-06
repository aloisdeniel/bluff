import 'dart:async';

import 'package:bluff/src/base/border_radius.dart';
import 'package:bluff/src/base/image.dart';
import 'package:bluff/src/base/keys.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

import 'package:bluff/src/base/decoration.dart';

import '../build_context.dart';
import 'flex.dart';
import 'widget.dart';

class DecoratedBox extends Widget {
  final Widget child;
  final BoxDecoration decoration;

  const DecoratedBox({
    Key key,
    this.child,
    this.decoration,
  }) : super(key: key);

  @override
  FutureOr<html.CssStyleDeclaration> renderCss(BuildContext context) {
    final style = html.DivElement().style;
    style.display = 'flex';

    if (decoration?.color != null) {
      final color = decoration.color.toCss();
      style.backgroundColor = color;
    } else if (decoration?.image != null) {
      style.backgroundImage =
          'url(' + context.resolveUrl(decoration.image.image.url) + ')';
    }

    if (decoration != null) {
      if (decoration.image?.fit != null) {
        style.backgroundPosition = 'center';
        switch (decoration.image.fit) {
          case BoxFit.cover:
            style.backgroundSize = 'cover';
            break;
          case BoxFit.fill:
            style.backgroundSize = 'fill';
            break;
          case BoxFit.none:
            style.backgroundSize = 'none';
            break;
          case BoxFit.scaleDown:
            style.backgroundSize = 'scale-down';
            break;
          default:
            style.backgroundSize = 'contain';
            break;
        }
      }
      final borderRadius = decoration.borderRadius;
      if (borderRadius is BorderRadius) {
        if (borderRadius.topLeft != null) {
          style.borderTopLeftRadius = '${borderRadius.topLeft.x}px';
        }
        if (borderRadius.topRight != null) {
          style.borderTopRightRadius = '${borderRadius.topRight.x}px';
        }
        if (borderRadius.bottomLeft != null) {
          style.borderBottomLeftRadius = '${borderRadius.bottomLeft.x}px';
        }
        if (borderRadius.bottomRight != null) {
          style.borderBottomRightRadius = '${borderRadius.bottomRight.x}px';
        }
      }

      if (decoration.boxShadow != null && decoration.boxShadow.isNotEmpty) {
        final shadow = decoration.boxShadow.first;
        final shadowColor = shadow.color.toCss();
        style.boxShadow =
            '${shadow.offset?.dx ?? 0}px ${shadow.offset?.dy ?? 0}px ${shadow.blurRadius ?? 0}px ${shadow.spreadRadius ?? 0}px ${shadowColor};';
      }
    }
    return style;
  }

  @override
  FutureOr<html.HtmlElement> renderHtml(BuildContext context) async {
    final result = html.DivElement();
    if (child != null) {
      result.childNodes.add(await Expanded(child: child).render(context));
    }
    return result;
  }
}
