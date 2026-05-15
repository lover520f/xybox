import 'package:flutter_test/flutter_test.dart';
import 'package:xybox/core/utils/date_util.dart';

void main() {
  group('DateUtil Tests', () {
    test('should format datetime correctly', () {
      final dt = DateTime(2024, 6, 15, 14, 30);
      final result = DateUtil.format(dt);
      expect(result, '2024-06-15 14:30');
    });

    test('should format relative time for recent datetime', () {
      final now = DateTime.now();
      final recent = now.subtract(const Duration(minutes: 5));
      final result = DateUtil.formatRelative(recent);
      expect(result, contains('分钟前'));
    });

    test('should format relative time for old datetime', () {
      final old = DateTime.now().subtract(const Duration(days: 10));
      final result = DateUtil.formatRelative(old);
      expect(result, isNot(contains('分钟前')));
    });
  });
}
