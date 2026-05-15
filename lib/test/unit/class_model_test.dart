import 'package:flutter_test/flutter_test.dart';
import 'package:xybox/data/models/class_model.dart';

void main() {
  group('Class Model Tests', () {
    test('should create Class instance', () {
      final clazz = const Class(typeId: '1', typeName: 'Movies');
      expect(clazz.typeId, '1');
      expect(clazz.typeName, 'Movies');
    });

    test('should create Class with ratio', () {
      final clazz = const Class(typeId: '1', typeName: 'Movies', ratio: 16);
      expect(clazz.ratio, 16);
    });
  });
}
