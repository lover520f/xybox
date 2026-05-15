import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  
  // 数据库
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());
  
  // 网络
  sl.registerLazySingleton<Dio>(() => Dio());
  
  // SharedPreferences
  sl.registerLazySingletonAsync<SharedPreferences>(() async => await SharedPreferences.getInstance());
  
  // 仓储
  sl.registerLazySingleton<IConfigRepository>(() => ConfigRepositoryImpl());
  sl.registerLazySingleton<IHistoryRepository>(() => HistoryRepositoryImpl());
  sl.registerLazySingleton<IFavoriteRepository>(() => FavoriteRepositoryImpl());
  sl.registerLazySingleton<ICacheRepository>(() => CacheRepositoryImpl());
  sl.registerLazySingleton<IVodRepository>(() => VodRepositoryImpl());
  sl.registerLazySingleton<ILiveRepository>(() => LiveRepositoryImpl());
}
