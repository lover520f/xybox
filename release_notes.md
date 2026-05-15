# XYBox v1.0.0 Release Notes

## 🎉 首次正式发布

### ✨ 主要功能

#### TV 版功能
- 🏠 首页 - 推荐内容和快速入口
- 🎬 影视 - 分类浏览和搜索
- 📺 直播 - 电视频道观看
- ▶️ 播放器 - 视频播放控制
- 🔍 搜索 - 全局搜索功能
- 📜 历史记录 - 观看历史管理
- ⭐ 收藏夹 - 内容收藏管理
- ⚙️ 设置 - 配置管理

#### Mobile 版功能
- 📱 触摸优化的界面布局
- 🎮 竖屏播放支持

#### 核心功能
- 🔌 多数据源支持（APK/JAR/XML/JS）
- 🌐 本地 HTTP 服务器（端口 9978-9998）
- 📡 DLNA 设备发现与推送
- 🎭 弹幕显示
- ⏯️ 观看续播
- 💾 缓存管理

### 📦 技术规格

- **平台**: Android 7.0+ (API 24+)
- **框架**: Flutter 3.x
- **架构**: Clean Architecture
- **文件大小**: 88 MB
- **代码量**: ~10,000 行

### 🏗️ 技术栈

- 状态管理：flutter_bloc
- 路由：go_router
- 网络：dio
- 播放器：media_kit (ExoPlayer)
- 数据库：drift (SQLite)
- 代码生成：freezed + json_serializable

### 📁 项目结构

```
lib/
├── core/          # 核心层 (接口/工具/服务)
├── data/          # 数据层 (模型/数据库/仓储)
├── network/       # 网络层 (Dio/代理/本地服务器)
├── spider/        # 爬虫引擎 (JS 引擎)
├── features/      # UI 层 (页面/BLoC/组件)
├── router/        # 路由配置
└── test/          # 测试文件
```

### 📝 安装说明

1. 下载 APK 文件
2. 在 Android 设备上启用"未知来源"安装
3. 安装 APK
4. 启动应用

### ⚠️ 注意事项

- 首次启动需要配置数据源
- 建议连接 WiFi 使用
- 部分内容可能需要网络权限

### 📋 已知限制

- Python 爬虫引擎暂不支持（仅支持 JS 引擎）
- Android Auto 功能尚未实现
- 部分高级功能需要真实配置源

### 🛠️ 开发相关

```bash
# 克隆项目
git clone https://github.com/lover520f/xybox.git

# 安装依赖
flutter pub get

# 代码生成
flutter pub run build_runner build

# 运行测试
flutter test

# 构建 APK
flutter build apk --release
```

### 📚 文档

- [开发文档](TESTING.md)
- [优化指南](OPTIMIZATION.md)
- [完成总结](FINAL_SUMMARY.md)

### 🙏 致谢

本项目 1:1 复刻自 [FongMi/TV](https://github.com/FongMi/TV)

### 📞 支持

- 问题反馈：GitHub Issues
- 仓库地址：https://github.com/lover520f/xybox

---

**发布日期**: 2024-05-15  
**版本号**: 1.0.0  
**构建号**: 1
