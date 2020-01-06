// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:meta/meta.dart';

import 'border_radius.dart';
import 'box_border.dart';
import 'color.dart';
import 'geometry.dart';
import 'image.dart';

/// An immutable description of how to paint a box.
///
/// The [BoxDecoration] class provides a variety of ways to draw a box.
///
/// The box has a [border], a body, and may cast a [boxShadow].
///
/// The [shape] of the box can be a circle or a rectangle. If it is a rectangle,
/// then the [borderRadius] property controls the roundness of the corners.
///
/// The body of the box is painted in layers. The bottom-most layer is the
/// [color], which fills the box. Above that is the [gradient], which also fills
/// the box. Finally there is the [image], the precise alignment of which is
/// controlled by the [DecorationImage] class.
///
/// The [border] paints over the body; the [boxShadow], naturally, paints below it.
///
/// {@tool sample}
///
/// The following applies a [BoxDecoration] to a [Container] widget to draw an
/// [image] of an owl with a thick black [border] and rounded corners.
///
/// ![](https://flutter.github.io/assets-for-api-docs/assets/painting/box_decoration.png)
///
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     color: const Color(0xff7c94b6),
///     image: const DecorationImage(
///       image: NetworkImage('https:///flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
///       fit: BoxFit.cover,
///     ),
///     border: Border.all(
///       color: Colors.black,
///       width: 8,
///     ),
///     borderRadius: BorderRadius.circular(12),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// {@template flutter.painting.boxDecoration.clip}
/// The [shape] or the [borderRadius] won't clip the children of the
/// decorated [Container]. If the clip is required, insert a clip widget
/// (e.g., [ClipRect], [ClipRRect], [ClipPath]) as the child of the [Container].
/// Be aware that clipping may be costly in terms of performance.
/// {@endtemplate}
///
/// See also:
///
///  * [DecoratedBox] and [Container], widgets that can be configured with
///    [BoxDecoration] objects.
///  * [CustomPaint], a widget that lets you draw arbitrary graphics.
///  * [Decoration], the base class which lets you define other decorations.
class BoxDecoration {
  /// Creates a box decoration.
  ///
  /// * If [color] is null, this decoration does not paint a background color.
  /// * If [image] is null, this decoration does not paint a background image.
  /// * If [border] is null, this decoration does not paint a border.
  /// * If [borderRadius] is null, this decoration uses more efficient background
  ///   painting commands. The [borderRadius] argument must be null if [shape] is
  ///   [BoxShape.circle].
  /// * If [boxShadow] is null, this decoration does not paint a shadow.
  /// * If [gradient] is null, this decoration does not paint gradients.
  /// * If [backgroundBlendMode] is null, this decoration paints with [BlendMode.srcOver]
  ///
  /// The [shape] argument must not be null.
  const BoxDecoration({
    this.color,
    this.image,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.gradient,
  }) : assert(
            image != null || color != null || gradient != null,
            'backgroundBlendMode applies to BoxDecoration\'s background color or '
            'gradient, but no color or gradient was provided.');

  /// Creates a copy of this object but with the given fields replaced with the
  /// new values.
  BoxDecoration copyWith({
    Color color,
    DecorationImage image,
    BoxBorder border,
    BorderRadiusGeometry borderRadius,
    List<BoxShadow> boxShadow,
    Gradient gradient,
  }) {
    return BoxDecoration(
      color: color ?? this.color,
      image: image ?? this.image,
      border: border ?? this.border,
      borderRadius: borderRadius ?? this.borderRadius,
      boxShadow: boxShadow ?? this.boxShadow,
      gradient: gradient ?? this.gradient,
    );
  }

  /// The color to fill in the background of the box.
  ///
  /// The color is filled into the [shape] of the box (e.g., either a rectangle,
  /// potentially with a [borderRadius], or a circle).
  ///
  /// This is ignored if [gradient] is non-null.
  ///
  /// The [color] is drawn under the [image].
  final Color color;

