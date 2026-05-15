import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/interfaces/interfaces.dart';

class ConfigRepositoryImpl implements IConfigRepository {
  final SharedPreferences _prefs;
  
  ConfigRepositoryImpl() : _prefs = GetIt.instance<SharedPreferences>();
  
  @override
  Future<void> saveConfigUrl(String url, {String type = 'vod'}) async {
    await _prefs.setString('${type}_config_url', url);
  }
  
  @override
  Future<String?> getConfigUrl({String type = 'vod'}) async {
    return _prefs.getString('${type}_config_url');
  }
  
  @override
  Future<void> dispose() async {}
}
