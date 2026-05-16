import 'package:flutter/material.dart';
import '../../player/pages/player_page.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        title: const Text('详情'),
        backgroundColor: const Color(0xFF2d2d2d),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
            color: _isFavorite ? Colors.red : Colors.white,
            onPressed: () {
              setState(() => _isFavorite = !_isFavorite);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isFavorite ? '已加入收藏' : '已取消收藏'),
                  backgroundColor: Colors.blueAccent,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 封面和信息
            _buildHeader(),
            const SizedBox(height: 20),
            // 简介
            _buildDescription(),
            const SizedBox(height: 20),
            // 选集
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
          // 封面
          Container(
            width: 120,
            height: 170,
            decoration: BoxDecoration(
              color: const Color(0xFF1a1a1a),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.movie, size: 48, color: Colors.grey[600]),
          ),
          const SizedBox(width: 16),
          // 信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.vod['name'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
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
          Text(
            '$label: ',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
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
              Icon(Icons.description, color: Colors.blueAccent),
              const SizedBox(width: 8),
              const Text(
                '简介',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '这是一个${widget.vod['name']}的简介。暂无详细内容，等待后续接入真实数据源。',
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
              Icon(Icons.list, color: Colors.blueAccent),
              const SizedBox(width: 8),
              const Text(
                '选集',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '共${_episodes.length}集',
                style: TextStyle(color: Colors.grey[500]),
              ),
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
                    border: Border.all(
                      color: isSelected ? Colors.blueAccent : Colors.transparent,
                    ),
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerPage(
          vod: widget.vod,
          episode: _selectedEpisode + 1,
        ),
      ),
    );
  }
}
