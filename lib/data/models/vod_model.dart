import 'package:freezed_annotation/freezed_annotation.dart';
part 'vod.freezed.dart';
part 'vod.g.dart';
@freezed
class Vod with _$Vod {
  const factory Vod({required String id, required String name, String? pic, String? year, String? area, String? director, String? actor, String? remark, String? typeId, String? typeName, double? score}) = _Vod;
  factory Vod.fromJson(Map<String, dynamic> json) => _$VodFromJson(json);
}
