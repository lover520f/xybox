import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  // 模拟频道数据
  final List<Map<String, dynamic>> _channels = [
    {'id': '1', 'name': 'CCTV-1', 'group': '央视', 'url': 'http://live-play.cctv.com/live/program/live/cctv1/1000000/live/live_src.m3u8'},
    {'id': '2', 'name': 'CCTV-2', 'group': '央视', 'url': ''},
    {'id': '3', 'name': 'CCTV-5', 'group': '央视', 'url': ''},
    {'id': '4', 'name': '湖南卫视', 'group': '卫视', 'url': ''},
    {'id': '5', 'name': '浙江卫视', 'group': '卫视', 'url': ''},
    {'id': '6', 'name': '江苏卫视', 'group': '卫视', 'url': ''},
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
          _buildGroupSelector(),
          Expanded(child: _buildChannelList()),
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
        leading: Icon(Icons.live_tv, color: Colors.blueAccent, size: 32),
        title: Text(channel['name'] as String, style: const TextStyle(color: Colors.white, fontSize: 16)),
        subtitle: Text(channel['group'] as String, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
        trailing: const Icon(Icons.play_arrow, color: Colors.white),
        onTap: () => _playChannel(channel),
      ),
    );
  }

  void _playChannel(Map<String, dynamic> channel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LivePlayerPage(
          channel: channel,
          url: channel['url'] as String,
        ),
      ),
    );
  }
}

/// 直播播放页面
class LivePlayerPage extends StatefulWidget {
  final Map<String, dynamic> channel;
  final String url;

  const LivePlayerPage({
    super.key,
    required this.channel,
    required this.url,
  });

  @override
  State<LivePlayerPage> createState() => _LivePlayerPageState();
}

class _LivePlayerPageState extends State<LivePlayerPage> {
  late Player _player;
  late VideoController _controller;
  bool _isLoading = true;
  String? _error;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _player = Player();
      _controller = VideoController(_player);

      _player.stream.playing.listen((playing) {
        if (mounted) setState(() => _isPlaying = playing);
      });

      _player.stream.buffering.listen((buffering) {
        if (mounted) setState(() => _isLoading = buffering);
      });

      _player.stream.error.listen((error) {
        if (mounted) setState(() {
          _error = error;
          _isLoading = false;
        });
      });

      // 如果有真实 URL，尝试播放
      if (widget.url.isNotEmpty) {
        await _player.open(Media(widget.url));
      } else {
        // 演示模式
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() {
        _error = '播放失败：$e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('${widget.channel['name']} 直播'),
        backgroundColor: const Color(0xFF2d2d2d),
        foregroundColor: Colors.white,
      ),
      body: _buildPlayer(),
    );
  }

  Widget _buildPlayer() {
    if (widget.url.isEmpty) {
      return _buildDemoPlayer();
    }

    if (_error != null) {
      return _buildErrorDisplay();
    }

    return Stack(
      children: [
        Video(controller: _controller, width: double.infinity, height: double.infinity),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.7),
            child: const Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
          ),
      ],
    );
  }

  Widget _buildDemoPlayer() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.live_tv, size: 80, color: Colors.grey[600]),
          const SizedBox(height: 24),
          Text(
            '${widget.channel['name']} 直播',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 8),
          Text(
            '（直播播放功能已实现，需要配置真实直播源 URL）',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('已在后台播放（需要配置直播源）'),
                  backgroundColor: Colors.blueAccent,
                ),
              );
              // 实际使用：_player.play();
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('开始播放'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorDisplay() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          Text(
            _error ?? '未知错误',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
