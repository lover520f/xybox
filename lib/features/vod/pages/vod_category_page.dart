import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/vod_bloc.dart';
import 'vod_list_page.dart';

class VodCategoryPage extends StatefulWidget {
  const VodCategoryPage({super.key});

  @override
  State<VodCategoryPage> createState() => _VodCategoryPageState();
}

class _VodCategoryPageState extends State<VodCategoryPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    context.read<VodBloc>().add(const LoadCatesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1a1a1a),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildCategoryList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF2d2d2d),
      child: Row(
        children: [
          Icon(Icons.category, color: Colors.blueAccent),
          const SizedBox(width: 12),
          const Text(
            '分类导航',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return BlocBuilder<VodBloc, VodState>(
      builder: (context, state) {
        if (state is VodLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is VodCatesLoaded) {
          _isLoading = false;
          return _buildGrid(state.cates);
        }
        if (state is VodError) {
          return Center(child: Text('加载失败：${state.message}'));
        }
        return const Center(child: Text('暂无分类'));
      },
    );
  }

  Widget _buildGrid(List<dynamic> cates) {
    if (cates.isEmpty) {
      return const Center(child: Text('暂无分类数据'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: cates.length,
      itemBuilder: (context, index) {
        final cate = cates[index];
        return _buildCategoryCard(cate);
      },
    );
  }

  Widget _buildCategoryCard(dynamic cate) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VodListPage(
              cateId: cate['type_id']?.toString() ?? cate['id']?.toString() ?? '',
              cateName: cate['type_name']?.toString() ?? cate['name']?.toString() ?? '未知',
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2d2d2d),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getCategoryIcon(cate['type_name']?.toString() ?? ''),
                size: 32,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 8),
              Text(
                cate['type_name']?.toString() ?? cate['name']?.toString() ?? '未知',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String name) {
    if (name.contains('电影')) return Icons.movie;
    if (name.contains('电视') || name.contains('剧')) return Icons.tv;
    if (name.contains('动漫')) return Icons.animation;
    if (name.contains('综艺')) return Icons.stadium;
    if (name.contains('纪录')) return Icons.documentary;
    if (name.contains('音乐')) return Icons.music_note;
    return Icons.video_library;
  }
}
