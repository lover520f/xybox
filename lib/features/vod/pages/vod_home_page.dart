import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/vod_bloc.dart';
import 'vod_list_page.dart';
import 'vod_detail_page.dart';
import 'player_page.dart';
import '../../../spider/spider_service.dart';

class VodHomePage extends StatefulWidget {
  const VodHomePage({super.key});

  @override
  State<VodHomePage> createState() => _VodHomePageState();
}

class _VodHomePageState extends State<VodHomePage> {
  bool _hasConfig = false;

  @override
  void initState() {
    super.initState();
    _checkConfig();
  }

  Future<void> _checkConfig() async {
    // 检查是否已加载配置
    final sites = SpiderService().getSites();
    if (sites.isNotEmpty) {
      setState(() => _hasConfig = true);
      context.read<VodBloc>().add(const LoadHomeEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1a1a1a),
      child: _hasConfig ? _buildContent() : _buildNoConfig(),
    );
  }

  Widget _buildNoConfig() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings_input_component, size: 64, color: Colors.grey[600]),
          const SizedBox(height: 16),
          Text(
            '请先配置数据源',
            style: TextStyle(color: Colors.grey[500], fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            '设置 → 配置源管理 → 添加配置源',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: 跳转到设置页面
            },
            icon: const Icon(Icons.settings),
            label: const Text('去设置'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<VodBloc, VodState>(
      builder: (context, state) {
        if (state is VodLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is VodError) {
          return Center(child: Text('加载失败：${state.message}'));
        }
        if (state is VodHomeLoaded) {
          return _buildVodList(state.vods);
        }
        return const Center(child: Text('暂无数据'));
      },
    );
  }

  Widget _buildVodList(List<dynamic> vods) {
    if (vods.isEmpty) {
      return const Center(child: Text('暂无内容'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: vods.length,
      itemBuilder: (context, index) {
        final vod = vods[index];
        return _buildVodCard(vod);
      },
    );
  }

  Widget _buildVodCard(dynamic vod) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VodDetailPage(vod: vod),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2d2d2d),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: vod['pic'] != null && vod['pic'].toString().isNotEmpty
                    ? Image.network(
                        vod['pic'],
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.movie, size: 48, color: Colors.grey),
                      )
                    : const Icon(Icons.movie, size: 48, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            vod['name']?.toString() ?? '未知',
            style: const TextStyle(color: Colors.white, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (vod['remark'] != null && vod['remark'].toString().isNotEmpty)
            Text(
              vod['remark'],
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}
