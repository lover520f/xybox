abstract class ISpider {
  Future<void> init();
  Future<dynamic> homeContent();
  Future<dynamic> categoryContent({String? typeId, String? page, String? filter});
  Future<dynamic> detailContent(String id);
  Future<dynamic> searchContent(String key, {bool quick = false});
  Future<dynamic> playerContent(String flag, String url, {List<String>? vipFlags});
  void destroy();
}
