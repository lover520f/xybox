import 'package:flutter/material.dart';
import 'features/vod/pages/vod_home_page.dart';
import 'features/live/pages/live_page.dart';
import 'features/plugins/pages/plugins_page.dart';
import 'features/settings/pages/settings_page.dart';
import 'features/search/pages/search_page.dart';
import 'features/history/pages/history_page.dart';
import 'features/logs/pages/logs_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    const VodHomePage(),
    const LivePage(),
    const PluginsPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'XYBox',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: const Color(0xFF1a1a1a),
      ),
      home: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) => setState(() => _currentIndex = index),
          backgroundColor: const Color(0xFF2d2d2d),
          indicatorColor: Colors.blueAccent.withOpacity(0.3),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.movie), label: '影视'),
            NavigationDestination(icon: Icon(Icons.live_tv), label: '直播'),
            NavigationDestination(icon: Icon(Icons.extension), label: '插件'),
            NavigationDestination(icon: Icon(Icons.settings), label: '设置'),
          ],
        ),
      ),
    );
  }
}

// 简单插件页面占位
class PluginsPage extends StatelessWidget {
  const PluginsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1a1a1a),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.extension, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('插件管理', style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
