import 'package:bluff/bluff.dart';
import 'package:bluff/src/base/keys.dart';
import 'package:meta/meta.dart';

typedef ProviderCreator<T> = T Function(BuildContext context);

class Provider<T> extends StatelessWidget {
  final ProviderCreator<T> create;
  final Widget child;

  const Provider({
    Key key,
    @required this.create,
    @required this.child,
  }) : super(key: key);

  static T of<T>(BuildContext context) {
    return ValueProvider.of<T>(context);
  }

  @override
  Widget build(BuildContext context) {
    return ValueProvider<T>(
      value: create(context),
      child: child,
    );
  }
}

class ValueProvider<T> extends InheritedWidget {
  final T value;

  static T of<T>(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ValueProvider<T>>();
    assert(provider != null);
    return provider.value;
  }

  ValueProvider({
    Key key,
    @required Widget child,
    @required this.value,
  }) : super(
          key: key,
          child: child,
        );
}
