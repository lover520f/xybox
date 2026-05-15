import 'package:flutter/material.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('XYBox')),
      body: const Center(child: Text('Home')),
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
        BottomNavigationBarItem(icon: Icon(Icons.movie), label: '影视'),
        BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: '直播'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: '历史'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: '设置'),
      ]),
    );
  }
}
