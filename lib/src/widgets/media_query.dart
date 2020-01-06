import 'package:bluff/src/base/keys.dart';
import 'package:meta/meta.dart';

import '../build_context.dart';
import 'widget.dart';

class MediaQuery extends InheritedWidget {
  final MediaQueryData data;

  const MediaQuery({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(
          key: key,
          child: child,
        );

  static MediaQueryData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MediaQuery>()?.data;
  }
}

@immutable
class MediaQueryData {
  final MediaSize size;

  MediaQueryData({
    @required this.size,
  });
}

enum MediaSize {
  xsmall,
  small,
  medium,
  large,
  xlarge,
}
