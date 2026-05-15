#!/bin/bash
cd /workspace/lib/data

# Models
cat > models/result_model.dart << 'EOF'
import 'package:freezed_annotation/freezed_annotation.dart';
part 'result.freezed.dart';
part 'result.g.dart';
@freezed
class Result<T> with _$Result<T> {
  const factory Result({required bool success, T? data, String? error}) = _Result;
  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
}
EOF

cat > models/vod_model.dart << 'EOF'
import 'package:freezed_annotation/freezed_annotation.dart';
part 'vod.freezed.dart';
part 'vod.g.dart';
@freezed
class Vod with _$Vod {
  const factory Vod({required String id, required String name, String? pic, String? year, String? area, String? director, String? actor, String? remark, String? typeId, String? typeName, double? score}) = _Vod;
  factory Vod.fromJson(Map<String, dynamic> json) => _$VodFromJson(json);
}
EOF

cat > models/class_model.dart << 'EOF'
import 'package:freezed_annotation/freezed_annotation.dart';
part 'class.freezed.dart';
part 'class.g.dart';
@freezed
class Class with _$Class {
  const factory Class({required String typeId, required String typeName, int? ratio}) = _Class;
  factory Class.fromJson(Map<String, dynamic> json) => _$ClassFromJson(json);
}
EOF

cat > models/filter_model.dart << 'EOF'
import 'package:freezed_annotation/freezed_annotation.dart';
part 'filter.freezed.dart';
part 'filter.g.dart';
@freezed
class Filter with _$Filter {
  const factory Filter({required String key, required String name, String? value, bool? init, bool? selected}) = _Filter;
  factory Filter.fromJson(Map<String, dynamic> json) => _$FilterFromJson(json);
}
EOF

cat > models/config_model.dart << 'EOF'
import 'package:freezed_annotation/freezed_annotation.dart';
part 'config.freezed.dart';
part 'config.g.dart';
@freezed
class VodConfig with _$VodConfig {
  const factory VodConfig({String? spider, String? wallpaper, String? logo, @Default([]) List<Site> sites, @Default([]) List<Parse> parses, @Default([]) List<Live> lives}) = _VodConfig;
  factory VodConfig.fromJson(Map<String, dynamic> json) => _$VodConfigFromJson(json);
}
@freezed
class Site with _$Site {
  const factory Site({required String key, required String name, @Default(3) int type, String? api, String? ext, String? jar, @Default(1) int searchable, @Default(1) int changeable}) = _Site;
  factory Site.fromJson(Map<String, dynamic> json) => _$SiteFromJson(json);
}
@freezed
class Parse with _$Parse {
  const factory Parse({String? name, @Default(0) int type, String? url}) = _Parse;
  factory Parse.fromJson(Map<String, dynamic> json) => _$ParseFromJson(json);
}
@freezed
class Live with _$Live {
  const factory Live({String? name, String? url, String? api, String? ext, @Default([]) List<Group> groups}) = _Live;
  factory Live.fromJson(Map<String, dynamic> json) => _$LiveFromJson(json);
}
@freezed
class Group with _$Group {
  const factory Group({String? name, @Default([]) List<Channel> channel}) = _Group;
  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}
@freezed
class Channel with _$Channel {
  const factory Channel({String? name, @Default([]) List<String> urls, String? epg}) = _Channel;
  factory Channel.fromJson(Map<String, dynamic> json) => _$ChannelFromJson(json);
}
EOF

cat > models/live_model.dart << 'EOF'
import 'package:freezed_annotation/freezed_annotation.dart';
part 'live.freezed.dart';
part 'live.g.dart';
@freezed
class LiveConfig with _$LiveConfig {
  const factory LiveConfig({String? spider, @Default([]) List<Live> lives}) = _LiveConfig;
  factory LiveConfig.fromJson(Map<String, dynamic> json) => _$LiveConfigFromJson(json);
}
EOF

