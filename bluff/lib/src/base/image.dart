import 'package:meta/meta.dart';

import 'hash_values.dart';

class ImageProvider {
  final String url;
  const ImageProvider.network(String url) : url = url;
  const ImageProvider.asset(String name) : url = 'asset://$name';
}

/// An image for a box decoration.
///
/// The image is painted using [paintImage], which describes the meanings of the
/// various fields on this class in more detail.
@immutable
class DecorationImage {
  /// Creates an image to show in a [BoxDecoration].
  ///
  /// The [image], [alignment], [repeat], and [matchTextDirection] arguments
  /// must not be null.
  const DecorationImage({
    @required this.image,
    this.fit,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
  })  : assert(image != null),
        assert(repeat != null),
        assert(matchTextDirection != null);

  /// The image to be painted into the decoration.
  ///
  /// Typically this will be an [AssetImage] (for an image shipped with the
  /// application) or a [NetworkImage] (for an image obtained from the network).
  final ImageProvider image;

  /// How the image should be inscribed into the box.
  ///
  /// The default is [BoxFit.scaleDown] if [centerSlice] is null, and
  /// [BoxFit.fill] if [centerSlice] is not null.
  ///
  /// See the discussion at [paintImage] for more details.
  final BoxFit fit;

  /// How to paint any portions of the box that would not otherwise be covered
  /// by the image.
  final ImageRepeat repeat;

  /// Whether to paint the image in the direction of the [TextDirection].
  ///
  /// If this is true, then in [TextDirection.ltr] contexts, the image will be
  /// drawn with its origin in the top left (the "normal" painting direction for
  /// images); and in [TextDirection.rtl] contexts, the image will be drawn with
  /// a scaling factor of -1 in the horizontal direction so that the origin is
  /// in the top right.
  final bool matchTextDirection;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final DecorationImage typedOther = other;
    return image == typedOther.image &&
        fit == typedOther.fit &&
        repeat == typedOther.repeat &&
        matchTextDirection == typedOther.matchTextDirection;
  }

  @override
  int get hashCode => hashValues(image, fit, repeat, matchTextDirection);

  @override
  String toString() {
    final List<String> properties = <String>[
      '$image',
      if (fit != null && !(fit == BoxFit.fill) && !(fit == BoxFit.scaleDown))
        '$fit',
      if (repeat != ImageRepeat.noRepeat) '$repeat',
      if (matchTextDirection) 'match text direction',
    ];
    return '$runtimeType(${properties.join(", ")})';
  }
}

/// How a box should be inscribed into another box.
///
/// See also [applyBoxFit], which applies the sizing semantics of these values
/// (though not the alignment semantics).
enum BoxFit {
  /// Fill the target box by distorting the source's aspect ratio.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/painting/box_fit_fill.png)
  fill,

  /// As large as possible while still containing the source entirely within the
  /// target box.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/painting/box_fit_contain.png)
  contain,

  /// As small as possible while still covering the entire target box.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/painting/box_fit_cover.png)
  cover,

  /// Align the source within the target box (by default, centering) and discard
  /// any portions of the source that lie outside the box.
  ///
  /// The source image is not resized.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/painting/box_fit_none.png)
  none,

  /// Align the source within the target box (by default, centering) and, if
  /// necessary, scale the source down to ensure that the source fits within the
  /// box.
  ///
  /// This is the same as `contain` if that would shrink the image, otherwise it
  /// is the same as `none`.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/painting/box_fit_scaleDown.png)
  scaleDown,
}

/// How to paint any portions of a box not covered by an image.
enum ImageRepeat {
  /// Repeat the image in both the x and y directions until the box is filled.
  repeat,

  /// Repeat the image in the x direction until the box is filled horizontally.
  repeatX,

  /// Repeat the image in the y direction until the box is filled vertically.
  repeatY,

  /// Leave uncovered portions of the box transparent.
  noRepeat,
}
