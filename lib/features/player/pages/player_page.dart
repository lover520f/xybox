import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../danmaku/service/danmaku_service.dart';
import '../../danmaku/widget/danmaku_overlay.dart';
import '../../dlna/pages/dlna_cast_page.dart';

class PlayerPage extends StatefulWidget {
  final String url;
  final String title;
  final int episode;

  const PlayerPage({
    super.key,
    required this.url,
    required this.title,
    this.episode = 1,
  });

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late Player _player;
  late VideoController _controller;
  bool _isLoading = true;
  bool _isPlaying = false;
  bool _showControls = true;
  bool _showDanmaku = true;
  
  final DanmakuService _danmakuService = DanmakuService();
  final List<DanmakuItem> _visibleDanmakus = [];
  final TextEditingController _danmakuController = TextEditingController();
  
  double _currentPosition = 0;
  double _duration = 0;
  double _speed = 1.0;
  String? _error;

  final List<DanmakuItem> _mockDanmakus = [
    DanmakuItem(id: '1', content: '前方高能！', startTime: 5, mode: DanmakuMode.scroll),
    DanmakuItem(id: '2', content: '233333', startTime: 10, mode: DanmakuMode.scroll),
    DanmakuItem(id: '3', content: '哈哈哈', startTime: 15, mode: DanmakuMode.scroll),
    DanmakuItem(id: '4', content: '泪目', startTime: 20, mode: DanmakuMode.scroll),
    DanmakuItem(id: '5', content: '名场面！', startTime: 25, mode: DanmakuMode.scroll),
  ];

  @override
  void initState() {
    super.initState();
    _checkAndInitializePlayer();
  }

  Future<void> _checkAndInitializePlayer() async {
    if (widget.url.isEmpty || !widget.url.startsWith('http')) {
      setState(() {
        _error = '无效的视频地址';
        _isLoading = false;
      });
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
        if (mounted) {
          setState(() {
            _currentPosition = position.inSeconds.toDouble();
            _updateDanmakus();
          });
        }
      });

      _player.stream.error.listen((err) {
        if (mounted) {
          setState(() {
            _error = '播放错误：${err.toString()}';
            _isLoading = false;
          });
        }
      });

      await _player.open(Media(widget.url));
      _danmakuService.loadDanmakus(_mockDanmakus);
      
      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = '播放器初始化失败：$e';
          _isLoading = false;
        });
      }
    }
  }

  void _updateDanmakus() {
    _danmakuService.updatePosition(_currentPosition);
    final screenWidth = MediaQuery.of(context).size.width;
    _visibleDanmakus.clear();
    _visibleDanmakus.addAll(_danmakuService.getVisibleDanmakus(screenWidth));
  }

  void _togglePlay() {
    if (_isPlaying) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  void _seek(double seconds) {
    if (seconds < 0) seconds = 0;
    if (seconds > _duration) seconds = _duration;
    _player.seek(Duration(seconds: seconds.toInt()));
    _danmakuService.seek(seconds);
  }

  void _sendDanmaku() {
    if (_danmakuController.text.isEmpty) return;
    
    _danmakuService.sendDanmaku(_danmakuController.text);
    _danmakuController.clear();
    FocusScope.of(context).unfocus();
    
    setState(() {});
  }

  void _showDlnaCast() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DlnaCastPage(
          videoUrl: widget.url,
          title: '${widget.title} 第${widget.episode}集',
        ),
      ),
    );
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _danmakuService.dispose();
    _player.dispose();
    _danmakuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildPlayer(),
          _buildDanmaku(),
          _buildOverlay(),
        ],
      ),
    );
  }

  Widget _buildPlayer() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
    }

    if (_error != null) {
      return _buildErrorDisplay();
    }

    return Video(controller: _controller, width: double.infinity, height: double.infinity);
  }

  Widget _buildDanmaku() {
    if (!_showDanmaku) return const SizedBox.shrink();
    return DanmakuOverlay(
      danmakus: _visibleDanmakus,
      isVisible: _showDanmaku,
      currentPosition: _currentPosition,
    );
  }

  Widget _buildOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          setState(() => _showControls = !_showControls);
        },
        child: AnimatedOpacity(
          opacity: _showControls ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: Column(
              children: [
                _buildTopBar(),
                const Spacer(),
                _buildControls(),
                _buildDanmakuInput(),
              ],
            ),
          ),
        ),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _error ?? '未知错误',
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
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

  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
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
            IconButton(
              icon: const Icon(Icons.cast, color: Colors.white),
              onPressed: _showDlnaCast,
              tooltip: '投屏',
            ),
            IconButton(
              icon: Icon(_showDanmaku ? Icons.subtitles : Icons.subtitles_off, color: Colors.white),
              onPressed: () => setState(() => _showDanmaku = !_showDanmaku),
            ),
            PopupMenuButton<double>(
              icon: const Icon(Icons.speed, color: Colors.white),
              onSelected: (speed) {
                setState(() => _speed = speed);
                _player.setRate(speed);
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 0.5, child: Text('0.5x')),
                const PopupMenuItem(value: 1.0, child: Text('1.0x')),
                const PopupMenuItem(value: 1.25, child: Text('1.25x')),
                const PopupMenuItem(value: 1.5, child: Text('1.5x')),
                const PopupMenuItem(value: 2.0, child: Text('2.0x')),
              ],
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
        children: [
          _buildProgressBar(),
          const SizedBox(height: 16),
          _buildControlButtons(),
        ],
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
        IconButton(
          icon: const Icon(Icons.replay_10, color: Colors.white, size: 32),
          onPressed: () => _seek(_currentPosition - 10),
        ),
        IconButton(
          icon: Icon(
            _isPlaying ? Icons.pause_circle : Icons.play_circle,
            color: Colors.white,
            size: 48,
          ),
          onPressed: _togglePlay,
        ),
        IconButton(
          icon: const Icon(Icons.forward_10, color: Colors.white, size: 32),
          onPressed: () => _seek(_currentPosition + 10),
        ),
      ],
    );
  }

  Widget _buildDanmakuInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _danmakuController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '发个弹幕...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.black.withOpacity(0.5),
              ),
              onSubmitted: (_) => _sendDanmaku(),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _sendDanmaku,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('发送'),
          ),
        ],
      ),
    );
  }
}
