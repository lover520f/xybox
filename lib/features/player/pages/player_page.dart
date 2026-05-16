import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class PlayerPage extends StatefulWidget {
  final String url;
  final String title;
  final int episode;
  final List<String> episodes;

  const PlayerPage({
    super.key,
    required this.url,
    required this.title,
    this.episode = 1,
    this.episodes = const [],
  });

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late Player _player;
  late VideoController _controller;
  
  bool _isPlaying = false;
  bool _showControls = true;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _volume = 50.0;
  double _speed = 1.0;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    WakelockPlus.enable();
  }

  Future<void> _initializePlayer() async {
    try {
      _player = Player(
        configuration: const PlayerConfiguration(
          bufferSize: 10 * 1024 * 1024, // 10MB 缓冲
        ),
      );

      _controller = VideoController(
        _player,
        configuration: const VideoControllerConfiguration(
          enableHardwareAcceleration: true,
        ),
      );

      // 监听播放状态
      _player.stream.playing.listen((playing) {
        if (mounted) setState(() => _isPlaying = playing);
      });

      _player.stream.position.listen((position) {
        if (mounted) setState(() => _position = position);
      });

      _player.stream.duration.listen((duration) {
        if (mounted) setState(() => _duration = duration);
      });

      _player.stream.error.listen((error) {
        if (mounted) setState(() {
          _error = error;
          _isLoading = false;
        });
      });

      _player.stream.buffering.listen((buffering) {
        if (mounted) setState(() => _isLoading = buffering);
      });

      // 打开媒体源
      await _player.open(
        Media(
          widget.url,
          start: Duration.zero,
          extras: {
            'http-user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
          },
        ),
      );

      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) setState(() {
        _error = '播放器初始化失败：$e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _player.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 视频播放器
          _buildVideoPlayer(),
          // 加载指示器
          if (_isLoading) _buildLoadingIndicator(),
          // 错误显示
          if (_error != null) _buildErrorDisplay(),
          // 控制层
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Video(
      controller: _controller,
      width: double.infinity,
      height: double.infinity,
      controls: NoVideoControls,
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.blueAccent),
      ),
    );
  }

  Widget _buildErrorDisplay() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            Text(
              _error ?? '未知错误',
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _error = null;
                  _isLoading = true;
                });
                _initializePlayer();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              child: const Text('重试'),
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
              _buildTopBar(),
              Expanded(child: _buildCenterControls()),
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
          colors: [Colors.black.withOpacity(0.8), Colors.transparent],
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
              '${widget.title} 第${widget.episode}集',
              style: const TextStyle(color: Colors.white, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterControls() {
    return Center(
      child: GestureDetector(
        onTap: _togglePlay,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _isPlaying ? Icons.pause : Icons.play_arrow,
            size: 50,
            color: Colors.white,
          ),
        ),
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
          colors: [Colors.black.withOpacity(0.8), Colors.transparent],
        ),
      ),
      child: Column(
        children: [
          _buildProgressBar(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(Icons.replay_10, () => _seekRelative(-10)),
              _buildControlButton(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                _togglePlay,
              ),
              _buildControlButton(Icons.forward_10, () => _seekRelative(10)),
              _buildControlButton(Icons.speed, _adjustSpeed),
              _buildControlButton(Icons.volume_up, _adjustVolume),
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
            max: _duration.inSeconds.toDouble().clamp(1, double.infinity),
            onChanged: (value) {
              setState(() => _position = Duration(seconds: value.toInt()));
            },
            onChangeEnd: (value) {
              _player.seek(Duration(seconds: value.toInt()));
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
    if (_isPlaying) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
  }

  void _seekRelative(int seconds) {
    final newPosition = _position + Duration(seconds: seconds);
    _player.seek(newPosition);
  }

  void _adjustSpeed() {
    setState(() {
      _speed = _speed >= 2.0 ? 0.5 : _speed + 0.5;
      _player.setRate(_speed);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('倍速：${_speed}x'),
        backgroundColor: Colors.blueAccent,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _adjustVolume() {
    setState(() {
      _volume = _volume >= 100.0 ? 0.0 : _volume + 10.0;
      _player.setVolume(_volume);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('音量：${_volume.toInt()}%'),
        backgroundColor: Colors.blueAccent,
        duration: const Duration(seconds: 1),
      ),
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
}
