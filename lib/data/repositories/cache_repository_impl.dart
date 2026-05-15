import '../../core/interfaces/interfaces.dart';
import '../database/app_database.dart';
import '../database/tables.dart';
class CacheRepositoryImpl implements ICacheRepository {
  final AppDatabase _db;
  CacheRepositoryImpl({required AppDatabase db}) : _db = db;
  @override
  Future<String?> get(String key, {String? rule}) async => await _db.getCache(key, rule: rule);
  @override
  Future<void> set(String key, String value, {String? rule}) async {
    await _db.setCache(CacheEntity(key: 'cache_${rule ?? ""}_$key', value: value, createTime: DateTime.now()));
  }
  @override
  Future<void> delete(String key, {String? rule}) async {}
  @override
  Future<void> dispose() async {}
}
