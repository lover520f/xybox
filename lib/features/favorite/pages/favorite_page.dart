import 'package:flutter/material.dart';
import '../service/favorite_service.dart';
import '../../vod/pages/vod_detail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Map<String, dynamic>> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    await FavoriteService().load();
    setState(() {
      _favorites = FavoriteService().favorites;
      _isLoading = false;
    });
  }

  Future<void> _removeFavorite(String id) async {
    await FavoriteService().remove(id);
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        title: const Text('我的收藏'),
        backgroundColor: const Color(0xFF2d2d2d),
        foregroundColor: Colors.white,
        actions: [
          if (_favorites.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: Colors.white),
              onPressed: () => _showClearConfirm(),
              tooltip: '清空收藏',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favorites.isEmpty
              ? _buildEmpty()
              : _buildList(),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64, color: Colors.grey[600]),
          const SizedBox(height: 16),
          Text('暂无收藏', style: TextStyle(color: Colors.grey[500], fontSize: 16)),
          const SizedBox(height: 8),
          Text('点击影视卡片的心形图标可加入收藏', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildList() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _favorites.length,
      itemBuilder: (context, index) {
        final fav = _favorites[index];
        return _buildFavoriteCard(fav);
      },
    );
  }

  Widget _buildFavoriteCard(Map<String, dynamic> fav) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VodDetailPage(vod: fav)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2d2d2d),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: fav['pic'] != null && fav['pic'].toString().isNotEmpty
                    ? Image.network(fav['pic'], width: double.infinity, height: double.infinity, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.movie, size: 48, color: Colors.grey))
                    : const Icon(Icons.movie, size: 48, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(fav['name']?.toString() ?? '未知', style: const TextStyle(color: Colors.white, fontSize: 14),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(fav['remark']?.toString() ?? '', style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red, size: 20),
                onPressed: () => _removeFavorite(fav['id']?.toString() ?? ''),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showClearConfirm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2d2d2d),
        title: const Text('清空收藏', style: TextStyle(color: Colors.white)),
        content: const Text('确定要清空所有收藏吗？', style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              FavoriteService().clear();
              _loadFavorites();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
