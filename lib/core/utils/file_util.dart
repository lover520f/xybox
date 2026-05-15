import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
class FileUtil {
  static Future<String> getCachePath([String? subDir]) async {
    final dir = await getTemporaryDirectory();
    return subDir != null ? path.join(dir.path, subDir) : dir.path;
  }
  static Future<String> getAppPath([String? subDir]) async {
    final dir = await getApplicationDocumentsDirectory();
    return subDir != null ? path.join(dir.path, subDir) : dir.path;
  }
}
