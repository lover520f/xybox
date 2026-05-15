import 'package:flutter_test/flutter_test.dart';
import 'package:xybox/core/utils/logger_util.dart';

void main() {
  group('LoggerUtil Tests', () {
    test('should log info message without error', () {
      expect(() => LoggerUtil.i('Test info'), returnsNormally);
    });

    test('should log debug message without error', () {
      expect(() => LoggerUtil.d('Test debug'), returnsNormally);
    });

    test('should log error message with error object', () {
      expect(() => LoggerUtil.e('Test error', error: Exception('test')), returnsNormally);
    });

    test('should log warning message without error', () {
      expect(() => LoggerUtil.w('Test warning'), returnsNormally);
    });
  });
}
