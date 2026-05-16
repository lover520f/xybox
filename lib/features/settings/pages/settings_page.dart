import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'config_source_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _configUrlController = TextEditingController();
  String? _savedConfigUrl;
  bool _isLoading = false;
  int _sourceCount = 0;

  @override
  void initState() {
    super.initState();
    _loadConfigUrl();
    _loadSourceCount();
  }

  Future<void> _loadConfigUrl() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedConfigUrl = prefs.getString('vod_config_url');
      _configUrlController.text = _savedConfigUrl ?? '';
    });
  }

  Future<void> _loadSourceCount() async {
    final prefs = await SharedPreferences.getInstance();
    final sourcesJson = prefs.getString('config_sources');
    if (sourcesJson != null) {
      final List<dynamic> decoded = json.decode(sourcesJson);
      setState(() => _sourceCount = decoded.length);
    }
  }

  Future<void> _saveConfigUrl() async {
    if (_configUrlController.text.isEmpty) {
      _showSnackbar('请输入配置地址');
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('vod_config_url', _configUrlController.text);
      
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackbar('配置保存成功');
        _loadConfigUrl();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackbar('保存失败');
      }
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
    return Container(
      color: const Color(0xFF1a1a1a),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildConfigCard(),
          const SizedBox(height: 16),
          _buildDataCard(),
          const SizedBox(height: 16),
          _buildAboutCard(),
        ],
      ),
    );
  }

  Widget _buildConfigCard() {
    return Card(
      color: const Color(0xFF2d2d2d),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.settings_input_component, color: Colors.blueAccent),
                const SizedBox(width: 12),
                const Text(
                  '配置管理',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            ListTile(
              leading: Icon(Icons.cloud, color: Colors.blueAccent),
              title: const Text('配置源管理', style: TextStyle(color: Colors.white)),
              subtitle: Text('$_sourceCount 个配置源', style: TextStyle(color: Colors.grey[500])),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ConfigSourcePage()),
                ).then((_) => _loadSourceCount());
              },
            ),
            
            const Divider(color: Colors.grey, height: 24),
            
            TextField(
              controller: _configUrlController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '输入配置地址',
                hintStyle: TextStyle(color: Colors.grey[500]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blueAccent),
                ),
                prefixIcon: Icon(Icons.link, color: Colors.grey[400]),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _saveConfigUrl,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(_isLoading ? '保存中...' : '保存配置'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataCard() {
    return Card(
      color: const Color(0xFF2d2d2d),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.storage, color: Colors.orange),
                const SizedBox(width: 12),
                const Text(
                  '数据管理',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.delete_outline, color: Colors.red[400]),
              title: const Text('清除历史记录', style: TextStyle(color: Colors.white)),
              subtitle: Text('删除所有观看历史', style: TextStyle(color: Colors.grey[500])),
              onTap: () => _showClearConfirm('历史记录'),
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: Colors.red[400]),
              title: const Text('清除缓存', style: TextStyle(color: Colors.white)),
              subtitle: Text('删除所有缓存数据', style: TextStyle(color: Colors.grey[500])),
              onTap: () => _showClearConfirm('缓存数据'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutCard() {
    return Card(
      color: const Color(0xFF2d2d2d),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.green),
                const SizedBox(width: 12),
                const Text(
                  '关于',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('版本', '1.0.5'),
            _buildInfoRow('构建日期', '2026-05-16'),
            const Divider(color: Colors.grey, height: 24),
            const Text(
              'XYBox 是 FongMi/TV 的 Flutter 复刻版本',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text(
              '支持配置源：饭太硬、肥猫、巧技等',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  void _showClearConfirm(String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2d2d2d),
        title: Text('清除$type', style: const TextStyle(color: Colors.white)),
        content: Text('确定要清除所有$type吗？此操作不可恢复。', style: const TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackbar('已清除$type');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _configUrlController.dispose();
    super.dispose();
  }
}
