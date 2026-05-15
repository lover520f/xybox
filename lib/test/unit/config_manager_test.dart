import 'package:flutter_test/flutter_test.dart';
import 'package:xybox/core/services/config_manager.dart';

void main() {
  group('ConfigManager Tests', () {
    late ConfigManager configManager;

    setUp(() {
      configManager = ConfigManager();
    });

    test('should start with isConfigured false', () {
      expect(configManager.isConfigured, false);
    });

    test('should set isConfigured to true after loadConfig', () async {
      await configManager.loadConfig('https://example.com/config');
      expect(configManager.isConfigured, true);
    });

    test('should set isConfigured to false after clearConfig', () async {
      await configManager.loadConfig('https://example.com/config');
      await configManager.clearConfig();
      expect(configManager.isConfigured, false);
    });
  });
}
