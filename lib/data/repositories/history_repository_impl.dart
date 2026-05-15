import '../../core/interfaces/interfaces.dart';
import '../database/app_database.dart';
import '../database/tables.dart';
class HistoryRepositoryImpl implements IHistoryRepository {
  final AppDatabase _db;
  HistoryRepositoryImpl({required AppDatabase db}) : _db = db;
  @override
  Future<void> addHistory({required String vodId, required String vodName, required String sourceKey, String? vodPic, String? episode}) async {
    await _db.addHistory(HistoryEntity(vodId: vodId, vodName: vodName, vodPic: vodPic, sourceKey: sourceKey, episode: episode, watchTime: DateTime.now()));
  }
  @override
  Future<List<HistoryEntity>> getHistories({int limit = 100}) async => await _db.getHistories(limit: limit);
  @override
  Future<void> clearHistory() async => await _db.clearHistory();
  @override
  Future<void> dispose() async {}
}
