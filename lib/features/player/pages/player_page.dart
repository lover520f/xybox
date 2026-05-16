import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../core/utils/logger_util.dart';

class PlayerPage extends StatefulWidget {
  final String url;
  final String title;
  final int episode;

  const PlayerPage({super.key, required this.url, required this.title, this.episode = 1});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late Player _player;
  late VideoController _controller;
  bool _isLoading = true;
  bool _isPlaying = false;
  bool _showControls = true;
  String? _error;
  double _currentPosition = 0;
  double _duration = 0;

  @override
  void initState() {
    super.initState();
    _checkAndInitializePlayer();
  }

  Future<void> _checkAndInitializePlayer() async {
    if (widget.url.isEmpty || !widget.url.startsWith('http')) {
      setState(() {
        _error = '视频地址无效';
        _isLoading = false;
      });
      LoggerUtil.e('播放失败：URL 为空或无效');
      return;
    }

    try {
      await WakelockPlus.enable();
      _player = Player();
      _controller = VideoController(_player);

      _player.stream.playing.listen((playing) {
        if (mounted) setState(() => _isPlaying = playing);
      });

      _player.stream.duration.listen((duration) {
        if (mounted) setState(() => _duration = duration.inSeconds.toDouble());
      });

      _player.stream.position.listen((position) {
        if (mounted) setState(() => _currentPosition = position.inSeconds.toDouble());
      });

      _player.stream.error.listen((err) {
        LoggerUtil.e('播放器错误：$err');
        if (mounted) setState(() {
          _error = '播放错误：$err';
          _isLoading = false;
        });
      });

      LoggerUtil.i('开始加载视频：${widget.url}');
      await _player.open(Media(widget.url));
      LoggerUtil.i('视频加载成功');
      
      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      LoggerUtil.e('播放器初始化失败：$e');
      if (mounted) setState(() {
        _error = '播放器初始化失败：$e';
        _isLoading = false;
      });
    }
  }

  void _togglePlay() {
    _isPlaying ? _player.pause() : _player.play();
  }

  void _seek(double seconds) {
    if (seconds < 0) seconds = 0;
    if (seconds > _duration) seconds = _duration;
    _player.seek(Duration(seconds: seconds.toInt()));
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [_buildPlayer(), _buildOverlay()],
      ),
    );
  }

  Widget _buildPlayer() {
    if (_isLoading) return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
    if (_error != null) return _buildErrorDisplay();
    return Video(controller: _controller, width: double.infinity, height: double.infinity);
  }

  Widget _buildErrorDisplay() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(_error ?? '未知错误', style: const TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center),
          ),
          const SizedBox(height: 8),
          Text('请检查视频地址是否正确', style: TextStyle(color: Colors.grey[500], fontSize: 14)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('返回'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => setState(() => _showControls = !_showControls),
        child: AnimatedOpacity(
          opacity: _showControls ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.7), Colors.transparent, Colors.black.withOpacity(0.7)],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: Column(
              children: [_buildTopBar(), const Spacer(), _buildControls()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
            Expanded(
              child: Text('${widget.title} 第${widget.episode}集',
                  style: const TextStyle(color: Colors.white, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [_buildProgressBar(), const SizedBox(height: 16), _buildControlButtons()],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Center(
      child: StreamBuilder(
        stream: _player.stream.position,
        builder: (context, snapshot) {
          final position = snapshot.data?.inSeconds.toDouble() ?? 0;
          return SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: SliderComponentShape.noOverlay,
              activeTrackColor: Colors.blueAccent,
              inactiveTrackColor: Colors.grey.withOpacity(0.3),
              thumbColor: Colors.blueAccent,
            ),
            child: Slider(
              value: _duration > 0 ? position.clamp(0, _duration) : 0,
              min: 0,
              max: _duration > 0 ? _duration : 1,
              onChanged: (value) => _seek(value),
            ),
          );
        },
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(icon: const Icon(Icons.replay_10, color: Colors.white, size: 32), onPressed: () => _seek(_currentPosition - 10)),
        IconButton(
          icon: Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle, color: Colors.white, size: 48),
          onPressed: _togglePlay,
        ),
        IconButton(icon: const Icon(Icons.forward_10, color: Colors.white, size: 32), onPressed: () => _seek(_currentPosition + 10)),
      ],
    );
  }
}
