import 'package:freezed_annotation/freezed_annotation.dart';
part 'live.freezed.dart';
part 'live.g.dart';
@freezed
class LiveConfig with _$LiveConfig {
  const factory LiveConfig({String? spider, @Default([]) List<Live> lives}) = _LiveConfig;
  factory LiveConfig.fromJson(Map<String, dynamic> json) => _$LiveConfigFromJson(json);
}
