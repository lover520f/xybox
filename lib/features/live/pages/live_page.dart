import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  List<Map<String, dynamic>> _channels = [];
  String _selectedGroup = '全部';
  List<String> _groups = ['全部'];
  bool _isLoading = true;

  // 默认直播源
  final List<Map<String, dynamic>> _defaultChannels = [
    {'id': '1', 'name': 'CCTV-1', 'group': '央视', 'url': 'https://live-play.cctv.com/live/program/live/cctv1/1000000/live/live_src.m3u8'},
    {'id': '2', 'name': 'CCTV-2', 'group': '央视', 'url': ''},
    {'id': '3', 'name': 'CCTV-5', 'group': '央视', 'url': ''},
    {'id': '4', 'name': '湖南卫视', 'group': '卫视', 'url': ''},
    {'id': '5', 'name': '浙江卫视', 'group': '卫视', 'url': ''},
    {'id': '6', 'name': '江苏卫视', 'group': '卫视', 'url': ''},
  ];

  @override
  void initState() {
    super.initState();
    _loadLiveSources();
  }

  Future<void> _loadLiveSources() async {
    setState(() => _isLoading = true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final liveJson = prefs.getString('live_sources');
      
      if (liveJson != null && liveJson.isNotEmpty) {
        final List<dynamic> decoded = json.decode(liveJson);
        setState(() {
          _channels = decoded.cast<Map<String, dynamic>>();
          _updateGroups();
        });
      } else {
        setState(() {
          _channels = _defaultChannels;
          _updateGroups();
        });
      }
    } catch (e) {
      setState(() {
        _channels = _defaultChannels;
        _updateGroups();
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _updateGroups() {
    final groups = _channels.map((c) => c['group'] as String).toSet().toList();
    setState(() {
      _groups = ['全部', ...groups];
      if (!_groups.contains(_selectedGroup)) {
        _selectedGroup = '全部';
      }
    });
  }

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
          _buildHeader(),
          _buildGroupSelector(),
          Expanded(child: _isLoading ? const Center(child: CircularProgressIndicator()) : _buildChannelList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: const Color(0xFF2d2d2d),
      child: Row(
        children: [
          Icon(Icons.live_tv, color: Colors.blueAccent),
          const SizedBox(width: 12),
          const Text(
            '直播',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: _showLiveConfig,
            tooltip: '直播源配置',
          ),
        ],
      ),
    );
  }

  Widget _buildGroupSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: const Color(0xFF2d2d2d),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: _groups.map((group) {
            final isSelected = group == _selectedGroup;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
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
      ),
    );
  }

  Widget _buildChannelList() {
    if (_filteredChannels.isEmpty) {
      return const Center(child: Text('暂无频道'));
    }

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
    final hasUrl = channel['url'] != null && channel['url'].toString().isNotEmpty;
    
    return Card(
      color: const Color(0xFF2d2d2d),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.live_tv, color: hasUrl ? Colors.blueAccent : Colors.grey, size: 32),
        title: Text(
          channel['name'] as String,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: hasUrl ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          hasUrl ? channel['group'] as String : '（未配置地址）',
          style: TextStyle(color: hasUrl ? Colors.grey[500] : Colors.red[400], fontSize: 12),
        ),
        trailing: hasUrl ? const Icon(Icons.play_arrow, color: Colors.white) : const Icon(Icons.warning, color: Colors.orange),
        onTap: hasUrl ? () => _playChannel(channel) : () => _showConfigTip(channel),
      ),
    );
  }

  void _playChannel(Map<String, dynamic> channel) {
    final url = channel['url'] as String;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _LivePlayerPage(channel: channel, url: url),
      ),
    );
  }

  void _showConfigTip(Map<String, dynamic> channel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2d2d2d),
        title: Text(channel['name'] as String, style: const TextStyle(color: Colors.white)),
        content: const Text('该频道未配置直播源地址，请在设置中导入直播源。', style: TextStyle(color: Colors.grey)),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showLiveConfig();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            child: const Text('去配置'),
          ),
        ],
      ),
    );
  }

  void _showLiveConfig() {
    // TODO: 跳转到直播源配置页面
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('直播源配置功能开发中...'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

/// 直播播放页面
class _LivePlayerPage extends StatefulWidget {
  final Map<String, dynamic> channel;
  final String url;

  const _LivePlayerPage({required this.channel, required this.url});

  @override
  State<_LivePlayerPage> createState() => _LivePlayerPageState();
}

class _LivePlayerPageState extends State<_LivePlayerPage> {
  late Player _player;
  late VideoController _controller;
  bool _isLoading = true;
  bool _isPlaying = false;
  String? _error;

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

      _player.stream.error.listen((err) {
        if (mounted) setState(() {
          _error = err.toString();
          _isLoading = false;
        });
      });

      await _player.open(Media(widget.url));
      
      if (mounted) setState(() => _isLoading = false);
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

  Widget _buildErrorDisplay() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          Text(_error ?? '未知错误', style: const TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }
}
