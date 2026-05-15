# XYBox Flutter 项目复刻任务清单

## 项目概述

**项目名称**: xybox  
**目标**: 1:1 复刻 FongMi/TV 项目的所有功能  
**技术栈**: Flutter + Dart  
**目标平台**: Android TV (Leanback) + Android Mobile  
**最低 SDK**: Android 7.0 (API 24)

---

## 项目架构

### 核心模块划分

```
xybox/
├── lib/
│   ├── main.dart                    # 应用入口
│   ├── app.dart                     # 应用配置
│   │
│   ├── core/                        # 核心基础层
│   │   ├── constants/               # 常量定义
│   │   ├── enums/                   # 枚举类型
│   │   ├── extensions/              # 扩展方法
│   │   ├── interfaces/              # 接口定义
│   │   └── utils/                   # 工具类
│   │
│   ├── data/                        # 数据层
│   │   ├── models/                  # 数据模型
│   │   ├── repositories/            # 仓储实现
│   │   ├── datasources/             # 数据源
│   │   └── database/                # 本地数据库
│   │
│   ├── domain/                      # 领域层
│   │   ├── entities/                # 业务实体
│   │   ├── repositories/            # 仓储接口
│   │   └── usecases/                # 业务用例
│   │
│   ├── presentation/                # 表现层
│   │   ├── bloc/                    # BLoC 状态管理
│   │   ├── cubit/                   # Cubit 状态管理
│   │   ├── pages/                   # 页面
│   │   └── widgets/                 # 组件
│   │
│   ├── features/                    # 功能模块
│   │   ├── home/                    # 首页
│   │   ├── vod/                     # 点播
│   │   ├── live/                    # 直播
│   │   ├── player/                  # 播放器
│   │   ├── search/                  # 搜索
│   │   ├── favorite/                # 收藏
│   │   ├── history/                 # 历史
│   │   ├── settings/                # 设置
│   │   └── dlna/                    # DLNA
│   │
│   ├── spider/                      # 爬虫引擎
│   │   ├── base/                    # 爬虫基类
│   │   ├── loader/                  # 加载器
│   │   ├── js/                      # JavaScript 引擎
│   │   ├── py/                      # Python 引擎
│   │   └── jar/                     # Java JAR 引擎
│   │
│   ├── network/                     # 网络层
│   │   ├── dio/                     # Dio 配置
│   │   ├── doh/                     # DNS over HTTPS
│   │   ├── proxy/                   # 代理配置
│   │   ├── sniffer/                 # URL 嗅探
│   │   └── local_server/            # 本地 HTTP 服务器
│   │
│   └── router/                      # 路由配置
│       ├── routes.dart
│       └── router.dart
│
├── flavors/                         # 多 flavor 配置
│   ├── leanback/                    # TV 版
│   └── mobile/                      # 手机版
│
├── android/                         # Android 原生层
│   ├── app/
│   └── gradle/
│
├── assets/                          # 资源文件
│   ├── images/
│   ├── fonts/
│   └── configs/
│
└── test/                            # 测试
    ├── unit/
    ├── widget/
    └── integration/
```

---

## 任务清单

### 阶段 1: 项目初始化与基础架构 (Week 1-2)

#### 1.1 项目搭建
- [ ] 创建 Flutter 项目
- [ ] 配置 flavors (leanback / mobile)
- [ ] 配置 pubspec.yaml 依赖
- [ ] 配置 Android 原生项目 (minSdk 24, abi 支持)
- [ ] 配置代码生成 (build_runner, freezed, json_serializable)
- [ ] 配置 lint 规则
- [ ] 配置 CI/CD (GitHub Actions)

#### 1.2 核心基础层
- [ ] 常量定义 (API 端点、配置项、事件类型等)
- [ ] 枚举类型 (站点类型、解析器类型、播放器状态等)
- [ ] 扩展方法 (String、List、DateTime 等常用扩展)
- [ ] 接口定义 (Repository、DataSource 等抽象接口)
- [ ] 工具类 (日志、加密、编解码、文件处理等)

