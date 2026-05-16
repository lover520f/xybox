import 'package:flutter/material.dart';
import '../service/dlna_service.dart';

class DlnaCastPage extends StatefulWidget {
  final String videoUrl;
  final String title;

  const DlnaCastPage({super.key, required this.videoUrl, required this.title});

  @override
  State<DlnaCastPage> createState() => _DlnaCastPageState();
}

class _DlnaCastPageState extends State<DlnaCastPage> {
  final DlnaService _service = DlnaService();
  List<DlnaDevice> _devices = [];
  bool _isSearching = true;
  DlnaDevice? _selectedDevice;

  @override
  void initState() {
    super.initState();
    _searchDevices();
  }

  void _searchDevices() {
    setState(() => _isSearching = true);
    _service.searchDevices();
    
    _service.deviceStream.listen((devices) {
      if (mounted) {
        setState(() {
          _devices = devices;
          _isSearching = false;
        });
      }
    });
  }

  Future<void> _castToDevice(DlnaDevice device) async {
    setState(() {
      _selectedDevice = device;
      _isSearching = true;
    });

    try {
      final success = await _service.castVideo(device, widget.videoUrl, widget.title);
      
      if (mounted) {
        setState(() => _isSearching = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? '投屏成功' : '投屏失败'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
        
        if (success) Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSearching = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('投屏失败'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        title: const Text('DLNA 投屏'),
        backgroundColor: const Color(0xFF2d2d2d),
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: _isSearching ? null : _searchDevices),
        ],
      ),
      body: Column(
        children: [_buildInfoCard(), Expanded(child: _buildDeviceList())],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF2d2d2d), borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(Icons.cast, color: Colors.blueAccent), const SizedBox(width: 12), const Text('投屏到设备', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 12),
          Text(widget.title, style: const TextStyle(color: Colors.grey, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildDeviceList() {
    if (_isSearching && _devices.isEmpty) {
      return const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircularProgressIndicator(), SizedBox(height: 16), Text('正在搜索设备...', style: TextStyle(color: Colors.grey))]));
    }

    if (_devices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cast, size: 64, color: Colors.grey[600]),
            const SizedBox(height: 16),
            const Text('未找到 DLNA 设备', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text('请确保手机和设备在同一 WiFi 网络', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            const SizedBox(height: 24),
            ElevatedButton.icon(onPressed: _searchDevices, icon: const Icon(Icons.refresh), label: const Text('重新搜索'), style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _devices.length,
      itemBuilder: (context, index) => _buildDeviceCard(_devices[index]),
    );
  }

  Widget _buildDeviceCard(DlnaDevice device) {
    final isSelected = _selectedDevice?.udn == device.udn;

    return Card(
      color: const Color(0xFF2d2d2d),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(_isSearching && isSelected ? Icons.cast_connected : Icons.cast, color: isSelected ? Colors.blueAccent : Colors.white, size: 32),
        title: Text(device.friendlyName, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 4),
          Text(device.manufacturer.isNotEmpty ? device.manufacturer : 'DLNA 设备', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          if (device.modelName.isNotEmpty) Text(device.modelName, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ]),
        trailing: _isSearching && isSelected ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        onTap: () => _castToDevice(device),
      ),
    );
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}
