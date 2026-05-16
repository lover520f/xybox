import 'dart:convert';
import 'package:get_it/get_it.dart';
import '../core/interfaces/spider_interface.dart';
import '../core/utils/logger_util.dart';
import 'spider_engine.dart';

/// 爬虫管理器 - 管理多个爬虫源
class SpiderManager {
  static final SpiderManager _instance = SpiderManager._internal();
  factory SpiderManager() => _instance;
  SpiderManager._internal();

  final SpiderEngine _engine = SpiderEngine();
  final Map<String, ISpider> _spiders = {};
  String? _activeSpiderKey;

  /// 初始化爬虫
  Future<void> initialize(Map<String, dynamic> siteConfig) async {
    try {
      final key = siteConfig['key'] as String;
      final name = siteConfig['name'] as String;
      final type = siteConfig['type'] as int;
      final api = siteConfig['api'] as String?;
      final ext = siteConfig['ext'] as String?;

      LoggerUtil.i('初始化爬虫：$name (type=$type)');

      // 根据类型创建不同的爬虫
      ISpider spider;
      if (type == 3) {
        // JS 爬虫
        spider = await _createJSSpider(key, api, ext);
      } else {
        // 其他类型暂不支持
        LoggerUtil.w('不支持的爬虫类型：$type');
        return;
      }

      _spiders[key] = spider;
      _activeSpiderKey = key;
      LoggerUtil.i('爬虫初始化成功：$key');
    } catch (e) {
      LoggerUtil.e('爬虫初始化失败：$e');
      rethrow;
    }
  }

  /// 创建 JS 爬虫
  Future<ISpider> _createJSSpider(String key, String? api, String? ext) async {
    final spider = JSSpider(key: key, apiUrl: api, extConfig: ext);
    await spider.init();
    return spider;
  }

  /// 获取当前爬虫
  ISpider? get activeSpider {
    if (_activeSpiderKey == null) return null;
    return _spiders[_activeSpiderKey];
  }

  /// 切换爬虫
  void switchSpider(String key) {
    if (_spiders.containsKey(key)) {
      _activeSpiderKey = key;
      LoggerUtil.i('切换到爬虫：$key');
    }
  }

  /// 获取所有爬虫
  List<String> get spiderKeys => _spiders.keys.toList();

  /// 清理资源
  void dispose() {
    for (var spider in _spiders.values) {
      spider.destroy();
    }
    _spiders.clear();
    _engine.dispose();
  }
}
