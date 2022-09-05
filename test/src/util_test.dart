// ignore_for_file: prefer_const_constructors
import 'package:draft_widget/src/util.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OffsetExt', () {
    test('intersect', () {
      expect(
        Offset(-3, 2).intersect(Size(200, 300)),
        Offset(0, 0),
      );
      expect(
        Offset(-4, 0.5).intersect(Size(200, 300)),
        Offset(-1, -1.5),
      );
      expect(
        Offset(6, 6).intersect(Size(100, 100)),
        Offset(6, 6),
      );
    });
  });
}
