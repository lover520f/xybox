# XYBox 测试指南

## 测试架构

```
lib/test/
├── unit/              # 单元测试
│   ├── logger_util_test.dart
│   ├── date_util_test.dart
│   ├── crypto_util_test.dart
│   ├── json_util_test.dart
│   ├── event_bus_test.dart
│   └── config_manager_test.dart
├── widget/            # Widget 测试
│   ├── home_page_test.dart
│   ├── vod_card_test.dart
│   ├── search_bar_test.dart
│   └── loading_widget_test.dart
├── bloc/              # BLoC 状态管理测试
│   ├── home_bloc_test.dart
│   ├── vod_bloc_test.dart
│   ├── live_bloc_test.dart
│   ├── search_bloc_test.dart
│   └── player_bloc_test.dart
└── integration/       # 集成测试
    ├── app_smoke_test.dart
    └── navigation_test.dart
```

## 运行测试

### 前置要求

1. **Flutter SDK 3.x**
   ```bash
   flutter --version
   ```

2. **安装依赖**
   ```bash
   flutter pub get
   ```

3. **代码生成**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

### 运行所有测试

```bash
# 使用测试脚本（推荐）
./run_tests.sh

# 或手动运行
flutter test --coverage lib/test/
```

### 运行特定测试

```bash
# 运行单元测试
flutter test lib/test/unit/

# 运行 Widget 测试
flutter test lib/test/widget/

# 运行 BLoC 测试
flutter test lib/test/bloc/

# 运行集成测试
flutter test lib/test/integration/

# 运行单个测试文件
flutter test lib/test/unit/logger_util_test.dart

# 运行匹配的测试
flutter test --plain-name "LoggerUtil Tests"
```

### 生成覆盖率报告

```bash
# 运行测试并生成覆盖率
flutter test --coverage

# 生成 HTML 报告（需要安装 lcov）
genhtml coverage/lcov.info -o coverage/html

# 查看报告
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
```

## 测试规范

### 单元测试

测试工具类、服务、模型等独立单元：

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:xybox/core/utils/logger_util.dart';

void main() {
  group('LoggerUtil Tests', () {
    test('should log info message without error', () {
      expect(() => LoggerUtil.i('Test info'), returnsNormally);
    });
  });
}
```

### Widget 测试

测试 UI 组件的渲染和交互：

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:xybox/features/ui/widgets/vod_card.dart';

void main() {
  testWidgets('should display vod name', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: VodCard(vod: testVod))),
    );
    expect(find.text('Test VOD'), findsOneWidget);
  });
}
```

### BLoC 测试

使用 bloc_test 包测试状态管理：

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:xybox/features/home/bloc/home_bloc.dart';

void main() {
  blocTest<HomeBloc, HomeState>(
    'should emit HomeLoading and HomeSuccess',
    build: () => HomeBloc(),
    act: (bloc) => bloc.add(const LoadHomeConfig()),
    expect: () => [isA<HomeLoading>(), isA<HomeSuccess>()],
  );
}
```

### 集成测试

测试多个组件的协同工作：

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('should navigate between tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const XyBoxApp());
    await tester.tap(find.text('影视'));
    await tester.pumpAndSettle();
    expect(find.byType(VodPage), findsOneWidget);
  });
}
```

## 测试覆盖率目标

| 模块 | 目标覆盖率 | 当前状态 |
|------|-----------|---------|
| Core Utils | 90% | ⏳ 待运行 |
| Data Models | 85% | ⏳ 待运行 |
| BLoC | 80% | ⏳ 待运行 |
| Widgets | 75% | ⏳ 待运行 |
| 整体 | 80% | ⏳ 待运行 |

## CI/CD 集成

### GitHub Actions

```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
      - run: flutter pub get
      - run: flutter pub run build_runner build
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v3
```

## 测试最佳实践

1. **测试命名**: 使用描述性的测试名称，说明测试的目的
2. **AAA 模式**: Arrange（准备）→ Act（执行）→ Assert（断言）
3. **独立测试**: 每个测试应该独立运行，不依赖其他测试
4. **Mock 依赖**: 使用 mock 对象隔离外部依赖
5. **覆盖边界情况**: 测试正常流程、错误处理和边界条件
6. **避免 UI 测试过度**: 优先测试业务逻辑，UI 测试关注关键交互

## 常见问题

### Q: 测试失败 "Failed to load"
A: 确保已运行 `flutter pub get` 和 `build_runner`

### Q: 覆盖率报告无法生成
A: 安装 lcov: `sudo apt-get install lcov` 或 `brew install lcov`

### Q: 测试运行缓慢
A: 使用 `--test-randomize-ordering-seed=random` 并行运行测试

## 下一步

1. 安装 Flutter SDK 3.x
2. 运行 `./run_tests.sh` 执行完整测试套件
3. 查看覆盖率报告，补充薄弱区域的测试
4. 在 CI/CD 中集成自动化测试
5. 目标：整体测试覆盖率达到 80%+
