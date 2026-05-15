class ConfigManager {
  static final ConfigManager _instance = ConfigManager._internal();
  factory ConfigManager() => _instance;
  ConfigManager._internal();
  bool _isConfigured = false;
  bool get isConfigured => _isConfigured;
  Future<void> loadConfig(String url, {String type = 'vod'}) async {
    _isConfigured = true;
  }
  Future<void> clearConfig() async { _isConfigured = false; }
}
