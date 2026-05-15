import '../../core/interfaces/interfaces.dart';
import '../database/app_database.dart';
class FavoriteRepositoryImpl implements IFavoriteRepository {
  final AppDatabase _db = AppDatabase();
  @override
  Future<void> addFavorite({required String vodId, required String vodName, required String sourceKey, String? vodPic}) async {
    await _db.addFavorite(vodId: vodId, vodName: vodName, vodPic: vodPic, sourceKey: sourceKey);
  }
  @override
  Future<List<Map<String, dynamic>>> getFavorites() async => await _db.getFavorites();
  @override
  Future<bool> isFavorite(String vodId, String? sourceKey) async => await _db.isFavorite(vodId, sourceKey);
  @override
  Future<void> dispose() async {}
}
