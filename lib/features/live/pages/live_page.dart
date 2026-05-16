import 'package:flutter/material.dart';

class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  final List<Map<String, dynamic>> _channels = [
    {'id': '1', 'name': 'CCTV-1', 'group': '央视', 'logo': Icons.tv},
    {'id': '2', 'name': 'CCTV-2', 'group': '央视', 'logo': Icons.tv},
    {'id': '3', 'name': 'CCTV-5', 'group': '央视', 'logo': Icons.sports_soccer},
    {'id': '4', 'name': '湖南卫视', 'group': '卫视', 'logo': Icons.live_tv},
    {'id': '5', 'name': '浙江卫视', 'group': '卫视', 'logo': Icons.live_tv},
    {'id': '6', 'name': '江苏卫视', 'group': '卫视', 'logo': Icons.live_tv},
    {'id': '7', 'name': '东方卫视', 'group': '卫视', 'logo': Icons.live_tv},
    {'id': '8', 'name': '北京卫视', 'group': '卫视', 'logo': Icons.live_tv},
  ];

  String _selectedGroup = '全部';
  final List<String> _groups = ['全部', '央视', '卫视'];

  List<Map<String, dynamic>> get _filteredChannels {
    if (_selectedGroup == '全部') return _channels;
    return _channels.where((c) => c['group'] == _selectedGroup).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1a1a1a),
      child: Column(
        children: [
          // 分组选择
          _buildGroupSelector(),
          // 频道列表
          Expanded(
            child: _buildChannelList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupSelector() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: const Color(0xFF2d2d2d),
      child: Row(
        children: _groups.map((group) {
          final isSelected = group == _selectedGroup;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedGroup = group),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blueAccent : const Color(0xFF1a1a1a),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  group,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[400],
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChannelList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _filteredChannels.length,
      itemBuilder: (context, index) {
        final channel = _filteredChannels[index];
        return _buildChannelCard(channel);
      },
    );
  }

  Widget _buildChannelCard(Map<String, dynamic> channel) {
    return Card(
      color: const Color(0xFF2d2d2d),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          channel['logo'] as IconData,
          color: Colors.blueAccent,
          size: 32,
        ),
        title: Text(
          channel['name'] as String,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        subtitle: Text(
          channel['group'] as String,
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
        trailing: const Icon(Icons.play_arrow, color: Colors.white),
        onTap: () => _playChannel(channel),
      ),
    );
  }

  void _playChannel(Map<String, dynamic> channel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LivePlayerPage(channel: channel),
      ),
    );
  }
}

// 直播播放页面
class LivePlayerPage extends StatelessWidget {
  final Map<String, dynamic> channel;

  const LivePlayerPage({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(channel['name'] as String),
        backgroundColor: const Color(0xFF2d2d2d),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.live_tv, size: 80, color: Colors.grey[600]),
            const SizedBox(height: 24),
            Text(
              '${channel['name']} 直播',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              '（直播播放功能开发中）',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
