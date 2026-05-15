import 'package:get_it/get_it.dart';
import '../../data/di/injection.dart' as data;
import '../utils/logger_util.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  LoggerUtil.i('开始配置依赖注入...');
  data.configureDataDependencies();
  LoggerUtil.i('依赖注入配置完成');
}
