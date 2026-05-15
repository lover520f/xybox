import 'package:freezed_annotation/freezed_annotation.dart';
part 'player.freezed.dart';
part 'player.g.dart';
@freezed
class PlayerResult with _$PlayerResult {
  const factory PlayerResult({required String url, @Default(0) int parse, String? playUrl, @Default({}) Map<String, String> header, String? flag}) = _PlayerResult;
  factory PlayerResult.fromJson(Map<String, dynamic> json) => _$PlayerResultFromJson(json);
}
@freezed
class Danmaku with _$Danmaku {
  const factory Danmaku({String? url, String? name}) = _Danmaku;
  factory Danmaku.fromJson(Map<String, dynamic> json) => _$DanmakuFromJson(json);
}
@freezed
class Sub with _$Sub {
  const factory Sub({String? url, String? name, String? lang}) = _Sub;
  factory Sub.fromJson(Map<String, dynamic> json) => _$SubFromJson(json);
}
