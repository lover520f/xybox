import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../bloc/vod_bloc.dart';
import 'vod_detail_page.dart';
import '../../search/pages/search_page.dart';
import '../../favorite/service/favorite_service.dart';
import '../../history/pages/history_page.dart';
import '../../../spider/spider_service.dart';

class VodHomePage extends StatefulWidget {
  const VodHomePage({super.key});

  @override
  State<VodHomePage> createState() => _VodHomePageState();
}

class _VodHomePageState extends State<VodHomePage> {
  bool _hasConfig = false;
  int _favoriteCount = 0;
  List<dynamic> _homeVods = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkConfigAndLoad();
  }

  Future<void> _checkConfigAndLoad() async {
    setState(() => _isLoading = true);
    
    // 检查配置
    final prefs = await SharedPreferences.getInstance();
    final configUrl = prefs.getString('vod_config_url');
    
    if (configUrl != null && configUrl.isNotEmpty) {
      final success = await SpiderService().loadConfig(configUrl);
      if (success) {
        setState(() => _hasConfig = true);
        await _loadHomeData();
      }
    }
    
    // 加载收藏数
    await FavoriteService().load();
    setState(() {
      _favoriteCount = FavoriteService().favorites.length;
      _isLoading = false;
    });
  }

  Future<void> _loadHomeData() async {
    try {
      final vods = await SpiderService().getHomeVod();
      if (mounted) setState(() => _homeVods = vods);
    } catch (e) {
      LoggerUtil.e('加载首页数据失败：$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1a1a1a),
      child: Column(
        children: [_buildTopBar(), Expanded(child: _buildContent())],
      ),
    );
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(12),
        color: const Color(0xFF2d2d2d),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage())),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: const Color(0xFF1a1a1a), borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey[500], size: 20),
                      const SizedBox(width: 8),
                      Text('搜索影视...', style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Badge(
                isLabelVisible: _favoriteCount > 0,
                label: Text('$_favoriteCount', style: const TextStyle(fontSize: 10, color: Colors.white)),
                child: const Icon(Icons.favorite_border, color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritePage())).then((_) => _checkConfigAndLoad());
              },
              tooltip: '收藏',
            ),
            IconButton(
              icon: const Icon(Icons.history, color: Colors.white),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryPage())),
              tooltip: '历史',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_hasConfig) {
      return _buildNoConfig();
    }

    if (_homeVods.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie_filter, size: 64, color: Colors.grey[600]),
            const SizedBox(height: 16),
            Text('暂无内容', style: TextStyle(color: Colors.grey[500], fontSize: 16)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadHomeData,
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 2 / 3, crossAxisSpacing: 12, mainAxisSpacing: 12,
        ),
        itemCount: _homeVods.length,
        itemBuilder: (context, index) => _buildVodCard(_homeVods[index]),
      ),
    );
  }

  Widget _buildNoConfig() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings_input_component, size: 64, color: Colors.grey[600]),
          const SizedBox(height: 16),
          Text('请先配置数据源', style: TextStyle(color: Colors.grey[500], fontSize: 16)),
          const SizedBox(height: 8),
          Text('设置 → 配置源管理 → 添加配置源', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => setState(() => _currentIndex = 3),
            icon: const Icon(Icons.settings),
            label: const Text('去设置'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
          ),
        ],
      ),
    );
  }

  Widget _buildVodCard(dynamic vod) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => VodDetailPage(vod: vod))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: const Color(0xFF2d2d2d), borderRadius: BorderRadius.circular(8)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: vod['pic'] != null && vod['pic'].toString().isNotEmpty
                    ? Image.network(vod['pic'], width: double.infinity, height: double.infinity, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.movie, size: 48, color: Colors.grey))
                    : const Icon(Icons.movie, size: 48, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(vod['name']?.toString() ?? '未知', style: const TextStyle(color: Colors.white, fontSize: 14),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          if (vod['remark'] != null && vod['remark'].toString().isNotEmpty)
            Text(vod['remark'], style: TextStyle(color: Colors.grey[500], fontSize: 12),
                maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

// 收藏页面导入
class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(title: const Text('我的收藏'), backgroundColor: const Color(0xFF2d2d2d), foregroundColor: Colors.white),
      body: const Center(child: Text('收藏功能开发中...', style: TextStyle(color: Colors.grey))),
    );
  }
}
