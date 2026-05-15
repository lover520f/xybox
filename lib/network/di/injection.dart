import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
final GetIt sl = GetIt.instance;
void configureNetworkDependencies() {
  sl.registerLazySingleton<Dio>(() => Dio());
}
