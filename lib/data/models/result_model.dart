import 'package:freezed_annotation/freezed_annotation.dart';
part 'result.freezed.dart';
part 'result.g.dart';
@freezed
class Result<T> with _$Result<T> {
  const factory Result({required bool success, T? data, String? error}) = _Result;
  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
}
