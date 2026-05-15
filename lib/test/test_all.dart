// 测试入口文件
// 运行：flutter test test/test_all.dart

import 'unit/logger_util_test.dart' as logger_test;
import 'unit/date_util_test.dart' as date_test;
import 'unit/crypto_util_test.dart' as crypto_test;
import 'unit/json_util_test.dart' as json_test;
import 'unit/event_bus_test.dart' as event_bus_test;
import 'unit/config_manager_test.dart' as config_test;

void main() {
  logger_test.main();
  date_test.main();
  crypto_test.main();
  json_test.main();
  event_bus_test.main();
  config_test.main();
}