cat > models/network_model.dart << 'EOF'
import 'package:freezed_annotation/freezed_annotation.dart';
part 'network.freezed.dart';
part 'network.g.dart';
@freezed
class Doh with _$Doh {
  const factory Doh({String? name, String? url, @Default([]) List<String> ips}) = _Doh;
  factory Doh.fromJson(Map<String, dynamic> json) => _$DohFromJson(json);
}
@freezed
class Proxy with _$Proxy {
  const factory Proxy({String? name, @Default([]) List<String> hosts, @Default([]) List<String> urls}) = _Proxy;
  factory Proxy.fromJson(Map<String, dynamic> json) => _$ProxyFromJson(json);
}
@freezed
class Rule with _$Rule {
  const factory Rule({String? name, @Default([]) List<String> hosts, @Default([]) List<String> regex}) = _Rule;
  factory Rule.fromJson(Map<String, dynamic> json) => _$RuleFromJson(json);
}
EOF

cat > models/player_model.dart << 'EOF'
import 'package:freezed_annotation/freezed_annotation.dart';
part 'player.freezed.dart';
part 'player.g.dart';
@freezed
class PlayerResult with _$PlayerResult {
  const factory PlayerResult({required String url, @Default(0) int parse, String? playUrl, @Default({}) Map<String, String> header, String? flag}) = _PlayerResult;
  factory PlayerResult.fromJson(Map<String, dynamic> json) => _$PlayerResultFromJson(json);
}
@freezed
class Danmaku with _$Danmaku {
  const factory Danmaku({String? url, String? name}) = _Danmaku;
  factory Danmaku.fromJson(Map<String, dynamic> json) => _$DanmakuFromJson(json);
}
@freezed
class Sub with _$Sub {
  const factory Sub({String? url, String? name, String? lang}) = _Sub;
  factory Sub.fromJson(Map<String, dynamic> json) => _$SubFromJson(json);
}
EOF

# Database
cat > database/tables.dart << 'EOF'
import 'package:drift/drift.dart';
@DataClassName('HistoryEntity')
class History extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get vodId => text().withLength(min: 1, max: 255)();
  TextColumn get vodName => text().withLength(min: 1, max: 500)();
  TextColumn get vodPic => text().nullable()();
  TextColumn get sourceKey => text().withLength(min: 1, max: 100)();
  TextColumn get episode => text().nullable()();
  IntColumn get position => integer().withDefault(const Constant(0))();
  IntColumn get duration => integer().withDefault(const Constant(0))();
  DateTimeColumn get watchTime => dateTime()();
  @override
  List<String> get customConstraints => ['UNIQUE(vod_id, source_key)'];
}
@DataClassName('FavoriteEntity')
class Favorites extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get vodId => text().withLength(min: 1, max: 255)();
  TextColumn get vodName => text().withLength(min: 1, max: 500)();
  TextColumn get vodPic => text().nullable()();
  TextColumn get sourceKey => text().withLength(min: 1, max: 100)();
  DateTimeColumn get createTime => dateTime()();
  @override
  List<String> get customConstraints => ['UNIQUE(vod_id, source_key)'];
}
@DataClassName('ConfigEntity')
class Configs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get type => text().withDefault(const Constant('vod'))();
  TextColumn get content => text()();
  TextColumn get url => text().nullable()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updateTime => dateTime()();
}
@DataClassName('CacheEntity')
class Caches extends Table {
  TextColumn get key => text().withLength(min: 1, max: 500)();
  TextColumn get value => text()();
  TextColumn get rule => text().nullable()();
  DateTimeColumn get createTime => dateTime()();
  DateTimeColumn get expireTime => dateTime().nullable()();
  @override
  Set<Column> get primaryKey => {key};
}
@DataClassName('SearchHistoryEntity')
class SearchHistories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get keyword => text().withLength(min: 1, max: 255)();
  DateTimeColumn get searchTime => dateTime()();
}
@DataClassName('EpgEntity')
class Epgs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get channelId => text().withLength(min: 1, max: 255)();
  TextColumn get channelName => text()();
  TextColumn get title => text()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
}
EOF

cat > database/app_database.dart << 'EOF'
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
EOF

# Repositories
cat > repositories/config_repository_impl.dart << 'EOF'
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
EOF

cat > repositories/history_repository_impl.dart << 'EOF'
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
EOF

cat > repositories/favorite_repository_impl.dart << 'EOF'
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
EOF

cat > repositories/cache_repository_impl.dart << 'EOF'
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
EOF

cat > repositories/vod_repository_impl.dart << 'EOF'
import '../../core/interfaces/interfaces.dart';
class VodRepositoryImpl implements IVodRepository {
  @override
  Future<void> dispose() async {}
}
EOF

