import 'package:dio/dio.dart';
import 'dart:convert';
import 'core/utils/logger_util.dart';
import 'core/utils/config_parser.dart';
import 'spider_engine.dart';

/// 爬虫服务 - 统一接口
class SpiderService {
  static final SpiderService _instance = SpiderService._internal();
  factory SpiderService() => _instance;
  SpiderService._internal();

  final Dio _dio = Dio();
  ConfigData? _config;
  SiteData? _currentSite;

  /// 加载配置
  Future<bool> loadConfig(String configUrl) async {
    final parser = ConfigParser();
    _config = await parser.loadConfig(configUrl);
    if (_config != null && _config!.sites.isNotEmpty) {
      _currentSite = _config!.sites.first;
      LoggerUtil.i('加载配置成功：${_config!.videoName}, 站点数：${_config!.sites.length}');
      return true;
    }
    return false;
  }

  /// 获取站点列表
  List<SiteData> getSites() {
    return _config?.sites ?? [];
  }

  /// 切换站点
  bool switchSite(String key) {
    for (var site in _config?.sites ?? []) {
      if (site.key == key) {
        _currentSite = site;
        return true;
      }
    }
    return false;
  }

  /// 获取首页视频列表
  Future<List<VodData>> getHomeVod() async {
    if (_currentSite == null) return [];
    try {
      final result = await _callSpider('homeContent', {});
      if (result != null && result['list'] != null) {
        return (result['list'] as List).map((v) => VodData.fromJson(v)).toList();
      }
    } catch (e) {
      LoggerUtil.e('获取首页失败：$e');
    }
    return [];
  }

  /// 获取分类列表
  Future<List<CateData>> getCates() async {
    if (_currentSite == null) return [];
    try {
      final result = await _callSpider('categoryContent', {'tid': _currentSite!.key});
      if (result != null && result['class'] != null) {
        return (result['class'] as List).map((c) => CateData(
          typeId: c['type_id']?.toString() ?? '',
          typeName: c['type_name']?.toString() ?? '',
        )).toList();
      }
    } catch (e) {
      LoggerUtil.e('获取分类失败：$e');
    }
    return [];
  }

  /// 获取分类视频列表
  Future<List<VodData>> getCateVod(String cateId, int page) async {
    if (_currentSite == null) return [];
    try {
      final result = await _callSpider('categoryContent', {
        'tid': cateId,
        'page': page.toString(),
      });
      if (result != null && result['list'] != null) {
        return (result['list'] as List).map((v) => VodData.fromJson(v)).toList();
      }
    } catch (e) {
      LoggerUtil.e('获取分类视频失败：$e');
    }
    return [];
  }

  /// 搜索视频
  Future<List<VodData>> search(String keyword) async {
    if (_currentSite == null) return [];
    try {
      final result = await _callSpider('searchContent', {'wd': keyword});
      if (result != null && result['list'] != null) {
        return (result['list'] as List).map((v) => VodData.fromJson(v)).toList();
      }
    } catch (e) {
      LoggerUtil.e('搜索失败：$e');
    }
    return [];
  }

  /// 获取视频详情
  Future<VodData?> getVodDetail(String vodId) async {
    if (_currentSite == null) return null;
    try {
      final result = await _callSpider('detailContent', {'ids': vodId});
      if (result != null && result['list'] != null && (result['list'] as List).isNotEmpty) {
        return VodData.fromJson(result['list'][0]);
      }
    } catch (e) {
      LoggerUtil.e('获取详情失败：$e');
    }
    return null;
  }

  /// 获取播放地址
  Future<PlayerData?> getPlayer(String playUrl) async {
    if (_currentSite == null) return null;
    try {
      final result = await _callSpider('playerContent', {'flag': '', 'play': playUrl});
      if (result != null) {
        return PlayerData(
          url: result['url'] ?? '',
          parse: result['parse'] ?? 0,
          header: result['header'] != null ? Map<String, String>.from(result['header']) : {},
        );
      }
    } catch (e) {
      LoggerUtil.e('获取播放地址失败：$e');
    }
    return null;
  }

  /// 调用爬虫方法
  Future<Map<String, dynamic>?> _callSpider(String method, Map<String, String> params) async {
    if (_currentSite == null) return null;

    try {
      // 构建 URL
      String url = _currentSite!.api;
      if (url.contains('?')) {
        url = '$url&method=$method';
      } else {
        url = '$url?method=$method';
      }

      // 添加参数
      params.forEach((key, value) {
        url = '$url&$key=${Uri.encodeComponent(value)}';
      });

      LoggerUtil.d('调用爬虫：$method, URL: $url');

      final response = await _dio.get(url, timeout: const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return json.decode(response.data);
      }
    } catch (e) {
      LoggerUtil.e('调用爬虫失败：$method, $e');
    }
    return null;
  }
}

/// 视频数据
class VodData {
  final String id;
  final String name;
  final String type;
  final String pic;
  final String year;
  final String area;
  final String remark;
  final String content;
  final List<String> playUrls;

  VodData({
    required this.id,
    required this.name,
    this.type = '',
    this.pic = '',
    this.year = '',
    this.area = '',
    this.remark = '',
    this.content = '',
    this.playUrls = const [],
  });

  factory VodData.fromJson(Map<String, dynamic> json) {
    final playUrls = <String>[];
    if (json['playUrl'] != null) {
      playUrls.add(json['playUrl']);
    }
    if (json['playurls'] != null) {
      playUrls.addAll((json['playurls'] as String).split('#'));
    }

    return VodData(
      id: json['vod_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['vod_name']?.toString() ?? json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      pic: json['vod_pic']?.toString() ?? json['pic']?.toString() ?? '',
      year: json['vod_year']?.toString() ?? json['year']?.toString() ?? '',
      area: json['vod_area']?.toString() ?? json['area']?.toString() ?? '',
      remark: json['vod_remark']?.toString() ?? json['remark']?.toString() ?? '',
      content: json['vod_content']?.toString() ?? json['content']?.toString() ?? '',
      playUrls: playUrls,
    );
  }
}

/// 播放数据
class PlayerData {
  final String url;
  final int parse;
  final Map<String, String> header;

  PlayerData({
    required this.url,
    this.parse = 0,
    this.header = const {},
  });
}
