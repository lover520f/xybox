import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoggerUtil {
  static final List<Map<String, dynamic>> _logs = [];
  static const int _maxLogs = 500;

  static void _addLog(String level, String message, [String? stack]) {
    final log = {
      'time': DateTime.now().toString(),
      'level': level,
      'message': message,
      'stack': stack,
    };
    _logs.add(log);
    if (_logs.length > _maxLogs) _logs.removeAt(0);
    _persistLogs();
  }

  static Future<void> _persistLogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_logs', json.encode(_logs));
    } catch (e) {}
  }

  static void i(String message) {
    print('[INFO] $message');
    _addLog('INFO', message);
  }

  static void d(String message) {
    print('[DEBUG] $message');
    _addLog('DEBUG', message);
  }

  static void w(String message) {
    print('[WARNING] $message');
    _addLog('WARNING', message);
  }

  static void e(String message, [String? stack]) {
    print('[ERROR] $message');
    _addLog('ERROR', message, stack);
  }

  static List<Map<String, dynamic>> getLogs() => List.from(_logs);
  static void clear() { _logs.clear(); _persistLogs(); }
}
