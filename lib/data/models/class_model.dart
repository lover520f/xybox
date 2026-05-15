import 'package:freezed_annotation/freezed_annotation.dart';
part 'class.freezed.dart';
part 'class.g.dart';
@freezed
class Class with _$Class {
  const factory Class({required String typeId, required String typeName, int? ratio}) = _Class;
  factory Class.fromJson(Map<String, dynamic> json) => _$ClassFromJson(json);
}
