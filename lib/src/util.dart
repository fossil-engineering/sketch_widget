import 'dart:math';

import 'package:flutter/cupertino.dart';

/// ObjectExt provides let function like kotlin
extension ObjectExt<T> on T {
  /// let allow invoke function with this object
  R let<R>(R Function(T it) op) => op(this);
}

/// Matrix4Ext provides some utilities
extension Matrix4Ext on Matrix4 {
  /// Returns the scale value of the X axe.
  double get scaleX => sqrt(
        storage[0] * storage[0] +
            storage[1] * storage[1] +
            storage[2] * storage[2],
      );

  /// Returns the scale value of the Y axe.
  double get scaleY => sqrt(
        storage[4] * storage[4] +
            storage[5] * storage[5] +
            storage[6] * storage[6],
      );

  /// Returns the scale value of the XY axes.
  double get scaleXY => sqrt(
        max(
          storage[0] * storage[0] +
              storage[1] * storage[1] +
              storage[2] * storage[2],
          storage[4] * storage[4] +
              storage[5] * storage[5] +
              storage[6] * storage[6],
        ),
      );

  /// rotationZ of transform
  double get rotationZ => atan2(storage[1], storage[0]);
}

/// OffsetExt provides some calculation
extension OffsetExt on Offset {
  /// intersect with a vector
  Offset intersect(Size vector) {
    final x = (dx * vector.width + dy * vector.height) /
        (vector.width + vector.height * vector.height / vector.width);
    return Offset(x, x * vector.height / vector.width);
  }

  /// angle of 3 points
  double angle(Offset p1, Offset p2) {
    final o1 = this - p1;
    final o2 = this - p2;
    return atan2(o1.dx * o2.dy - o1.dy * o2.dx, o1.dx * o2.dx + o1.dy * o2.dy);
  }
}
