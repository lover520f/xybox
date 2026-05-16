import 'dart:convert';
import 'package:dio/dio.dart';
import '../utils/logger_util.dart';

/// TVBox 配置解析器
class ConfigParser {
  static final ConfigParser _instance = ConfigParser._internal();
  factory ConfigParser() => _instance;
  ConfigParser._internal();

  final Dio _dio = Dio();

  /// 加载配置文件
  Future<ConfigData?> loadConfig(String url) async {
    try {
      LoggerUtil.i('加载配置：$url');
      
      String configUrl = url;
      if (!configUrl.endsWith('.json') && !configUrl.endsWith('/')) {
        configUrl = '$url/box.json';
      } else if (configUrl.endsWith('/')) {
        configUrl = '${url}box.json';
      }

      final response = await _dio.get(configUrl, timeout: const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(response.data);
        return ConfigData.fromJson(data);
      }
    } catch (e) {
      LoggerUtil.e('加载配置失败：$e');
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
