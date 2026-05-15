#!/bin/bash
cd /workspace/lib

# Core Constants
cat > core/constants/api_endpoints.dart << 'EOF'
class ApiEndpoints {
  static const String device = '/device';
  static const String media = '/media';
  static const String playControl = '/play/control';
  static const String push = '/play/push';
  static const String cache = '/cache';
  static const String file = '/file';
}
EOF

cat > core/constants/app_constants.dart << 'EOF'
class AppConstants {
  static const String appName = 'XYBox';
  static const String appVersion = '1.0.0';
  static const int defaultTimeout = 30;
  static const int maxHistoryDays = 60;
}
EOF

cat > core/constants/constants.dart << 'EOF'
export 'api_endpoints.dart';
export 'app_constants.dart';
EOF

# Core Enums
cat > core/enums/enums.dart << 'EOF'
enum SiteType { apk, jar, xml, js, py }
enum PlayerStateEnum { idle, loading, playing, paused, completed, error }
enum DanmakuMode { scroll, top, bottom }
EOF

# Core Extensions
cat > core/extensions/extensions.dart << 'EOF'
extension StringExt on String {
  bool get isNotEmpty => this.isNotEmpty;
  String get trim => this.trim();
}

extension ListExt<T> on List<T> {
  bool get isNotEmpty => this.isNotEmpty;
  T? get firstOrNull => isEmpty ? null : first;
}
EOF

# Core Interfaces
cat > core/interfaces/interfaces.dart << 'EOF'
abstract class IRepository { Future<void> dispose(); }
abstract class IDataSource { Future<void> initialize(); Future<void> dispose(); }
abstract class ILocalDataSource implements IDataSource {
  Future<T?> get<T>(String key);
  Future<void> set<T>(String key, T value);
  Future<void> delete(String key);
  Future<bool> contains(String key);
  Future<void> clear();
}
abstract class INetworkDataSource implements IDataSource {
  Future<dynamic> get(String url, {Map<String, dynamic>? params});
  Future<dynamic> post(String url, {dynamic data, Map<String, dynamic>? params});
}
abstract class IConfigRepository implements IRepository {
  Future<void> saveConfigUrl(String url, {String type});
  Future<String?> getConfigUrl({String type});
}
abstract class IHistoryRepository implements IRepository {
  Future<void> addHistory({required String vodId, required String vodName, required String sourceKey});
  Future<List<dynamic>> getHistories({int limit});
  Future<void> clearHistory();
}
abstract class IFavoriteRepository implements IRepository {
  Future<void> addFavorite({required String vodId, required String vodName, required String sourceKey});
  Future<List<dynamic>> getFavorites();
  Future<bool> isFavorite(String vodId, String sourceKey);
}
abstract class ICacheRepository implements IRepository {
  Future<String?> get(String key, {String? rule});
  Future<void> set(String key, String value, {String? rule});
  Future<void> delete(String key, {String? rule});
}
abstract class IVodRepository implements IRepository {}
abstract class ILiveRepository implements IRepository {}
EOF

cat > core/interfaces/export.dart << 'EOF'
export 'interfaces.dart';
export 'spider_interface.dart';
EOF

cat > core/interfaces/spider_interface.dart << 'EOF'
abstract class ISpider {
  Future<void> init();
  Future<dynamic> homeContent();
  Future<dynamic> categoryContent({String? typeId, String? page, String? filter});
  Future<dynamic> detailContent(String id);
  Future<dynamic> searchContent(String key, {bool quick = false});
  Future<dynamic> playerContent(String flag, String url, {List<String>? vipFlags});
  void destroy();
}
EOF

# Core Utils
cat > core/utils/logger_util.dart << 'EOF'
import 'dart:developer';
class LoggerUtil {
  static void i(String message, {String tag = 'XYBox'}) => log('[$tag] [I] $message');
  static void d(String message, {String tag = 'XYBox'}) => log('[$tag] [D] $message');
  static void e(String message, {Object? error, String tag = 'XYBox'}) => log('[$tag] [E] $message${error != null ? ": $error" : ""}');
  static void w(String message, {String tag = 'XYBox'}) => log('[$tag] [W] $message');
}
EOF

