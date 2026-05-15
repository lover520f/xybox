import 'dart:convert';
class JsonUtil {
  static T? parse<T>(String? json, T Function(Map<String, dynamic>) fromJson) {
    if (json == null || json.isEmpty) return null;
    try {
      final data = jsonDecode(json);
      if (data is Map<String, dynamic>) return fromJson(data);
    } catch (e) {}
    return null;
  }
  static String stringify(Object? obj) => obj != null ? jsonEncode(obj) : '';
}
