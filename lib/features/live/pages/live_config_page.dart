import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class LiveConfigPage extends StatefulWidget {
  const LiveConfigPage({super.key});

  @override
  State<LiveConfigPage> createState() => _LiveConfigPageState();
}

class _LiveConfigPageState extends State<LiveConfigPage> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _importController = TextEditingController();
  List<Map<String, dynamic>> _sources = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSources();
  }

  Future<void> _loadSources() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('live_sources') ?? '[]';
    setState(() {
      _sources = (json.decode(jsonStr) as List).map((e) => Map<String, dynamic>.from(e)).toList();
    });
  }

  Future<void> _saveSources() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('live_sources', json.encode(_sources));
  }

  Future<void> _addSource() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final content = response.body;
        final channels = _parseContent(content, url);
        
        if (channels.isNotEmpty) {
          setState(() {
            _sources = channels;
            _urlController.clear();
          });
          await _saveSources();
          _showSnackbar('导入成功：${channels.length}个频道');
        } else {
          _showSnackbar('未解析到频道，请检查格式');
        }
      } else {
        _showSnackbar('连接失败：${response.statusCode}');
      }
    } catch (e) {
      _showSnackbar('连接超时或错误');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> _parseContent(String content, String sourceUrl) {
    final channels = <Map<String, dynamic>>[];
    final lines = content.split('\n');
    String currentGroup = '默认';
    String? currentName;

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;

      // M3U 格式：#EXTINF:-1 tvg-name="CCTV-1" group-title="央视",CCTV-1
      if (line.startsWith('#EXTINF:')) {
        final nameMatch = RegExp(r',(.+)$').firstMatch(line);
        currentName = nameMatch?.group(1)?.trim();
        
        final groupMatch = RegExp(r'group-title="([^"]+)"').firstMatch(line);
        if (groupMatch != null) {
          currentGroup = groupMatch.group(1) ?? '默认';
        }
      }
      // 频道地址
      else if (line.startsWith('http') && currentName != null) {
        channels.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString() + channels.length.toString(),
          'name': currentName!,
          'group': currentGroup,
          'url': line,
          'source': sourceUrl,
        });
        currentName = null;
      }
      // TXT 格式：央视，CCTV-1#http://xxx
      else if (line.contains('#') && line.contains(',')) {
        final parts = line.split('#');
        if (parts.length >= 2) {
          final infoParts = parts[0].split(',');
          final group = infoParts.first;
          final name = infoParts.length > 1 ? infoParts.sublist(1).join(',') : '未知';
          final url = parts[1].trim();
          if (url.startsWith('http')) {
            channels.add({
              'id': DateTime.now().millisecondsSinceEpoch.toString() + channels.length.toString(),
              'name': name.trim(),
              'group': group.trim(),
              'url': url,
              'source': '本地导入',
            });
          }
        }
      }
      // JSON 格式解析
      else if (line.startsWith('{') && line.contains('url')) {
        try {
          final jsonLine = json.decode(line);
          channels.add({
            'id': jsonLine['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
            'name': jsonLine['name'] ?? '未知',
            'group': jsonLine['group'] ?? '默认',
            'url': jsonLine['url'] ?? '',
            'source': 'JSON 导入',
          });
        } catch (e) {
          // 忽略 JSON 解析错误
        }
      }
    }

    return channels;
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.blueAccent, duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        title: const Text('直播源配置'),
        backgroundColor: const Color(0xFF2d2d2d),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildImportSection(),
          Expanded(child: _buildSourceList()),
        ],
      ),
    );
  }

  Widget _buildImportSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF2d2d2d),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('在线导入', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(
            controller: _urlController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: '输入直播源地址 (m3u/txt/json)',
              hintStyle: TextStyle(color: Colors.grey[500]),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              prefixIcon: Icon(Icons.link, color: Colors.grey[400]),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _addSource,
                icon: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.download),
                label: Text(_isLoading ? '导入中...' : '导入直播源'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('支持格式：M3U, TXT, JSON', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildChip('http://livetv.xxx/live.txt', '示例 1'),
              _buildChip('https://xxx.com/iptv.m3u', '示例 2'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String url, String label) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 12, color: Colors.white)),
      backgroundColor: const Color(0xFF1a1a1a),
      onPressed: () {
        _urlController.text = url;
      },
    );
  }

  Widget _buildSourceList() {
    if (_sources.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.live_tv, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('暂无直播源', style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      );
    }

    final groups = _sources.map((s) => s['group'] as String).toSet().toList();

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        final groupChannels = _sources.where((s) => s['group'] == group).toList();
        return _buildGroupCard(group, groupChannels);
      },
    );
  }

  Widget _buildGroupCard(String group, List<Map<String, dynamic>> channels) {
    return Card(
      color: const Color(0xFF2d2d2d),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(group, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const Spacer(),
                Text('${channels.length}个频道', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: channels.map((c) {
                return Chip(
                  label: Text(c['name'] as String, style: const TextStyle(fontSize: 12, color: Colors.white)),
                  backgroundColor: const Color(0xFF1a1a1a),
                  deleteIcon: const Icon(Icons.close, size: 16, color: Colors.red),
                  onDeleted: () {
                    setState(() => _sources.remove(c));
                    _saveSources();
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _importController.dispose();
    super.dispose();
  }
}
