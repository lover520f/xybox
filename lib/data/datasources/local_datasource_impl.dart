import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/interfaces/interfaces.dart';
class LocalDataSourceImpl implements ILocalDataSource {
  late SharedPreferences _prefs;
  @override
  Future<void> initialize() async { _prefs = await SharedPreferences.getInstance(); }
  @override
  Future<T?> get<T>(String key) async {
    final value = _prefs.get(key);
    if (value == null) return null;
    if (value is String && T != String) return jsonDecode(value) as T?;
    return value as T?;
  }
  @override
  Future<void> set<T>(String key, T value) async {
    if (value is String) await _prefs.setString(key, value);
    else if (value is int) await _prefs.setInt(key, value);
    else if (value is bool) await _prefs.setBool(key, value);
    else if (value is double) await _prefs.setDouble(key, value);
    else await _prefs.setString(key, jsonEncode(value));
  }
  @override
  Future<void> delete(String key) async => await _prefs.remove(key);
  @override
  Future<bool> contains(String key) async => _prefs.containsKey(key);
  @override
  Future<void> clear() async => await _prefs.clear();
  @override
  Future<void> dispose() async {}
}
