import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/vod_bloc.dart';
import 'vod_detail_page.dart';

class VodListPage extends StatefulWidget {
  final String cateId;
  final String cateName;

  const VodListPage({
    super.key,
    required this.cateId,
    required this.cateName,
  });

  @override
  State<VodListPage> createState() => _VodListPageState();
}

class _VodListPageState extends State<VodListPage> {
  int _currentPage = 1;
  bool _isLoadingMore = false;
  List<dynamic> _vods = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (_isLoadingMore) return;
    
    setState(() => _isLoadingMore = true);
    context.read<VodBloc>().add(LoadCateVodEvent(
      cateId: widget.cateId,
      page: _currentPage,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        title: Text(widget.cateName),
        backgroundColor: const Color(0xFF2d2d2d),
        foregroundColor: Colors.white,
      ),
      body: BlocListener<VodBloc, VodState>(
        listener: (context, state) {
          if (state is VodCateVodLoaded) {
            setState(() {
              if (_currentPage == 1) {
                _vods = state.vods;
              } else {
                _vods.addAll(state.vods);
              }
              _isLoadingMore = false;
            });
          }
        },
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_vods.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _vods.length + 1,
      itemBuilder: (context, index) {
        if (index == _vods.length) {
          return _buildLoadMore();
        }
        return _buildVodCard(_vods[index]);
      },
    );
  }

  Widget _buildLoadMore() {
    return Center(
      child: _isLoadingMore
          ? const CircularProgressIndicator()
          : GestureDetector(
              onTap: () {
                _currentPage++;
                _loadData();
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2d2d2d),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '加载更多',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
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
