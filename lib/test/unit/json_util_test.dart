import 'package:flutter_test/flutter_test.dart';
import 'package:xybox/core/utils/json_util.dart';

void main() {
  group('JsonUtil Tests', () {
    test('should parse valid json', () {
      final result = JsonUtil.parse<Map<String, dynamic>>(
        '{"name": "test", "value": 123}',
        (json) => json,
      );
      expect(result, isNotNull);
      expect(result!['name'], 'test');
    });

    test('should return null for empty json', () {
      final result = JsonUtil.parse<Map<String, dynamic>>(
        '',
        (json) => json,
      );
      expect(result, isNull);
    });

    test('should return null for null json', () {
      final result = JsonUtil.parse<Map<String, dynamic>>(
        null,
        (json) => json,
      );
      expect(result, isNull);
    });

    test('should stringify object to json', () {
      final obj = {'name': 'test', 'value': 123};
      final result = JsonUtil.stringify(obj);
      expect(result, contains('"name":"test"'));
    });

    test('should return empty string for null object', () {
      final result = JsonUtil.stringify(null);
      expect(result, '');
    });
  });
}
