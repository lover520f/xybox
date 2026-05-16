import 'dart:convert';
import 'package:dio/dio.dart';
import '../utils/logger_util.dart';

/// TVBox 配置解析器
class ConfigParser {
  static final ConfigParser _instance = ConfigParser._internal();
  factory ConfigParser() => _instance;
  ConfigParser._internal();

  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
      'Accept': 'application/json, text/plain, */*',
    },
  ));

  /// 加载配置文件
  Future<ConfigData?> loadConfig(String url) async {
    try {
      LoggerUtil.i('加载配置：$url');
      
      String configUrl = url.trim();
      // 移除末尾斜杠
      if (configUrl.endsWith('/')) {
        configUrl = configUrl.substring(0, configUrl.length - 1);
      }
      // 追加 /box.json
      if (!configUrl.endsWith('.json')) {
        configUrl = '$configUrl/box.json';
      }

      LoggerUtil.d('实际请求 URL: $configUrl');

      final response = await _dio.get(configUrl);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.data);
        LoggerUtil.i('配置加载成功：${data['videoName'] ?? "未知"}, 站点数：${(data['sites'] as List?)?.length ?? 0}');
        return ConfigData.fromJson(data);
      } else {
        LoggerUtil.e('配置加载失败：HTTP ${response.statusCode}');
      }
    } on DioException catch (e) {
      LoggerUtil.e('Dio 错误：${e.type}, ${e.message}');
      LoggerUtil.e('错误详情：${e.error}');
    } catch (e) {
      LoggerUtil.e('配置加载失败：$e');
    }
    return null;
  }
}

/// 配置数据结构
class ConfigData {
  final String videoName;
  final String logo;
  final List<SiteData> sites;
  final List<dynamic> lives;
  final List<dynamic> parses;

  ConfigData({
    this.videoName = '',
    this.logo = '',
    this.sites = const [],
    this.lives = const [],
    this.parses = const [],
  });

  factory ConfigData.fromJson(Map<String, dynamic> json) {
    final sites = <SiteData>[];
    for (var site in json['sites'] ?? []) {
      sites.add(SiteData.fromJson(site));
    }

    return ConfigData(
      videoName: json['videoName'] ?? '',
      logo: json['logo'] ?? '',
      sites: sites,
      lives: json['lives'] ?? [],
      parses: json['parses'] ?? [],
    );
  }
}

/// 站点数据
class SiteData {
  final String key;
  final String name;
  final String type;
  final String api;
  final String searchUrl;
  final dynamic ext;

  SiteData({
    required this.key,
    required this.name,
    required this.type,
    required this.api,
    this.searchUrl = '',
    this.ext,
  });

  factory SiteData.fromJson(Map<String, dynamic> json) {
    return SiteData(
      key: json['key'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '3',
      api: json['api'] ?? '',
      searchUrl: json['searchUrl'] ?? '',
      ext: json['ext'],
    );
  }
}

/// 分类数据
class CateData {
  final String typeId;
  final String typeName;

  CateData({
    required this.typeId,
    required this.typeName,
  });
}

/// 直播频道
class LiveChannel {
  final String name;
  final List<String> urls;

  LiveChannel({
    required this.name,
    required this.urls,
  });
}
