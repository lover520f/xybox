import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/logger_util.dart';

class FavoriteService {
  static final FavoriteService _instance = FavoriteService._internal();
  factory FavoriteService() => _instance;
  FavoriteService._internal();

  final List<Map<String, dynamic>> _favorites = [];

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('favorites') ?? '[]';
    _favorites.clear();
    _favorites.addAll((json.decode(jsonStr) as List).map((e) => Map<String, dynamic>.from(e)).toList());
    LoggerUtil.i('加载收藏：${_favorites.length}个');
  }

  List<Map<String, dynamic>> get favorites => List.from(_favorites);

  bool isFavorite(String id) {
    return _favorites.any((f) => f['id'] == id);
  }

  Future<bool> add(Map<String, dynamic> vod) async {
    if (isFavorite(vod['id']?.toString() ?? '')) return false;
    _favorites.add({
      'id': vod['id'],
      'name': vod['name'],
      'pic': vod['pic'],
      'type': vod['type'],
      'year': vod['year'],
      'remark': vod['remark'],
      'addedTime': DateTime.now().toIso8601String(),
    });
    await _save();
    return true;
  }

  Future<bool> remove(String id) async {
    final index = _favorites.indexWhere((f) => f['id'] == id);
    if (index == -1) return false;
    _favorites.removeAt(index);
    await _save();
    return true;
  }

  Future<bool> toggle(Map<String, dynamic> vod) async {
    final id = vod['id']?.toString() ?? '';
    if (isFavorite(id)) {
      return await remove(id);
    } else {
      return await add(vod);
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('favorites', json.encode(_favorites));
  }

  Future<void> clear() async {
    _favorites.clear();
    await _save();
  }
}
