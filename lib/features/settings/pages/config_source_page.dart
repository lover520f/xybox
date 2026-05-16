import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ConfigSourcePage extends StatefulWidget {
  const ConfigSourcePage({super.key});

  @override
  State<ConfigSourcePage> createState() => _ConfigSourcePageState();
}

class _ConfigSourcePageState extends State<ConfigSourcePage> {
  final List<Map<String, dynamic>> _sources = [];
  final TextEditingController _urlController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSources();
  }

  Future<void> _loadSources() async {
    final prefs = await SharedPreferences.getInstance();
    final sourcesJson = prefs.getString('config_sources');
    if (sourcesJson != null) {
      final List<dynamic> decoded = json.decode(sourcesJson);
      final List<Map<String, dynamic>> sourcesList = decoded.cast<Map<String, dynamic>>();
      setState(() {
        _sources.addAll(sourcesList);
      });
    }
  }

  Future<void> _saveSources() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('config_sources', json.encode(_sources));
  }

  Future<void> _addSource() async {
    if (_urlController.text.isEmpty) return;
    
    final url = _urlController.text.trim();
    if (!url.startsWith('http')) {
      _showSnackbar('请输入有效的 HTTP/HTTPS 地址');
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final newSource = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'url': url,
          'name': _extractName(url),
          'status': 'active',
          'lastTest': DateTime.now().toIso8601String(),
        };
        
        setState(() {
          _sources.add(newSource);
          _urlController.clear();
        });
        await _saveSources();
        _showSnackbar('添加成功');
      } else {
        _showSnackbar('连接失败：${response.statusCode}');
      }
    } catch (e) {
      _showSnackbar('连接超时或错误');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _extractName(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host.replaceAll('www.', '').split('.').first.toUpperCase();
    } catch (e) {
      return '未知源';
    }
  }

  Future<void> _removeSource(String id) async {
    setState(() {
      _sources.removeWhere((s) => s['id'] == id);
    });
    await _saveSources();
  }

  Future<void> _testSource(Map<String, dynamic> source) async {
    setState(() => _isLoading = true);
    
    try {
      final response = await http.get(Uri.parse(source['url'])).timeout(const Duration(seconds: 10));
      source['status'] = response.statusCode == 200 ? 'active' : 'error';
      source['lastTest'] = DateTime.now().toIso8601String();
      _showSnackbar(response.statusCode == 200 ? '连接成功' : '连接失败');
    } catch (e) {
      source['status'] = 'error';
      _showSnackbar('连接超时');
    } finally {
      await _saveSources();
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blueAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        title: const Text('配置源管理'),
        backgroundColor: const Color(0xFF2d2d2d),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildAddSource(),
          Expanded(child: _buildSourceList()),
        ],
      ),
    );
  }

  Widget _buildAddSource() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF2d2d2d),
      child: Column(
        children: [
          TextField(
            controller: _urlController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: '输入配置源地址 (如：https://饭太硬.top/tv)',
              hintStyle: TextStyle(color: Colors.grey[500]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: Icon(Icons.link, color: Colors.grey[400]),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _addSource,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add),
                label: Text(_isLoading ? '添加中...' : '添加配置源'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.grey[500]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '推荐配置源：http://www.饭太硬.com/tv/ 或 https://饭太硬.top/tv',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSourceList() {
    if (_sources.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off, size: 64, color: Colors.grey[600]),
            const SizedBox(height: 16),
            Text(
              '暂无配置源',
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              '点击上方添加配置源',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _sources.length,
      itemBuilder: (context, index) {
        final source = _sources[index];
        return _buildSourceCard(source);
      },
    );
  }

  Widget _buildSourceCard(Map<String, dynamic> source) {
    final isActive = source['status'] == 'active';
    final lastTest = source['lastTest'] != null
        ? DateTime.tryParse(source['lastTest'])?.toString().substring(0, 16) ?? '未知'
        : '未测试';

    return Card(
      color: const Color(0xFF2d2d2d),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          isActive ? Icons.cloud_done : Icons.cloud_off,
          color: isActive ? Colors.green : Colors.grey,
        ),
        title: Text(
          source['name'] as String,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              source['url'] as String,
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              '上次测试：$lastTest',
              style: TextStyle(color: Colors.grey[600], fontSize: 11),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.refresh, size: 20),
              color: Colors.blueAccent,
              onPressed: () => _testSource(source),
              tooltip: '测试连接',
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              color: Colors.red[400],
              onPressed: () => _removeSource(source['id'] as String),
              tooltip: '删除',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}