cat > core/utils/date_util.dart << 'EOF'
class DateUtil {
  static String format(DateTime dt) => '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  static String formatRelative(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays > 7) return format(dt);
    if (diff.inDays > 0) return '${diff.inDays}天前';
    if (diff.inHours > 0) return '${diff.inHours}小时前';
    if (diff.inMinutes > 0) return '${diff.inMinutes}分钟前';
    return '刚刚';
  }
}
EOF

cat > core/utils/file_util.dart << 'EOF'
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
class FileUtil {
  static Future<String> getCachePath([String? subDir]) async {
    final dir = await getTemporaryDirectory();
    return subDir != null ? path.join(dir.path, subDir) : dir.path;
  }
  static Future<String> getAppPath([String? subDir]) async {
    final dir = await getApplicationDocumentsDirectory();
    return subDir != null ? path.join(dir.path, subDir) : dir.path;
  }
}
EOF

cat > core/utils/json_util.dart << 'EOF'
import 'dart:convert';
class JsonUtil {
  static T? parse<T>(String? json, T Function(Map<String, dynamic>) fromJson) {
    if (json == null || json.isEmpty) return null;
    try {
      final data = jsonDecode(json);
      if (data is Map<String, dynamic>) return fromJson(data);
    } catch (e) {}
    return null;
  }
  static String stringify(Object? obj) => obj != null ? jsonEncode(obj) : '';
}
EOF

cat > core/utils/crypto_util.dart << 'EOF'
import 'dart:convert';
import 'package:crypto/crypto.dart';
class CryptoUtil {
  static String md5(String input) => md5.convert(utf8.encode(input)).toString();
  static String sha1(String input) => sha1.convert(utf8.encode(input)).toString();
  static String sha256(String input) => sha256.convert(utf8.encode(input)).toString();
  static String base64Encode(String input) => base64.encode(utf8.encode(input));
  static String base64Decode(String input) => utf8.decode(base64.decode(input));
}
EOF

cat > core/utils/utils.dart << 'EOF'
export 'logger_util.dart';
export 'date_util.dart';
export 'file_util.dart';
export 'json_util.dart';
export 'crypto_util.dart';
EOF

# Core Services
cat > core/services/event_bus.dart << 'EOF'
import 'dart:async';
class EventBus {
  static final EventBus _instance = EventBus._internal();
  factory EventBus() => _instance;
  EventBus._internal();
  final StreamController _controller = StreamController.broadcast();
  Stream<T> on<T>() => _controller.stream.where((e) => e is T).cast<T>();
  void emit<T>(T event) => _controller.add(event);
  void dispose() => _controller.close();
}
EOF

cat > core/services/config_manager.dart << 'EOF'
import '../data/database/app_database.dart';
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
EOF

# Core DI
cat > core/di/injection.dart << 'EOF'
import 'package:get_it/get_it.dart';
import '../../data/di/injection.dart' as data;
import '../../network/di/injection.dart' as network;
import '../../spider/di/injection.dart' as spider;
import '../interfaces/interfaces.dart';
import '../utils/logger_util.dart';
final GetIt sl = GetIt.instance;
Future<void> configureDependencies() async {
  LoggerUtil.i('开始配置依赖注入...');
  data.configureDataDependencies();
  network.configureNetworkDependencies();
  spider.configureSpiderDependencies();
  await sl<ILocalDataSource>().initialize();
  await sl<INetworkDataSource>().initialize();
  LoggerUtil.i('依赖注入配置完成');
}
EOF

cat > core/core.dart << 'EOF'
export 'constants/constants.dart';
export 'enums/enums.dart';
export 'extensions/extensions.dart';
export 'interfaces/interfaces.dart';
export 'utils/utils.dart';
export 'di/injection.dart';
EOF

echo "Core files created"
