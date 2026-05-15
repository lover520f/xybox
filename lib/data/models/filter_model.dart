import 'package:freezed_annotation/freezed_annotation.dart';
part 'filter.freezed.dart';
part 'filter.g.dart';
@freezed
class Filter with _$Filter {
  const factory Filter({required String key, required String name, String? value, bool? init, bool? selected}) = _Filter;
  factory Filter.fromJson(Map<String, dynamic> json) => _$FilterFromJson(json);
}
