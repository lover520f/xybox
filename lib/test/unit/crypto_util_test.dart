import 'package:flutter_test/flutter_test.dart';
import 'package:xybox/core/utils/crypto_util.dart';

void main() {
  group('CryptoUtil Tests', () {
    test('should generate correct md5 hash', () {
      final result = CryptoUtil.md5('hello');
      expect(result, '5d41402abc4b2a76b9719d911017c592');
    });

    test('should generate correct sha1 hash', () {
      final result = CryptoUtil.sha1('hello');
      expect(result, 'aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d');
    });

    test('should encode and decode base64', () {
      const original = 'hello world';
      final encoded = CryptoUtil.base64Encode(original);
      final decoded = CryptoUtil.base64Decode(encoded);
      expect(decoded, original);
    });
  });
}
