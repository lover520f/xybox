# 核心功能实装计划

## 优先级

### P0 - 立即实现
1. ✅ ~~配置管理~~ (已完成)
2. 🔲 接入真实爬虫 API
3. 🔲 实现真实播放器 (media_kit)
4. 🔲 实现直播流播放

### P1 - 后续完善
5. 🔲 弹幕功能
6. 🔲 DLNA 投屏

## 技术方案

### 1. 爬虫 API 接入

**架构**:
```
ConfigManager → SpiderEngine → ISpider → JSSpider
    ↓              ↓
配置解析       爬虫调用
```

**接口**:
- `homeContent()` - 首页分类
- `categoryContent(typeId, page)` - 分类内容
- `detailContent(id)` - 详情
- `searchContent(keyword)` - 搜索
- `playerContent(flag, url)` - 播放地址

### 2. 播放器实现

**技术栈**: media_kit + media_kit_video

**功能**:
- 网络视频播放 (http/https/hls/dash)
- 播放控制 (暂停/快进/音量)
- 进度显示
- 倍速播放
- 选集切换

### 3. 直播流播放

**格式支持**:
- m3u8 (HLS)
- rtmp
- http 直连

**功能**:
- 频道切换
- EPG 节目单
- 直播状态显示

---

开始时间：2024-05-16
状态：进行中
