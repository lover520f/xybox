import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/interfaces/interfaces.dart';

class CacheRepositoryImpl implements ICacheRepository {
  final SharedPreferences _prefs;
  
  CacheRepositoryImpl() : _prefs = GetIt.instance<SharedPreferences>();
  
  @override
  Future<String?> get(String key, {String? rule}) async {
    return _prefs.getString('cache_${rule ?? ""}_$key');
  }
  
  @override
  Future<void> set(String key, String value, {String? rule}) async {
    await _prefs.setString('cache_${rule ?? ""}_$key', value);
  }
  
  @override
  Future<void> delete(String key, {String? rule}) async {
    await _prefs.remove('cache_${rule ?? ""}_$key');
  }
  
  @override
  Future<void> dispose() async {}
}