  /// An image to paint above the background [color] or [gradient].
  ///
  /// If [shape] is [BoxShape.circle] then the image is clipped to the circle's
  /// boundary; if [borderRadius] is non-null then the image is clipped to the
  /// given radii.
  final DecorationImage image;

  /// A border to draw above the background [color], [gradient], or [image].
  ///
  /// Follows the [shape] and [borderRadius].
  ///
  /// Use [Border] objects to describe borders that do not depend on the reading
  /// direction.
  ///
  /// Use [BoxBorder] objects to describe borders that should flip their left
  /// and right edges based on whether the text is being read left-to-right or
  /// right-to-left.
  final BoxBorder border;

  /// If non-null, the corners of this box are rounded by this [BorderRadius].
  ///
  /// Applies only to boxes with rectangular shapes; ignored if [shape] is not
  /// [BoxShape.rectangle].
  ///
  /// {@macro flutter.painting.boxDecoration.clip}
  final BorderRadiusGeometry borderRadius;

  /// A list of shadows cast by this box behind the box.
  ///
  /// The shadow follows the [shape] of the box.
  ///
  /// See also:
  ///
  ///  * [kElevationToShadow], for some predefined shadows used in Material
  ///    Design.
  ///  * [PhysicalModel], a widget for showing shadows.
  final List<BoxShadow> boxShadow;

  /// A gradient to use when filling the box.
  ///
  /// If this is specified, [color] has no effect.
  ///
  /// The [gradient] is drawn under the [image].
  final Gradient gradient;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final BoxDecoration typedOther = other;
    return color == typedOther.color &&
        image == typedOther.image &&
        border == typedOther.border &&
        borderRadius == typedOther.borderRadius &&
        boxShadow == typedOther.boxShadow &&
        gradient == typedOther.gradient;
  }
}

@immutable
abstract class Gradient {
  /// Initialize the gradient's colors and stops.
  ///
  /// The [colors] argument must not be null, and must have at least two colors
  /// (the length is not verified until the [createShader] method is called).
  ///
  /// If specified, the [stops] argument must have the same number of entries as
  /// [colors] (this is also not verified until the [createShader] method is
  /// called).
  ///
  /// The [transform] argument can be applied to transform _only_ the gradient,
  /// without rotating the canvas itself or other geometry on the canvas. For
  /// example, a `GradientRotation(math.pi/4)` will result in a [SweepGradient]
  /// that starts from a position of 6 o'clock instead of 3 o'clock, assuming
  /// no other rotation or perspective transformations have been applied to the
  /// [Canvas]. If null, no transformation is applied.
  const Gradient({
    @required this.colors,
    this.stops,
  }) : assert(colors != null);

  /// The colors the gradient should obtain at each of the stops.
  ///
  /// If [stops] is non-null, this list must have the same length as [stops].
  ///
  /// This list must have at least two colors in it (otherwise, it's not a
  /// gradient!).
  final List<Color> colors;

  /// A list of values from 0.0 to 1.0 that denote fractions along the gradient.
  ///
  /// If non-null, this list must have the same length as [colors].
  ///
  /// If the first value is not 0.0, then a stop with position 0.0 and a color
  /// equal to the first color in [colors] is implied.
  ///
  /// If the last value is not 1.0, then a stop with position 1.0 and a color
  /// equal to the last color in [colors] is implied.
  ///
  /// The values in the [stops] list must be in ascending order. If a value in
  /// the [stops] list is less than an earlier value in the list, then its value
  /// is assumed to equal the previous value.
  ///
  /// If stops is null, then a set of uniformly distributed stops is implied,
  /// with the first stop at 0.0 and the last stop at 1.0.
  final List<double> stops;
}

class BoxShadow {
  final Color color;
  final Offset offset;
  final double blurRadius;
  final double spreadRadius;

  /// Creates a box shadow.
  ///
  /// By default, the shadow is solid black with zero [offset], [blurRadius],
  /// and [spreadRadius].
  const BoxShadow({
    this.color = const Color(0xFF000000),
    this.offset = Offset.zero,
    this.blurRadius = 0.0,
    this.spreadRadius = 0.0,
  });
}
