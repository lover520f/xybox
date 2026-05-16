import 'package:flutter/material.dart';
import '../service/danmaku_service.dart';

/// 弹幕叠加层
class DanmakuOverlay extends StatefulWidget {
  final List<DanmakuItem> danmakus;
  final bool isVisible;
  final double currentPosition;

  const DanmakuOverlay({
    super.key,
    required this.danmakus,
    this.isVisible = true,
    this.currentPosition = 0,
  });

  @override
  State<DanmakuOverlay> createState() => _DanmakuOverlayState();
}

class _DanmakuOverlayState extends State<DanmakuOverlay>
    with SingleTickerProviderStateMixin {
  final Map<String, _DanmakuItemData> _items = {};
  final Map<String, AnimationController> _controllers = {};
  final Map<String, Animation<double>> _animations = {};

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible || widget.danmakus.isEmpty) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: widget.danmakus.map((danmaku) {
        return _buildDanmaku(danmaku);
      }).toList(),
    );
  }

  Widget _buildDanmaku(DanmakuItem item) {
    final key = item.id;
    final size = _measureText(item.content);
    final screenWidth = MediaQuery.of(context).size.width;

    if (!_items.containsKey(key)) {
      _items[key] = _DanmakuItemData(
        offsetX: screenWidth,
        startY: _getYPosition(item, size.height),
      );

      final controller = AnimationController(
        duration: Duration(milliseconds: ((screenWidth + size.width) / 300 * 1000).toInt()),
        vsync: this,
      );

      final animation = Tween<double>(
        begin: screenWidth,
        end: -size.width,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      ));

      _controllers[key] = controller;
      _animations[key] = animation;
      
      controller.forward();
    }

    final itemData = _items[key]!;
    final animation = _animations[key];

    return Positioned(
      top: itemData.startY,
      left: animation?.value ?? itemData.offsetX,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          item.content,
          style: TextStyle(
            color: _hexToColor(item.color),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            shadows: const [
              Shadow(offset: Offset(1, 1), blurRadius: 2, color: Colors.black),
            ],
          ),
          softWrap: false,
        ),
      ),
    );
  }

  double _getYPosition(DanmakuItem item, double height) {
    switch (item.mode) {
      case DanmakuMode.top:
        return 20;
      case DanmakuMode.bottom:
        return MediaQuery.of(context).size.height - height - 40;
      case DanmakuMode.scroll:
        return 20 + (_items.length % 10) * 40;
    }
  }

  Size _measureText(String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.size;
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _items.clear();
    _controllers.clear();
    _animations.clear();
    super.dispose();
  }
}

class _DanmakuItemData {
  double offsetX;
  double startY;

  _DanmakuItemData({required this.offsetX, required this.startY});
}