#### 1.3 路由系统
- [ ] 配置 go_router 或 auto_route
- [ ] 定义路由表
- [ ] 实现路由守卫
- [ ] 实现深链接支持

#### 1.4 状态管理架构
- [ ] 配置 flutter_bloc
- [ ] 创建基础 BLoC/Cubit 模板
- [ ] 实现依赖注入 (get_it / riverpod)

---

### 阶段 2: 数据层实现 (Week 3-4)

#### 2.1 数据模型 (Models)
- [ ] VodConfig (点播配置)
- [ ] LiveConfig (直播配置)
- [ ] Site (站点模型)
- [ ] Parse (解析规则)
- [ ] Live (直播源)
- [ ] Group (频道分组)
- [ ] Channel (频道)
- [ ] Vod (影片卡片)
- [ ] Class (分类)
- [ ] Filter (筛选器)
- [ ] Result (通用返回)
- [ ] PlayerResult (播放结果)
- [ ] Danmaku (弹幕)
- [ ] Sub (字幕)
- [ ] Drm (DRM 配置)
- [ ] History (观看历史)
- [ ] Favorite (收藏)
- [ ] Config (应用配置)
- [ ] Device (设备信息)

#### 2.2 本地数据库 (Room 等效)
- [ ] 配置 drift 或 isar
- [ ] 创建数据库表结构
  - [ ] 观看历史表 (保留 60 天)
  - [ ] 收藏表
  - [ ] 配置表
  - [ ] 缓存表
- [ ] 实现数据库迁移
- [ ] 实现数据库 Schema 导出

#### 2.3 数据源 (DataSources)
- [ ] 本地数据源 (SharedPreferences 等效)
- [ ] 网络数据源 (HTTP API)
- [ ] 文件数据源 (本地文件读写)
- [ ] 数据库数据源

#### 2.4 仓储层 (Repositories)
- [ ] ConfigRepository (配置管理)
- [ ] VodRepository (点播数据)
- [ ] LiveRepository (直播数据)
- [ ] SearchRepository (搜索)
- [ ] PlayerRepository (播放器)
- [ ] HistoryRepository (历史记录)
- [ ] FavoriteRepository (收藏)
- [ ] CacheRepository (缓存)
- [ ] DlnaRepository (DLNA)

---

### 阶段 3: 网络层实现 (Week 5-6)

#### 3.1 HTTP 客户端
- [ ] 配置 Dio 客户端
- [ ] 实现拦截器 (日志、认证、错误处理)
- [ ] 实现请求重试机制
- [ ] 实现超时控制

#### 3.2 DNS over HTTPS (DoH)
- [ ] 实现 DoH 客户端
- [ ] 支持 Bootstrap IP
- [ ] 支持多个 DoH 服务器
- [ ] 集成到 Dio

#### 3.3 代理配置
- [ ] 实现 HTTP 代理支持
- [ ] 实现 HTTPS 代理支持
- [ ] 实现 SOCKS4 代理支持
- [ ] 实现 SOCKS5 代理支持
- [ ] 实现基于正则的代理路由
- [ ] 实现代理自动切换

#### 3.4 Hosts 覆盖
- [ ] 实现 DNS 解析覆盖
- [ ] 支持通配符匹配
- [ ] 集成到网络层

#### 3.5 URL 嗅探
- [ ] 实现 WebView 嗅探
- [ ] 实现正则匹配媒体 URL
- [ ] 实现 UA 伪装
- [ ] 实现广告拦截 (ads 黑名单)

#### 3.6 CORS 注入
- [ ] 实现响应头注入
- [ ] 支持基于 host 的规则
- [ ] 实现自定义 Header 添加

#### 3.7 本地 HTTP 服务器
- [ ] 实现本地 HTTP 服务器 (端口 9978-9998)
- [ ] 实现 /action 端点
  - [ ] do=control (播放控制)
  - [ ] do=danmaku (发送弹幕)
  - [ ] do=refresh (刷新指令)
  - [ ] do=push (推送播放)
  - [ ] do=file (开启文件)
  - [ ] do=search (触发搜索)
  - [ ] do=setting (加载配置)
  - [ ] do=cast (投放媒体)
  - [ ] do=sync (同步数据)
