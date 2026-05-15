import 'package:get_it/get_it.dart';
import '../../data/di/injection.dart' as data;
import '../../network/di/injection.dart' as network;
import '../../spider/di/injection.dart' as spider;
import '../interfaces/interfaces.dart';
import '../utils/logger_util.dart';
final GetIt sl = GetIt.instance;
Future<void> configureDependencies() async {
  LoggerUtil.i('开始配置依赖注入...');
  data.configureDataDependencies();
  network.configureNetworkDependencies();
  spider.configureSpiderDependencies();
  await sl<ILocalDataSource>().initialize();
  await sl<INetworkDataSource>().initialize();
  LoggerUtil.i('依赖注入配置完成');
}
