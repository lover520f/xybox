import 'dart:convert';
import 'package:dio/dio.dart';
import '../utils/logger_util.dart';

class ConfigParser {
  static final ConfigParser _instance = ConfigParser._internal();
  factory ConfigParser() => _instance;
  ConfigParser._internal();

  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
    headers: {
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      'Accept': 'application/json, text/plain, */*',
      'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8',
    },
  ));

  Future<ConfigData?> loadConfig(String url) async {
    try {
      LoggerUtil.i('尝试加载配置：$url');
      
      String configUrl = url.trim();
      if (configUrl.endsWith('/')) {
        configUrl = configUrl.substring(0, configUrl.length - 1);
      }
      if (!configUrl.endsWith('.json')) {
        configUrl = '$configUrl/box.json';
      }

      LoggerUtil.d('实际请求 URL: $configUrl');

      final response = await _dio.get(configUrl);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.data);
        LoggerUtil.i('配置加载成功：${data['videoName'] ?? "未知"}, 站点数：${(data['sites'] as List?)?.length ?? 0}');
        return ConfigData.fromJson(data);
      }
    } on DioException catch (e) {
      String errorMsg = '连接失败';
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          errorMsg = '连接超时（20 秒）';
          break;
        case DioExceptionType.receiveTimeout:
          errorMsg = '响应超时';
          break;
        case DioExceptionType.connectionError:
          errorMsg = '连接错误，请检查网络';
          break;
        case DioExceptionType.badResponse:
          errorMsg = '服务器错误：${e.response?.statusCode}';
          break;
        default:
          errorMsg = '错误：${e.message}';
      }
      LoggerUtil.e('$errorMsg - $url');
    } catch (e) {
      LoggerUtil.e('配置加载失败：$e');
    }
    return null;
  }
}

class ConfigData {
  final String videoName;
  final String logo;
  final List<SiteData> sites;
  final List<dynamic> lives;
  final List<dynamic> parses;

  ConfigData({this.videoName = '', this.logo = '', this.sites = const [], this.lives = const [], this.parses = const []});

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

class SiteData {
  final String key;
  final String name;
  final String type;
  final String api;
  final String searchUrl;
  final dynamic ext;

  SiteData({required this.key, required this.name, required this.type, required this.api, this.searchUrl = '', this.ext});

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

class CateData {
  final String typeId;
  final String typeName;
  CateData({required this.typeId, required this.typeName});
}
