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