- [ ] 实现 /cache 端点
  - [ ] do=get (读取缓存)
  - [ ] do=set (写入缓存)
  - [ ] do=del (删除缓存)
- [ ] 实现 /media 端点 (播放状态)
- [ ] 实现 /file 端点 (本地文件系统)
- [ ] 实现 /upload 端点 (上传文件)
- [ ] 实现 /newFolder 端点 (新增文件夹)
- [ ] 实现 /delFolder 端点 (删除文件夹)
- [ ] 实现 /delFile 端点 (删除文件)
- [ ] 实现 /parse 端点 (解析页面)
- [ ] 实现 /proxy 端点 (爬虫代理)
- [ ] 实现 /device 端点 (设备信息)

---

### 阶段 4: 爬虫引擎 (Week 7-9)

#### 4.1 Spider 抽象类
- [ ] 定义 Spider 基类
- [ ] 实现 init 方法
- [ ] 实现 homeContent 方法
- [ ] 实现 homeVideoContent 方法
- [ ] 实现 categoryContent 方法
- [ ] 实现 detailContent 方法
- [ ] 实现 searchContent 方法
- [ ] 实现 playerContent 方法
- [ ] 实现 liveContent 方法
- [ ] 实现 proxy 方法
- [ ] 实现 action 方法
- [ ] 实现 manualVideoCheck 方法
- [ ] 实现 isVideoFormat 方法
- [ ] 实现 destroy 方法

#### 4.2 JavaScript 引擎 (QuickJS 等效)
- [ ] 集成 flutter_js 或类似库
- [ ] 实现 JS Spider 加载器
- [ ] 实现 JS 与 Dart 的桥接
- [ ] 实现 Spider API 暴露给 JS
- [ ] 支持 .js 文件加载
- [ ] 支持内联 JS 代码

#### 4.3 Python 引擎 (Chaquopy 等效)
- [ ] 调研 Flutter Python 方案 (chaquopy 无 Flutter 等效，需用其他方式)
- [ ] 实现 Python Spider 加载器
- [ ] 实现 Python 与 Dart 的桥接
- [ ] 支持 .py 文件加载

#### 4.4 Java JAR 引擎
- [ ] 调研 Dart/Java 互操作方案
- [ ] 实现 JAR Spider 加载器
- [ ] 支持 DexClassLoader 加载
- [ ] 支持 .jar 文件加载

#### 4.5 Spider 管理
- [ ] 实现 Spider 加载器 (BaseLoader)
- [ ] 实现 Spider 缓存
- [ ] 实现 Spider 生命周期管理
- [ ] 实现 Spider 代理 URL 生成

---

### 阶段 5: 播放器核心 (Week 10-13)

#### 5.1 播放器基础
- [ ] 集成 media_kit 或 fijkplayer (ExoPlayer 封装)
- [ ] 实现播放器控制器
- [ ] 实现播放/暂停/停止
- [ ] 实现 seek/to
- [ ] 实现上一集/下一集
- [ ] 实现倍速播放
- [ ] 实现音量控制
- [ ] 实现亮度控制

#### 5.2 视频渲染
- [ ] 实现 SurfaceView 渲染
- [ ] 实现 TextureView 渲染
- [ ] 实现视频比例切换 (16:9, 4:3, 原始等)
- [ ] 实现画面缩放模式

#### 5.3 DRM 支持
- [ ] 实现 Widevine DRM
- [ ] 实现 PlayReady DRM
- [ ] 实现 ClearKey DRM
- [ ] 支持 License Server 配置
- [ ] 支持自定义 Header
- [ ] 支持 #KODIPROP 宣告解析

#### 5.4 字幕支持
- [ ] 实现 SRT 字幕加载
- [ ] 实现 SSA/ASS 字幕加载
- [ ] 实现外挂字幕
- [ ] 实现字幕样式定制
- [ ] 实现字幕切换
- [ ] 实现远程字幕注入

