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
