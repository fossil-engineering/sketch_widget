import 'dart:math';

import 'package:flutter/cupertino.dart';

/// ObjectExt provides let function like kotlin
extension ObjectExt<T> on T {
  /// let allow invoke function with this object
  R let<R>(R Function(T that) op) => op(this);
}

/// Matrix4Ext provides some utilities
extension Matrix4Ext on Matrix4 {
  /// Returns the scale value of the X axe.
  double getScaleX() => sqrt(
        storage[0] * storage[0] +
            storage[1] * storage[1] +
            storage[2] * storage[2],
      );

  /// Returns the scale value of the Y axe.
  double getScaleY() => sqrt(
        storage[4] * storage[4] +
            storage[5] * storage[5] +
            storage[6] * storage[6],
      );

  /// Returns the scale value of the XY axes.
  double getScaleXY() => sqrt(
        max(
          storage[0] * storage[0] +
              storage[1] * storage[1] +
              storage[2] * storage[2],
          storage[4] * storage[4] +
              storage[5] * storage[5] +
              storage[6] * storage[6],
        ),
      );

  /// Return transformed rect
  Rect transformRect(Rect rect) => getTranslation().let(
        (translation) => Rect.fromLTWH(
          rect.left + translation[0],
          rect.top + translation[1],
          rect.width * getScaleX(),
          rect.height * getScaleY(),
        ),
      );
}

/// OffsetExt provides some calculation
extension OffsetExt on Offset {
  /// intersect with a vector
  Offset intersect(Size vector) {
    final x = (dx * vector.width + dy * vector.height) /
        (vector.width + vector.height * vector.height / vector.width);
    return Offset(x, x * vector.height / vector.width);
  }
}
