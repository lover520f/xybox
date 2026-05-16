import 'package:flutter/material.dart';
import '../../vod/pages/vod_page.dart';
import '../../live/pages/live_page.dart';
import '../../history/pages/history_page.dart';
import '../../settings/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(title: '首页'),
    const VodPage(),
    const LivePage(),
    const HistoryPage(),
    const SettingsPage(),
  ];

  final List<Map<String, dynamic>> _navItems = [
    {'title': '首页', 'icon': Icons.home},
    {'title': '影视', 'icon': Icons.movie},
    {'title': '直播', 'icon': Icons.live_tv},
    {'title': '历史', 'icon': Icons.history},
    {'title': '设置', 'icon': Icons.settings},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    debugPrint('切换到了：${_navItems[index]['title']}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        title: Text(
          _navItems[_currentIndex]['title'] as String,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2d2d2d),
        elevation: 0,
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2d2d2d),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: _navItems.map((item) => BottomNavigationBarItem(
            icon: Icon(item['icon'] as IconData, size: 24),
            label: item['title'] as String,
          )).toList(),
          currentIndex: _currentIndex,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey[400],
          selectedFontSize: 14,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          onTap: _onItemTapped,
          backgroundColor: const Color(0xFF2d2d2d),
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final String title;
  const HomeContent({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1a1a1a),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.tv, size: 80, color: Colors.grey[600]),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '功能开发中...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
