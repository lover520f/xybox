import 'package:flutter/material.dart';
import 'vod_detail_page.dart';

class VodPage extends StatefulWidget {
  const VodPage({super.key});

  @override
  State<VodPage> createState() => _VodPageState();
}

class _VodPageState extends State<VodPage> {
  final List<Map<String, dynamic>> _categories = [
    {'id': '1', 'name': '电影', 'icon': Icons.movie},
    {'id': '2', 'name': '电视剧', 'icon': Icons.tv},
    {'id': '3', 'name': '综艺', 'icon': Icons.celebration},
    {'id': '4', 'name': '动漫', 'icon': Icons.animation},
    {'id': '5', 'name': '纪录片', 'icon': Icons.document_scanner},
  ];

  bool _isLoading = false;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);
    // 模拟加载延迟
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1a1a1a),
      child: Column(
        children: [
          // 搜索栏
          _buildSearchBar(),
          // 分类网格
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildCategoryGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF2d2d2d),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '搜索影片...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFF1a1a1a),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onSubmitted: (value) {
                debugPrint('搜索：$value');
                _showSearchResult(value);
              },
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => _showSearchResult(''),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(12),
            ),
            child: const Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return _buildCategoryCard(category);
      },
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () {
        setState(() => _selectedCategory = category['id']);
        _navigateToVodList(category);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2d2d2d),
          borderRadius: BorderRadius.circular(12),
          border: _selectedCategory == category['id']
              ? Border.all(color: Colors.blueAccent, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category['icon'] as IconData,
              size: 48,
              color: _selectedCategory == category['id']
                  ? Colors.blueAccent
                  : Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              category['name'] as String,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _selectedCategory == category['id']
                    ? Colors.blueAccent
                    : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToVodList(Map<String, dynamic> category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VodListPage(
          categoryId: category['id'] as String,
          categoryName: category['name'] as String,
        ),
      ),
    );
  }

  void _showSearchResult(String keyword) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(keyword: keyword),
      ),
    );
  }
}

// 影片列表页面
class VodListPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const VodListPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<VodListPage> createState() => _VodListPageState();
}

class _VodListPageState extends State<VodListPage> {
  final List<Map<String, dynamic>> _vodList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadVodList();
  }

  Future<void> _loadVodList() async {
    setState(() => _isLoading = true);
    
    // 模拟数据
    await Future.delayed(const Duration(milliseconds: 800));
    final mockData = List.generate(20, (index) => {
      'id': '${widget.categoryId}_${index}',
      'name': '${widget.categoryName} ${index + 1}',
      'pic': null,
      'year': '2024',
      'area': '中国',
      'remark': '更新至${index + 10}集',
    });
    
    setState(() {
      _vodList.addAll(mockData);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: const Color(0xFF2d2d2d),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildVodGrid(),
    );
  }

  Widget _buildVodGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: _vodList.length,
      itemBuilder: (context, index) {
        return _buildVodCard(_vodList[index]);
      },
    );
  }

  Widget _buildVodCard(Map<String, dynamic> vod) {
    return GestureDetector(
      onTap: () => _navigateToDetail(vod),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2d2d2d),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 封面图占位
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1a1a1a),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                ),
                child: Center(
                  child: Icon(Icons.movie, size: 48, color: Colors.grey[600]),
                ),
              ),
            ),
            // 信息
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vod['name'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    vod['remark'] as String,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetail(Map<String, dynamic> vod) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VodDetailPage(vod: vod),
      ),
    );
  }
}

// 搜索结果显示页面
class SearchResultsPage extends StatelessWidget {
  final String keyword;

  const SearchResultsPage({super.key, required this.keyword});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        title: Text(keyword.isEmpty ? '全部影片' : '搜索：$keyword'),
        backgroundColor: const Color(0xFF2d2d2d),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey[600]),
            const SizedBox(height: 16),
            Text(
              keyword.isEmpty ? '暂无影片' : '未找到相关结果',
              style: TextStyle(fontSize: 18, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
