import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'tables.dart';
part 'app_database.drift';
@DriftDatabase(tables: [History, Favorites, Configs, Caches, SearchHistories, Epgs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'xybox.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
  @override
  int get schemaVersion => 1;
  Future<void> addHistory(HistoryEntity history) async {
    await into(history).insert(history, mode: InsertMode.insertOrReplace);
  }
  Future<List<HistoryEntity>> getHistories({int limit = 100}) async {
    return (select(history)..orderBy([(t) => OrderingTerm.desc(t.watchTime)])..limit(limit)).get();
  }
  Future<void> clearHistory() async { await delete(history).go(); }
  Future<void> addFavorite(FavoriteEntity favorite) async {
    await into(favorites).insert(favorite, mode: InsertMode.insertOrReplace);
  }
  Future<List<FavoriteEntity>> getFavorites() async {
    return (select(favorites)..orderBy([(t) => OrderingTerm.desc(t.createTime)])).get();
  }
  Future<bool> isFavorite(String vodId, String sourceKey) async {
    final list = await (select(favorites)..where((t) => t.vodId.equals(vodId) & t.sourceKey.equals(sourceKey))).get();
    return list.isNotEmpty;
  }
  Future<void> setCache(CacheEntity cache) async {
    await into(caches).insert(cache, mode: InsertMode.insertOrReplace);
  }
  Future<String?> getCache(String key, {String? rule}) async {
    final list = await (select(caches)..where((t) => t.key.equals('cache_${rule ?? ""}_$key'))).get();
    return list.isNotEmpty ? list.first.value : null;
  }
}
