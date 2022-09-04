// ignore_for_file: prefer_const_constructors
import 'package:draft_widget/src/util.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Matrix4Ext', () {
    test('transformRect', () {
      final transform = Matrix4.fromList([
        0.553359375,
        0.0,
        0.0,
        0.0,
        0.0,
        0.553359375,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
        22.33203125,
        44.6640625,
        0.0,
        1.0
      ]);
      final rect = Rect.fromLTRB(200, 200, 300, 300);
      expect(
        transform.transformRect(rect),
        Rect.fromLTRB(222.33203125, 244.6640625, 277.66796875, 300),
      );
    });
  });
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
