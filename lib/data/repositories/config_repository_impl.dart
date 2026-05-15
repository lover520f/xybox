import '../../core/interfaces/interfaces.dart';
import '../datasources/local_datasource_impl.dart';
import '../database/app_database.dart';
class ConfigRepositoryImpl implements IConfigRepository {
  final ILocalDataSource _local;
  final AppDatabase _db;
  ConfigRepositoryImpl({required ILocalDataSource local, required AppDatabase db}) : _local = local, _db = db;
  @override
  Future<void> saveConfigUrl(String url, {String type = 'vod'}) async {
    await _local.set('${type}_config_url', url);
  }
  @override
  Future<String?> getConfigUrl({String type = 'vod'}) async {
    return await _local.get<String>('${type}_config_url');
  }
  @override
  Future<void> dispose() async {}
}
