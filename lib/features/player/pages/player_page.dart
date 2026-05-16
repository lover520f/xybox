import 'package:flutter/material.dart';

class PlayerPage extends StatefulWidget {
  final Map<String, dynamic> vod;
  final int episode;

  const PlayerPage({
    super.key,
    required this.vod,
    required this.episode,
  });

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  bool _isPlaying = false;
  bool _showControls = true;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _volume = 0.5;
  double _speed = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 视频播放区域（占位）
          _buildVideoPlayer(),
          // 控制层
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 播放图标
            if (!_isPlaying)
              GestureDetector(
                onTap: _togglePlay,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            // 影片信息
            Text(
              '${widget.vod['name']} 第${widget.episode}集',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '（播放器开发中 - 使用占位符）',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return AnimatedOpacity(
      opacity: _showControls ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: GestureDetector(
        onTap: _toggleControls,
        behavior: HitTestBehavior.translucent,
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              // 顶部栏
              _buildTopBar(),
              // 中间控制区
              Expanded(
                child: Row(
                  children: [
                    // 左侧：上一集/下一集
                    Expanded(
                      child: GestureDetector(
                        onTap: _prevEpisode,
                        child: Container(
                          color: Colors.transparent,
                          child: const Icon(
                            Icons.skip_previous,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    // 右侧
                    Expanded(
                      child: GestureDetector(
                        onTap: _nextEpisode,
                        child: Container(
                          color: Colors.transparent,
                          child: const Icon(
                            Icons.skip_next,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 底部控制栏
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              '${widget.vod['name']} 第${widget.episode}集',
              style: const TextStyle(color: Colors.white, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.cast, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('DLNA 投屏功能开发中...'),
                  backgroundColor: Colors.blueAccent,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).padding.bottom + 8,
        top: 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          // 进度条
          _buildProgressBar(),
          const SizedBox(height: 12),
          // 控制按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(Icons.play_arrow, _togglePlay),
              _buildControlButton(Icons.volume_up, _adjustVolume),
              _buildControlButton(Icons.fast_forward, _adjustSpeed),
              _buildControlButton(Icons.settings, _showSettings),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            activeTrackColor: Colors.blueAccent,
            inactiveTrackColor: Colors.grey[700],
          ),
          child: Slider(
            value: _position.inSeconds.toDouble(),
            max: _duration.inSeconds.toDouble(),
            onChanged: (value) {
              setState(() {
                _position = Duration(seconds: value.toInt());
              });
            },
            onChangeEnd: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('跳转到 ${_formatTime(_position)}'),
                  backgroundColor: Colors.blueAccent,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatTime(_position),
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
              Text(
                _formatTime(_duration),
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isPlaying ? '开始播放' : '暂停播放'),
        backgroundColor: Colors.blueAccent,
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
  }

  void _prevEpisode() {
    if (widget.episode > 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('上一集'),
          backgroundColor: Colors.blueAccent,
        ),
      );
    }
  }

  void _nextEpisode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('下一集'),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  void _adjustVolume() {
    setState(() {
      _volume = _volume >= 1.0 ? 0.0 : _volume + 0.1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('音量：${(_volume * 100).toInt()}%'),
        backgroundColor: Colors.blueAccent,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _adjustSpeed() {
    setState(() {
      _speed = _speed >= 2.0 ? 0.5 : _speed + 0.5;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('倍速：${_speed}x'),
        backgroundColor: Colors.blueAccent,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2d2d2d),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '播放设置',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildSettingItem('弹幕', Icons.dns),
            _buildSettingItem('字幕', Icons.closed_caption),
            _buildSettingItem('画质', Icons.hd),
            _buildSettingItem('音频', Icons.music_note),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Text(
        '开发中',
        style: TextStyle(color: Colors.grey, fontSize: 12),
      ),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title功能开发中...'),
            backgroundColor: Colors.blueAccent,
          ),
        );
      },
    );
  }

  String _formatTime(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    // 模拟视频加载
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _duration = const Duration(minutes: 30);
          _position = Duration.zero;
        });
      }
    });
  }
}