#### 5.5 弹幕支持
- [ ] 集成弹幕库 (参考 DanmakuFlameMaster)
- [ ] 实现弹幕渲染引擎
- [ ] 实现弹幕与播放时间轴同步
- [ ] 实现弹幕加载 (XML/JSON 格式)
- [ ] 实现弹幕发送
- [ ] 实现弹幕设置 (开关、透明度、速度等)
- [ ] 实现远程弹幕推送

#### 5.6 高级功能
- [ ] 实现画中画 (PiP)
- [ ] 实现后台音频播放
- [ ] 实现片头自动跳过
- [ ] 实现片尾自动跳过
- [ ] 实现播放进度记忆
- [ ] 实现硬解/软解自动切换

#### 5.7 播放器 UI
- [ ] 实现播放控制栏
- [ ] 实现进度条
- [ ] 实现选集面板
- [ ] 实现字幕选择面板
- [ ] 实现音轨选择面板
- [ ] 实现清晰度选择
- [ ] 实现弹幕开关和设置

---

### 阶段 6: 点播功能 (Week 14-17)

#### 6.1 首页
- [ ] 实现站点列表页
- [ ] 实现分类列表 (homeContent)
- [ ] 实现筛选器 (Filter)
- [ ] 实现首页推荐 (homeVideoContent)
- [ ] 实现卡片展示 (矩形/圆形/列表)
- [ ] 实现卡片宽高比配置
- [ ] 实现横屏/竖屏模式

#### 6.2 分类浏览
- [ ] 实现分类内容列表 (categoryContent)
- [ ] 实现分页加载
- [ ] 实现筛选条件应用
- [ ] 实现排序功能
- [ ] 实现加载更多

#### 6.3 影片详情
- [ ] 实现详情页 (detailContent)
- [ ] 实现影片信息展示
- [ ] 实现播放列表 (vod_play_from / vod_play_url)
- [ ] 实现多线路切换
- [ ] 实现选集功能
- [ ] 实现收藏按钮
- [ ] 实现播放历史显示

#### 6.4 搜索功能
- [ ] 实现搜索页面
- [ ] 实现多站点并行搜索
- [ ] 实现快速搜索 (quickSearch)
- [ ] 实现搜索历史
- [ ] 实现繁简转换
- [ ] 实现搜索结果分页

#### 6.5 播放失败处理
- [ ] 实现播放失败自动换源
- [ ] 实现解析器降级
- [ ] 实现线路切换
- [ ] 实现站点切换

#### 6.6 观看记录
- [ ] 实现观看记录保存
- [ ] 实现观看记录列表
- [ ] 实现续播功能
- [ ] 实现 60 天自动清理
- [ ] 实现无痕模式

#### 6.7 收藏功能
- [ ] 实现收藏列表
- [ ] 实现添加/取消收藏
- [ ] 实现收藏分类

---

### 阶段 7: 直播功能 (Week 18-20)

