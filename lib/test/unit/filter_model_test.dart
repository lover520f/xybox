import 'package:flutter_test/flutter_test.dart';
import 'package:xybox/data/models/filter_model.dart';

void main() {
  group('Filter Model Tests', () {
    test('should create Filter instance', () {
      final filter = const Filter(key: 'year', name: 'Year');
      expect(filter.key, 'year');
      expect(filter.name, 'Year');
    });

    test('should create Filter with value and init', () {
      final filter = const Filter(
        key: 'year',
        name: 'Year',
        value: '2024',
        init: true,
        selected: false,
      );
      expect(filter.value, '2024');
      expect(filter.init, true);
      expect(filter.selected, false);
    });
  });
}
