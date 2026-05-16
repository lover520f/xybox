import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:dio/dio.dart';
import '../core/utils/logger_util.dart';

/// 爬虫引擎 - 负责加载和执行 JS 爬虫脚本
class SpiderEngine {
  static final SpiderEngine _instance = SpiderEngine._internal();
  factory SpiderEngine() => _instance;
  SpiderEngine._internal();

  final Dio _dio = Dio();
  final Map<String, JavascriptModule> _loadedScripts = {};

  /// 加载爬虫脚本
  Future<void> loadScript(String key, String scriptContent) async {
    try {
      final js = JavascriptObject(scriptContent);
      _loadedScripts[key] = js;
      LoggerUtil.i('加载爬虫脚本：$key');
    } catch (e) {
      LoggerUtil.e('加载脚本失败：$key, 错误：$e');
      rethrow;
    }
  }

  /// 执行 JS 代码
  Future<dynamic> evalJS(String key, String code, [Map<String, dynamic>? params]) async {
    try {
      final script = _loadedScripts[key];
      if (script == null) {
        LoggerUtil.w('脚本未加载：$key');
        return null;
      }
      
      // 构建带参数的执行代码
      String execCode = code;
      if (params != null) {
        for (var entry in params.entries) {
          execCode = execCode.replaceAll('{${entry.key}}', jsonEncode(entry.value));
        }
      }
      
      LoggerUtil.d('执行 JS: ${execCode.substring(0, Math.min(100, execCode.length))}...');
      return script.runtime!.evaluate(execCode);
    } catch (e) {
      LoggerUtil.e('执行 JS 失败：$e');
      return null;
    }
  }

  /// HTTP GET 请求 (供 JS 调用)
  Future<String?> httpGet(String url, {Map<String, String>? headers}) async {
    try {
      final response = await _dio.get(
        url,
        options: Options(headers: headers),
      );
      return response.data is String ? response.data : jsonEncode(response.data);
    } catch (e) {
      LoggerUtil.e('HTTP GET 失败：$url, $e');
      return null;
    }
  }

  /// 清理资源
  void dispose() {
    _loadedScripts.clear();
  }
}

// 辅助类
class JavascriptModule {
  final JavascriptObject? runtime;
  JavascriptModule(this.runtime);
}
