import 'dart:developer';
class LoggerUtil {
  static void i(String message, {String tag = 'XYBox'}) => log('[$tag] [I] $message');
  static void d(String message, {String tag = 'XYBox'}) => log('[$tag] [D] $message');
  static void e(String message, {Object? error, String tag = 'XYBox'}) => log('[$tag] [E] $message${error != null ? ": $error" : ""}');
  static void w(String message, {String tag = 'XYBox'}) => log('[$tag] [W] $message');
}
