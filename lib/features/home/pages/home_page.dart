import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Center(child: Text('首页', style: TextStyle(fontSize: 24, color: Colors.white))),
    const Center(child: Text('影视', style: TextStyle(fontSize: 24, color: Colors.white))),
    const Center(child: Text('直播', style: TextStyle(fontSize: 24, color: Colors.white))),
    const Center(child: Text('历史', style: TextStyle(fontSize: 24, color: Colors.white))),
    const Center(child: Text('设置', style: TextStyle(fontSize: 24, color: Colors.white))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        title: const Text('XYBox', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2d2d2d),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFF1a1a1a),
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
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: const Color(0xFF2d2d2d),
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey[400],
          selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
            BottomNavigationBarItem(icon: Icon(Icons.movie), label: '影视'),
            BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: '直播'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: '历史'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: '设置'),
          ],
        ),
      ),
    );
  }
}
