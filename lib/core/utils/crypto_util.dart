import 'dart:convert';
import 'package:crypto/crypto.dart';
class CryptoUtil {
  static String md5(String input) => md5.convert(utf8.encode(input)).toString();
  static String sha1(String input) => sha1.convert(utf8.encode(input)).toString();
  static String sha256(String input) => sha256.convert(utf8.encode(input)).toString();
  static String base64Encode(String input) => base64.encode(utf8.encode(input));
  static String base64Decode(String input) => utf8.decode(base64.decode(input));
}
