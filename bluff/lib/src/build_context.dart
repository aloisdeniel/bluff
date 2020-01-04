import 'package:bluff/src/widgets/widget.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

import 'base/keys.dart';

class BuildContext {
  static int lastKeyIndex = 0;
  final Map<Type, InheritedWidget> _inheritedWidgets = {};
  final Map<String, html.CssStyleDeclaration> styles;

  BuildContext({
    Map<String, html.CssStyleDeclaration> styles,
  }) : styles = styles ?? <String, html.CssStyleDeclaration>{};

  BuildContext withInherited(InheritedWidget widget) {
    final result = BuildContext(
      styles: styles,
    );
    result._inheritedWidgets.addAll(_inheritedWidgets);
    result._inheritedWidgets[widget.runtimeType] = widget;
    return result;
  }

  Key createDefaultKey() => Key('_w${lastKeyIndex++}');

  T dependOnInheritedWidgetOfExactType<T extends InheritedWidget>() {
    assert(
      _inheritedWidgets.containsKey(T),
      'No inherited widget with type $T found in tree',
    );
    return _inheritedWidgets[T];
  }
}
