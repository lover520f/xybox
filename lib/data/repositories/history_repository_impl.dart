import '../../core/interfaces/interfaces.dart';
import '../database/app_database.dart';
class HistoryRepositoryImpl implements IHistoryRepository {
  final AppDatabase _db = AppDatabase();
  @override
  Future<void> addHistory({required String vodId, required String vodName, required String sourceKey, String? vodPic, String? episode}) async {
    await _db.addHistory(vodId: vodId, vodName: vodName, vodPic: vodPic, sourceKey: sourceKey, episode: episode);
  }
  @override
  Future<List<Map<String, dynamic>>> getHistories({int limit = 100}) async => await _db.getHistories(limit: limit);
  @override
  Future<void> clearHistory() async => await _db.clearHistory();
  @override
  Future<void> dispose() async {}
}
