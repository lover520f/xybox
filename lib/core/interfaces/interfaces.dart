abstract class IRepository { Future<void> dispose(); }
abstract class IDataSource { Future<void> initialize(); Future<void> dispose(); }
abstract class ILocalDataSource implements IDataSource {
  Future<T?> get<T>(String key);
  Future<void> set<T>(String key, T value);
  Future<void> delete(String key);
  Future<bool> contains(String key);
  Future<void> clear();
}
abstract class INetworkDataSource implements IDataSource {
  Future<dynamic> get(String url, {Map<String, dynamic>? params});
  Future<dynamic> post(String url, {dynamic data, Map<String, dynamic>? params});
}
abstract class IConfigRepository implements IRepository {
  Future<void> saveConfigUrl(String url, {String type});
  Future<String?> getConfigUrl({String type});
}
abstract class IHistoryRepository implements IRepository {
  Future<void> addHistory({required String vodId, required String vodName, required String sourceKey});
  Future<List<dynamic>> getHistories({int limit});
  Future<void> clearHistory();
}
abstract class IFavoriteRepository implements IRepository {
  Future<void> addFavorite({required String vodId, required String vodName, required String sourceKey});
  Future<List<dynamic>> getFavorites();
  Future<bool> isFavorite(String vodId, String sourceKey);
}
abstract class ICacheRepository implements IRepository {
  Future<String?> get(String key, {String? rule});
  Future<void> set(String key, String value, {String? rule});
  Future<void> delete(String key, {String? rule});
}
abstract class IVodRepository implements IRepository {}
abstract class ILiveRepository implements IRepository {}