cat > repositories/live_repository_impl.dart << 'EOF'
import '../../core/interfaces/interfaces.dart';
class LiveRepositoryImpl implements ILiveRepository {
  @override
  Future<void> dispose() async {}
}
EOF

# Datasources
cat > datasources/local_datasource_impl.dart << 'EOF'
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/interfaces/interfaces.dart';
class LocalDataSourceImpl implements ILocalDataSource {
  late SharedPreferences _prefs;
  @override
  Future<void> initialize() async { _prefs = await SharedPreferences.getInstance(); }
  @override
  Future<T?> get<T>(String key) async {
    final value = _prefs.get(key);
    if (value == null) return null;
    if (value is String && T != String) return jsonDecode(value) as T?;
    return value as T?;
  }
  @override
  Future<void> set<T>(String key, T value) async {
    if (value is String) await _prefs.setString(key, value);
    else if (value is int) await _prefs.setInt(key, value);
    else if (value is bool) await _prefs.setBool(key, value);
    else if (value is double) await _prefs.setDouble(key, value);
    else await _prefs.setString(key, jsonEncode(value));
  }
  @override
  Future<void> delete(String key) async => await _prefs.remove(key);
  @override
  Future<bool> contains(String key) async => _prefs.containsKey(key);
  @override
  Future<void> clear() async => await _prefs.clear();
  @override
  Future<void> dispose() async {}
}
EOF

cat > datasources/network_datasource_impl.dart << 'EOF'
import 'package:dio/dio.dart';
import '../../core/interfaces/interfaces.dart';
class NetworkDataSourceImpl implements INetworkDataSource {
  final Dio _dio;
  NetworkDataSourceImpl({required Dio dio}) : _dio = dio;
  @override
  Future<void> initialize() async {}
  @override
  Future<dynamic> get(String url, {Map<String, dynamic>? params}) async {
    final response = await _dio.get(url, queryParameters: params);
    return response.data;
  }
  @override
  Future<dynamic> post(String url, {dynamic data, Map<String, dynamic>? params}) async {
    final response = await _dio.post(url, data: data, queryParameters: params);
    return response.data;
  }
  @override
  Future<void> dispose() async => _dio.close();
}
EOF

# DI
cat > di/injection.dart << 'EOF'
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../datasources/local_datasource_impl.dart';
import '../datasources/network_datasource_impl.dart';
import '../repositories/config_repository_impl.dart';
import '../repositories/history_repository_impl.dart';
import '../repositories/favorite_repository_impl.dart';
import '../repositories/cache_repository_impl.dart';
import '../repositories/vod_repository_impl.dart';
import '../repositories/live_repository_impl.dart';
import '../database/app_database.dart';
import '../../core/interfaces/interfaces.dart';
void configureDataDependencies() {
  final sl = GetIt.instance;
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<ILocalDataSource>(() => LocalDataSourceImpl());
  sl.registerLazySingleton<INetworkDataSource>(() => NetworkDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<IConfigRepository>(() => ConfigRepositoryImpl(localDataSource: sl(), database: sl()));
  sl.registerLazySingleton<IHistoryRepository>(() => HistoryRepositoryImpl(database: sl()));
  sl.registerLazySingleton<IFavoriteRepository>(() => FavoriteRepositoryImpl(database: sl()));
  sl.registerLazySingleton<ICacheRepository>(() => CacheRepositoryImpl(database: sl()));
  sl.registerLazySingleton<IVodRepository>(() => VodRepositoryImpl());
  sl.registerLazySingleton<ILiveRepository>(() => LiveRepositoryImpl());
}
EOF

cat > data.dart << 'EOF'
export 'models/result_model.dart';
export 'models/vod_model.dart';
export 'models/class_model.dart';
export 'models/filter_model.dart';
export 'database/tables.dart';
export 'database/app_database.dart';
export 'datasources/local_datasource_impl.dart';
export 'datasources/network_datasource_impl.dart';
export 'repositories/config_repository_impl.dart';
export 'repositories/history_repository_impl.dart';
export 'repositories/favorite_repository_impl.dart';
export 'repositories/cache_repository_impl.dart';
EOF

echo "Data layer files created"