#### 7.1 直播源解析
- [ ] 实现 TXT 格式解析 (#genre# 分组)
- [ ] 实现 M3U 格式解析 (#EXTM3U)
- [ ] 实现 JSON 格式解析
- [ ] 实现多线路支持 (# 分隔)
- [ ] 实现行内 Header 解析 (|key=value)

#### 7.2 EPG 功能
- [ ] 实现 XMLTV 格式解析
- [ ] 实现 .gz 压缩支持
- [ ] 实现 6 小时自动刷新
- [ ] 实现 EPG 节目单展示
- [ ] 实现时区支持
- [ ] 实现多个 EPG 源

#### 7.3 追看/时移
- [ ] 实现 append 类型
- [ ] 实现 default 类型
- [ ] 实现 regex 匹配
- [ ] 实现 source 模板变量
- [ ] 实现 replace 替换

#### 7.4 频道管理
- [ ] 实现频道收藏
- [ ] 实现分组隐藏 (密码保护)
- [ ] 实现频道号选台
- [ ] 实现频道 Logo 显示
- [ ] 实现上下频道切换

#### 7.5 特殊引擎
- [ ] 实现 TVBus 引擎支持
- [ ] 实现 ForceTech 引擎支持
- [ ] 实现其他特殊协议

---

### 阶段 8: 解析器功能 (Week 21-22)

#### 8.1 解析器类型
- [ ] 实现 type=0 (嗅探)
- [ ] 实现 type=1 (JSON API)
- [ ] 实现 type=2 (JSON 扩展)
- [ ] 实现 type=3 (JSON 聚合)
- [ ] 实现 type=4 (超级解析)

#### 8.2 解析器管理
- [ ] 实现解析器配置
- [ ] 实现解析器切换
- [ ] 实现解析器 flag 匹配
- [ ] 实现解析器 Header 配置

#### 8.3 WebView 解析
- [ ] 实现 WebView 嗅探
- [ ] 实现点击拦截
- [ ] 实现脚本执行
- [ ] 实现广告过滤

---

### 阶段 9: DLNA 功能 (Week 23-24)

#### 9.1 DMC (投放端 - 手机版)
- [ ] 实现 DLNA 设备扫描
- [ ] 实现 UPnP 协议 (使用 JUPnP 等效库)
- [ ] 实现设备列表展示
- [ ] 实现媒体投放
- [ ] 实现播放控制 (play/pause/stop/seek)
- [ ] 实现自定义 Header 传递

#### 9.2 DMR (被投放端 - TV 版)
- [ ] 实现 DLNA Renderer
- [ ] 实现媒体接收
- [ ] 实现播放控制接口
- [ ] 实现投放状态显示

---

### 阶段 10: Android Auto (Week 25-26)

#### 10.1 基础支持
- [ ] 实现 MediaLibraryService
- [ ] 实现 PlaybackService
- [ ] 实现车机连接
- [ ] 实现懒加载 (App 退出后保持连接)

#### 10.2 点播功能
- [ ] 实现历史记录浏览
- [ ] 实现续播功能
- [ ] 实现进度恢复

#### 10.3 直播功能
- [ ] 实现频道分组浏览
- [ ] 实现选台功能

#### 10.4 播放控制
- [ ] 实现 play/pause
- [ ] 实现 prev/next
- [ ] 实现 stop

---

### 阶段 11: UI 实现 - TV 版 (Week 27-29)

#### 11.1 Leanback 基础
- [ ] 集成 Android TV Leanback 支持
- [ ] 实现遥控器导航
- [ ] 实现焦点管理
- [ ] 实现 D-pad 控制

#### 11.2 首页 UI
- [ ] 实现站点卡片
- [ ] 实现分类行
- [ ] 实现推荐影片网格
- [ ] 实现横向滚动

#### 11.3 播放器 UI (TV)
- [ ] 实现遥控器播放控制
- [ ] 实现进度条 (方向键控制)
- [ ] 实现选集面板 (弹出式)
- [ ] 实现快速设置面板

#### 11.4 直播 UI (TV)
- [ ] 实现频道列表 (纵向)
- [ ] 实现 EPG 节目单
- [ ] 实现频道切换动画
- [ ] 实现频道号输入

#### 11.5 设置 UI (TV)
- [ ] 实现配置加载
- [ ] 实现网络设置
- [ ] 实现播放器设置
- [ ] 实现关于页面

---

### 阶段 12: UI 实现 - 手机版 (Week 30-32)

#### 12.1 Material Design
- [ ] 实现 Material 3 主题
- [ ] 实现底部导航栏
- [ ] 实现抽屉式导航
- [ ] 实现响应式布局

#### 12.2 首页 UI (Mobile)
- [ ] 实现站点列表
- [ ] 实现分类 Tab
- [ ] 实现筛选抽屉
- [ ] 实现搜索栏

#### 12.3 播放器 UI (Mobile)
- [ ] 实现手势控制
  - [ ] 亮度调节 (左侧上下滑动)
  - [ ] 音量调节 (右侧上下滑动)
  - [ ] 进度调节 (水平滑动)
  - [ ] 双击快进/快退
- [ ] 实现上下滑切集
- [ ] 实现屏幕旋转
- [ ] 实现旋转锁定
- [ ] 实现小窗播放

#### 12.4 直播 UI (Mobile)
- [ ] 实现频道列表 (可搜索)
- [ ] 实现分组折叠
- [ ] 实现 EPG 节目单
- [ ] 实现横屏模式

#### 12.5 DLNA UI (Mobile)
- [ ] 实现设备扫描页面
- [ ] 实现设备选择对话框
- [ ] 实现投放控制栏

---

### 阶段 13: 配置系统 (Week 33-34)

#### 13.1 配置加载
- [ ] 实现 URL 加载配置
- [ ] 实现本地文件加载
- [ ] 实现字符串粘贴
- [ ] 实现配置验证

#### 13.2 配置解析
- [ ] 实现 VodConfig 解析
- [ ] 实现 LiveConfig 解析
- [ ] 实现 sites 解析
- [ ] 实现 parses 解析
- [ ] 实现 lives 解析
- [ ] 实现网络配置解析 (doh/proxy/hosts/ads)

#### 13.3 配置管理
- [ ] 实现多配置切换
- [ ] 实现配置收藏
- [ ] 实现配置备份
- [ ] 实现配置导入导出

---

### 阶段 14: 测试 (Week 35-37)

#### 14.1 单元测试
- [ ] 编写数据模型测试
- [ ] 编写工具类测试
- [ ] 编写网络层测试
- [ ] 编写爬虫引擎测试
- [ ] 编写业务逻辑测试

#### 14.2 Widget 测试
- [ ] 编写基础组件测试
- [ ] 编写页面组件测试
- [ ] 编写播放器组件测试

#### 14.3 集成测试
- [ ] 编写端到端测试
- [ ] 编写播放流程测试
- [ ] 编写搜索流程测试
- [ ] 编写配置加载测试

#### 14.4 性能测试
- [ ] 进行启动速度测试
- [ ] 进行播放性能测试
- [ ] 进行内存泄漏测试
- [ ] 进行网络请求性能测试

---

### 阶段 15: 优化与发布 (Week 38-40)

#### 15.1 性能优化
- [ ] 图片加载优化 (缓存/预加载)
- [ ] 列表滚动优化 (懒加载)
- [ ] 网络请求优化 (缓存/合并)
- [ ] 数据库查询优化 (索引)
- [ ] 内存优化 (避免泄漏)

#### 15.2 兼容性测试
- [ ] Android 7.0-14 兼容性测试
- [ ] 不同分辨率适配
- [ ] TV 设备兼容性测试
- [ ] 不同 CPU 架构测试 (arm64-v8a, armeabi-v7a)

#### 15.3 打包发布
- [ ] 配置签名
- [ ] 配置 ProGuard/R8
- [ ] 生成 release APK
- [ ] 生成 Android App Bundle
- [ ] 准备发布说明

---

## 技术依赖

### 核心依赖
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # 状态管理
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  
  # 路由
  go_router: ^12.1.1
  
  # 网络
  dio: ^5.4.0
  http: ^1.1.0
  
  # 本地数据库
  drift: ^2.15.0
  sqlite3_flutter_libs: ^0.5.18
  
  # 本地存储
  shared_preferences: ^2.2.2
  
  # 播放器
  media_kit: ^1.1.10+1
  media_kit_video: ^1.2.4
  media_kit_libs_android: ^1.0.4
  
  # JavaScript 引擎
  flutter_js: ^0.8.0
  
  # JSON 序列化
  json_annotation: ^4.8.1
  freezed_annotation: ^2.4.1
  
  # 依赖注入
  get_it: ^7.6.4
  injectable: ^2.3.2
  
  # 日志
  logger: ^2.0.2+1
  
  # 权限
  permission_handler: ^11.1.0
  
  # 文件
  path_provider: ^2.1.1
  file_picker: ^6.1.1
  
  # 图片
  cached_network_image: ^3.3.0
  
  # DLNA
  # 需寻找 Flutter 等效库或开发原生插件
  
  # 本地服务器
  dart_http_server: ^1.0.0
  
  # 弹幕 (需自定义或使用现有库)
  
  # 其他工具
  intl: ^0.18.1
  uuid: ^4.2.2
  collection: ^1.18.0
```

### 开发依赖
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # 代码生成
  build_runner: ^2.4.7
  json_serializable: ^6.7.1
  freezed: ^2.4.6
  
  # 依赖注入
  injectable_generator: ^2.4.1
  
  # 测试
  mockito: ^5.4.3
  integration_test:
    sdk: flutter
  
  # 代码检查
  flutter_lints: ^3.0.1
```

---

## 里程碑

| 阶段 | 内容 | 预计完成时间 |
|------|------|-------------|
| 阶段 1 | 项目初始化与基础架构 | Week 2 |
| 阶段 2 | 数据层实现 | Week 4 |
| 阶段 3 | 网络层实现 | Week 6 |
| 阶段 4 | 爬虫引擎 | Week 9 |
| 阶段 5 | 播放器核心 | Week 13 |
| 阶段 6 | 点播功能 | Week 17 |
| 阶段 7 | 直播功能 | Week 20 |
| 阶段 8 | 解析器功能 | Week 22 |
| 阶段 9 | DLNA 功能 | Week 24 |
| 阶段 10 | Android Auto | Week 26 |
| 阶段 11 | UI 实现 - TV 版 | Week 29 |
| 阶段 12 | UI 实现 - 手机版 | Week 32 |
| 阶段 13 | 配置系统 | Week 34 |
| 阶段 14 | 测试 | Week 37 |
| 阶段 15 | 优化与发布 | Week 40 |

**总预计时间**: 40 周 (约 10 个月)

---

## 注意事项

### 技术难点
1. **爬虫引擎**: Flutter 没有直接的 Chaquopy 等效方案，需要寻找替代方案
2. **Java JAR 支持**: Dart/Java 互操作复杂，可能需要原生插件
3. **DLNA**: 需要寻找或开发 Flutter DLNA 库
4. **弹幕**: 需要自定义弹幕渲染引擎
5. **DRM**: Widevine/PlayReady 需要原生支持
6. **Android Auto**: 需要原生服务实现
7. **本地 HTTP 服务器**: 需要稳定的 Dart HTTP 服务器实现

### 人员配置建议
- 主开发：2-3 名 Flutter 开发者
- 原生支持：1 名 Android 原生开发者
- 测试：1 名 QA 工程师

### 风险点
1. Python 引擎在 Flutter 中无成熟方案
2. DLNA 功能可能需要从零开发
3. Android Auto 兼容性问题
4. 播放器性能可能不如原生 ExoPlayer
5. 弹幕性能优化难度大

### 建议
1. 优先实现核心功能 (点播 + 直播 + 播放器)
2. 爬虫引擎先支持 JavaScript，Python 和 Java 后续补充
3. DLNA 和 Android Auto 可作为后期目标
4. 充分测试播放器性能和稳定性
5. 保持与原生版本的兼容性

---

## 附录

### 参考文档
- [FongMi/TV 源码](https://github.com/FongMi/TV)
- [CONFIG.md](https://github.com/FongMi/TV/blob/fongmi/docs/CONFIG.md) - 配置说明
- [SPIDER.md](https://github.com/FongMi/TV/blob/fongmi/docs/SPIDER.md) - 爬虫 API
- [LOCAL.md](https://github.com/FongMi/TV/blob/fongmi/docs/LOCAL.md) - 本地 HTTP API
- [LIVE.md](https://github.com/FongMi/TV/blob/fongmi/docs/LIVE.md) - 直播格式

### 相关资源
- Flutter 官方文档：https://docs.flutter.dev
- Media Kit: https://github.com/media-kit/media-kit
- Drio: https://pub.dev/packages/dio
- Go Router: https://pub.dev/packages/go_router
- Flutter BLoC: https://bloclibrary.dev

---

**文档版本**: 1.0  
**创建日期**: 2026-05-15  
**最后更新**: 2026-05-15
