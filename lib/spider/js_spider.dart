import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:dio/dio.dart';
import '../core/interfaces/spider_interface.dart';
import '../core/utils/logger_util.dart';
import 'spider_engine.dart';

/// JS 爬虫实现
class JSSpider implements ISpider {
  final String key;
  final String? apiUrl;
  final String? extConfig;
  
  JavascriptObject? _jsRuntime;
  final Dio _dio = Dio();
  
  Map<String, dynamic>? _initParams;

  JSSpider({
    required this.key,
    this.apiUrl,
    this.extConfig,
  });

  @override
  Future<void> init() async {
    try {
      LoggerUtil.i('初始化 JS 爬虫：$key');
      
      // 如果 apiUrl 是 JS 文件 URL，加载脚本
      if (apiUrl != null && apiUrl!.endsWith('.js')) {
        final response = await _dio.get(apiUrl!);
        final scriptContent = response.data as String;
        _jsRuntime = JavascriptObject(scriptContent);
        LoggerUtil.i('JS 脚本加载成功');
      }
      
      // 解析 ext 配置
      if (extConfig != null) {
        try {
          _initParams = jsonDecode(extConfig!);
        } catch (e) {
          _initParams = {'ext': extConfig};
        }
      }
      
      // 调用爬虫的 init 函数
      await _callJSFunction('init', params: [_initParams]);
      
      LoggerUtil.i('JS 爬虫初始化完成');
    } catch (e) {
      LoggerUtil.e('JS 爬虫初始化失败：$e');
      rethrow;
    }
  }

  @override
  Future<dynamic> homeContent() async {
    try {
      LoggerUtil.d('调用 homeContent');
      final result = await _callJSFunction('home');
      return _parseResult(result);
    } catch (e) {
      LoggerUtil.e('homeContent 失败：$e');
      return {'classes': [], 'list': []};
    }
  }

  @override
  Future<dynamic> categoryContent({String? typeId, String? page, bool? filter}) async {
    try {
      LoggerUtil.d('调用 categoryContent: typeId=$typeId, page=$page');
      final result = await _callJSFunction('category', params: [typeId, page, filter ?? false]);
      return _parseResult(result);
    } catch (e) {
      LoggerUtil.e('categoryContent 失败：$e');
      return {'list': [], 'total': 0};
    }
  }

  @override
  Future<dynamic> detailContent(String id) async {
    try {
      LoggerUtil.d('调用 detailContent: id=$id');
      final result = await _callJSFunction('detail', params: [id]);
      return _parseResult(result);
    } catch (e) {
      LoggerUtil.e('detailContent 失败：$e');
      return null;
    }
  }

  @override
  Future<dynamic> searchContent(String key, {bool quick = false}) async {
    try {
      LoggerUtil.d('调用 searchContent: key=$key');
      final result = await _callJSFunction('search', params: [key, quick]);
      return _parseResult(result);
    } catch (e) {
      LoggerUtil.e('searchContent 失败：$e');
      return {'list': []};
    }
  }

  @override
  Future<dynamic> playerContent(String flag, String url, {List<String>? vipFlags}) async {
    try {
      LoggerUtil.d('调用 playerContent: flag=$flag, url=$url');
      final result = await _callJSFunction('player', params: [flag, url, vipFlags]);
      return _parseResult(result);
    } catch (e) {
      LoggerUtil.e('playerContent 失败：$e');
      return {'url': url, 'parse': 0};
    }
  }

  @override
  void destroy() {
    _jsRuntime = null;
    LoggerUtil.i('JS 爬虫已销毁：$key');
  }

  /// 调用 JS 函数
  Future<dynamic> _callJSFunction(String functionName, {List<dynamic>? params}) async {
    if (_jsRuntime == null) {
      throw Exception('JS 运行时未初始化');
    }
    
    try {
      String code;
      if (params != null && params.isNotEmpty) {
        final paramsStr = params.map((p) {
          if (p == null) return 'null';
          if (p is bool) return p.toString();
          if (p is num) return p.toString();
          return jsonEncode(p);
        }).join(',');
        code = '$functionName($paramsStr)';
      } else {
        code = '$functionName()';
      }
      
      LoggerUtil.d('执行 JS: $code');
      final result = await _jsRuntime!.runtime!.evaluate(code);
      return result;
    } catch (e) {
      LoggerUtil.e('JS 执行失败：$functionName, $e');
      rethrow;
    }
  }

  /// 解析结果
  dynamic _parseResult(dynamic result) {
    if (result == null) return null;
    if (result is String) {
      try {
        return jsonDecode(result);
      } catch (e) {
        return {'raw': result};
      }
    }
    return result;
  }
}
