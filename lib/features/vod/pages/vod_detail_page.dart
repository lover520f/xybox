import 'package:flutter/material.dart';
import '../../player/pages/player_page.dart';
import '../../favorite/service/favorite_service.dart';

class VodDetailPage extends StatefulWidget {
  final Map<String, dynamic> vod;

  const VodDetailPage({super.key, required this.vod});

  @override
  State<VodDetailPage> createState() => _VodDetailPageState();
}

class _VodDetailPageState extends State<VodDetailPage> {
  final List<String> _episodes = List.generate(20, (i) => '第${i + 1}集');
  int _selectedEpisode = 0;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final id = widget.vod['id']?.toString() ?? '';
    final isFav = FavoriteService().isFavorite(id);
    if (mounted) setState(() => _isFavorite = isFav);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        title: const Text('详情'),
        backgroundColor: const Color(0xFF2d2d2d),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? Colors.red : Colors.white),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildDescription(),
            const SizedBox(height: 20),
            _buildEpisodes(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF2d2d2d),
      child: Row(
        children: [
          Container(
            width: 120,
            height: 170,
            decoration: BoxDecoration(
              color: const Color(0xFF1a1a1a),
              borderRadius: BorderRadius.circular(8),
            ),
            child: widget.vod['pic'] != null && widget.vod['pic'].toString().isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(widget.vod['pic'], width: 120, height: 170, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.movie, size: 48, color: Colors.grey)),
                  )
                : const Icon(Icons.movie, size: 48, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.vod['name'] as String,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildInfoRow('年份', widget.vod['year'] ?? '未知'),
                _buildInfoRow('地区', widget.vod['area'] ?? '未知'),
                _buildInfoRow('更新', widget.vod['remark'] ?? '未知'),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _playVideo,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('立即播放'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(color: Colors.grey[500], fontSize: 14)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description, color: Colors.blueAccent),
              const SizedBox(width: 8),
              const Text('简介', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '这是${widget.vod['name']}的简介。等待接入真实数据源。',
            style: TextStyle(color: Colors.grey[400], height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodes() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.list, color: Colors.blueAccent),
              const SizedBox(width: 8),
              const Text('选集', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              Text('共${_episodes.length}集', style: TextStyle(color: Colors.grey[500])),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _episodes.asMap().entries.map((entry) {
              final index = entry.key;
              final episode = entry.value;
              final isSelected = index == _selectedEpisode;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedEpisode = index);
                  _playVideo();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blueAccent : const Color(0xFF2d2d2d),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    episode,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[400],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _playVideo() {
    final url = widget.vod['url'] as String? ?? '';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerPage(
          url: url.isNotEmpty ? url : 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          title: widget.vod['name'] as String,
          episode: _selectedEpisode + 1,
        ),
      ),
    );
  }

  Future<void> _toggleFavorite() async {
    final result = await FavoriteService().toggle(widget.vod);
    if (mounted) {
      setState(() => _isFavorite = !_isFavorite);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isFavorite ? '已加入收藏' : '已取消收藏'),
          backgroundColor: Colors.blueAccent,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }
}
