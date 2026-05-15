import '../../core/interfaces/interfaces.dart';
import '../database/app_database.dart';
import '../database/tables.dart';
class FavoriteRepositoryImpl implements IFavoriteRepository {
  final AppDatabase _db;
  FavoriteRepositoryImpl({required AppDatabase db}) : _db = db;
  @override
  Future<void> addFavorite({required String vodId, required String vodName, required String sourceKey, String? vodPic}) async {
    await _db.addFavorite(FavoriteEntity(vodId: vodId, vodName: vodName, vodPic: vodPic, sourceKey: sourceKey, createTime: DateTime.now()));
  }
  @override
  Future<List<FavoriteEntity>> getFavorites() async => await _db.getFavorites();
  @override
  Future<bool> isFavorite(String vodId, String sourceKey) async => await _db.isFavorite(vodId, sourceKey);
  @override
  Future<void> dispose() async {}
}
