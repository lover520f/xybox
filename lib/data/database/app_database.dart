import 'dart:async';

// 简化的数据库实现，避免复杂的代码生成问题
class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  AppDatabase._internal();
  
  final List<Map<String, dynamic>> _histories = [];
  final List<Map<String, dynamic>> _favorites = [];
  final Map<String, String> _caches = {};
  
  Future<void> addHistory({required String vodId, required String vodName, String? vodPic, String? sourceKey, String? episode}) async {
    _histories.add({
      'vodId': vodId, 'vodName': vodName, 'vodPic': vodPic,
      'sourceKey': sourceKey, 'episode': episode, 'watchTime': DateTime.now()
    });
  }
  
  Future<List<Map<String, dynamic>>> getHistories({int limit = 100}) async {
    return _histories.reversed.take(limit).toList();
  }
  
  Future<void> clearHistory() async { _histories.clear(); }
  
  Future<void> addFavorite({required String vodId, required String vodName, String? vodPic, String? sourceKey}) async {
    _favorites.add({
      'vodId': vodId, 'vodName': vodName, 'vodPic': vodPic,
      'sourceKey': sourceKey, 'createTime': DateTime.now()
    });
  }
  
  Future<List<Map<String, dynamic>>> getFavorites() async {
    return _favorites.reversed.toList();
  }
  
  Future<bool> isFavorite(String vodId, String? sourceKey) async {
    return _favorites.any((f) => f['vodId'] == vodId && f['sourceKey'] == sourceKey);
  }
  
  Future<void> setCache(String key, String value) async { _caches[key] = value; }
  Future<String?> getCache(String key) async => _caches[key];
}
