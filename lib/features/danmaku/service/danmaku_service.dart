import 'dart:async';
import 'dart:math';
import '../../../core/utils/logger_util.dart';

/// 弹幕数据
class DanmakuItem {
  final String id;
  final String content;
  final double startTime;
  final String color;
  final DanmakuMode mode;
  final String? userId;

  DanmakuItem({
    required this.id,
    required this.content,
    required this.startTime,
    this.color = '#FFFFFF',
    this.mode = DanmakuMode.scroll,
    this.userId,
  });

  factory DanmakuItem.fromJson(Map<String, dynamic> json) {
    return DanmakuItem(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      content: json['content'] ?? json['msg'] ?? '',
      startTime: (json['time'] ?? json['start_time'] ?? 0).toDouble(),
      color: json['color'] ?? '#FFFFFF',
      mode: DanmakuMode.values.firstWhere(
        (e) => e.toString() == 'DanmakuMode.${json['mode']}',
        orElse: () => DanmakuMode.scroll,
      ),
      userId: json['user_id'] ?? json['uid'],
    );
  }
}

/// 弹幕模式
enum DanmakuMode {
  scroll,
  top,
  bottom,
}

/// 弹幕服务
class DanmakuService {
  static final DanmakuService _instance = DanmakuService._internal();
  factory DanmakuService() => _instance;
  DanmakuService._internal();

  final List<DanmakuItem> _danmakus = [];
  final List<DanmakuItem> _visibleDanmakus = [];
  final Random _random = Random();
  
  double _currentPosition = 0;
  double _danmakuSpeed = 300;

  /// 加载弹幕
  Future<void> loadDanmakus(List<DanmakuItem> danmakus) async {
    _danmakus.clear();
    _danmakus.addAll(danmakus);
    _danmakus.sort((a, b) => a.startTime.compareTo(b.startTime));
    LoggerUtil.i('加载弹幕：${_danmakus.length} 条');
  }

  /// 开始播放
  void play() {}

  /// 暂停播放
  void pause() {}

  /// 停止播放
  void stop() {
    _visibleDanmakus.clear();
  }

  /// 跳转到指定位置
  void seek(double position) {
    _currentPosition = position;
    _visibleDanmakus.clear();
  }

  /// 发送弹幕
  void sendDanmaku(String content) {
    final danmaku = DanmakuItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      startTime: _currentPosition,
      color: '#FFFFFF',
      mode: DanmakuMode.scroll,
    );
    _danmakus.add(danmaku);
  }

  /// 更新当前位置
  void updatePosition(double position) {
    _currentPosition = position;
  }

  /// 获取当前应显示的弹幕
  List<DanmakuItem> getVisibleDanmakus(double screenWidth) {
    final now = _currentPosition;
    final toRemoveIds = <String>[];

    for (var item in _visibleDanmakus) {
      final elapsed = now - item.startTime;
      final moveDistance = elapsed * _danmakuSpeed;
      if (moveDistance > screenWidth + 500) {
        toRemoveIds.add(item.id);
      }
    }

    _visibleDanmakus.removeWhere((item) => toRemoveIds.contains(item.id));

    for (var danmaku in _danmakus) {
      if (!_visibleDanmakus.any((i) => i.id == danmaku.id) &&
          danmaku.startTime >= now - 1 &&
          danmaku.startTime <= now + 1) {
        _visibleDanmakus.add(danmaku);
      }
    }

    return List.from(_visibleDanmakus);
  }

  void dispose() {
    stop();
    _danmakus.clear();
    _visibleDanmakus.clear();
  }
}
