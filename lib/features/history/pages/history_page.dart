import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final histories = <Map<String, dynamic>>[
      {'name': '电视剧 1', 'episode': '第 5 集', 'time': '2024-05-15', 'progress': 0.6},
      {'name': '电影 1', 'episode': '全集', 'time': '2024-05-14', 'progress': 0.3},
      {'name': '综艺 1', 'episode': '第 10 期', 'time': '2024-05-13', 'progress': 0.8},
    ];

    return Container(
      color: const Color(0xFF1a1a1a),
      child: histories.isEmpty
          ? _buildEmptyState()
          : _buildHistoryList(context, histories),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey),
          const SizedBox(height: 24),
          const Text(
            '暂无观看历史',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(BuildContext context, List<Map<String, dynamic>> histories) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: histories.length,
      itemBuilder: (context, index) {
        final history = histories[index];
        return Card(
          color: const Color(0xFF2d2d2d),
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 110,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1a1a1a),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.movie, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(history['name'] as String, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(history['episode'] as String, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                      const SizedBox(height: 8),
                      Text(history['time'] as String, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: history['progress'] as double,
                          backgroundColor: Colors.grey,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                          minHeight: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.play_arrow, color: Colors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('播放 ${history['name']}'), backgroundColor: Colors.blueAccent),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
