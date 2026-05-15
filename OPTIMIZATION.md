# XYBox 性能优化指南

## 已实施优化

### 1. 懒加载与分页

```dart
// ListView 懒加载
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(item: items[index]),
)

// 分页加载
Future<void> loadMore() async {
  if (_isLoading || _hasNoMore) return;
  final newItems = await repository.getPage(_currentPage + 1);
  setState(() {
    _items.addAll(newItems);
    _currentPage++;
    _hasNoMore = newItems.isEmpty;
  });
}
```

### 2. 图片缓存

```dart
// 使用 CachedNetworkImage
CachedNetworkImage(
  imageUrl: vod.pic,
  placeholder: (context, url) => const CircularProgressIndicator(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
  memCacheWidth: 200, // 限制内存缓存尺寸
)
```

### 3. 状态管理优化

```dart
// BLoC 使用 Equatable 避免不必要的 rebuild
class VodState extends Equatable {
  @override
  List<Object?> get props => [status, items, error];
}
```

### 4. 数据库索引

```dart
// Drift 数据库索引
@index('idx_watch_time')
IntColumn get watchTime => integer()();

@index('idx_vod_source')
TextColumn get sourceKey => text()();
```

### 5. 网络请求优化

```dart
// Dio 拦截器缓存
dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) async {
    final cached = await cache.get(options.uri.toString());
    if (cached != null) {
      return handler.resolve(Response(data: cached, statusCode: 200));
    }
    handler.next(options);
  },
));
```

## 待优化项目

### 1. 代码分割 (Code Splitting)

```dart
// 延迟加载大型模块
final playerModule = await DeferredLibrary('player').load();
```

### 2. 预加载策略

```dart
// 预加载下一个视频
void preloadNext(String url) {
  _player.prepare(DataSource(url));
}
```

### 3. 内存优化

```dart
// 及时释放资源
@override
void dispose() {
  _controller.dispose();
  _player.dispose();
  super.dispose();
}
```

### 4. 渲染优化

```dart
// 使用 const widget
const SizedBox(height: 16)

// 使用 RepaintBoundary
RepaintBoundary(
  child: CustomPaint(painter: DanmakuPainter()),
)
```

### 5. 构建优化

```dart
// 使用 key 避免重建
ListView.builder(
  key: Key('vod_list_${typeId}'),
  ...
)
```

## 性能监控

### 1. 使用 DevTools

```bash
flutter pub global activate devtools
flutter pub global run devtools
```

### 2. 性能指标

| 指标 | 目标 | 测量方法 |
|------|------|---------|
| 首帧时间 | < 1s | DevTools Performance |
| 页面切换 | < 300ms | Timeline |
| 内存占用 | < 100MB | Memory |
| 掉帧率 | < 1% | Performance Overlay |

### 3. 监控代码

```dart
import 'dart:developer';

Timeline.startSync('LoadVodData');
final data = await repository.getVod();
Timeline.finishSync();
```

## 发布前检查清单

- [ ] 运行 `flutter analyze` 无警告
- [ ] 运行 `flutter test` 全部通过
- [ ] 覆盖率 > 80%
- [ ] 性能测试达标
- [ ] 移除所有 print/debug 代码
- [ ] 优化图片资源
- [ ] 配置 ProGuard 规则
- [ ] 测试不同分辨率
- [ ] 测试不同 Android 版本
