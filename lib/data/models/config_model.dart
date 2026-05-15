import 'package:freezed_annotation/freezed_annotation.dart';
part 'config.freezed.dart';
part 'config.g.dart';
@freezed
class VodConfig with _$VodConfig {
  const factory VodConfig({String? spider, String? wallpaper, String? logo, @Default([]) List<Site> sites, @Default([]) List<Parse> parses, @Default([]) List<Live> lives}) = _VodConfig;
  factory VodConfig.fromJson(Map<String, dynamic> json) => _$VodConfigFromJson(json);
}
@freezed
class Site with _$Site {
  const factory Site({required String key, required String name, @Default(3) int type, String? api, String? ext, String? jar, @Default(1) int searchable, @Default(1) int changeable}) = _Site;
  factory Site.fromJson(Map<String, dynamic> json) => _$SiteFromJson(json);
}
@freezed
class Parse with _$Parse {
  const factory Parse({String? name, @Default(0) int type, String? url}) = _Parse;
  factory Parse.fromJson(Map<String, dynamic> json) => _$ParseFromJson(json);
}
@freezed
class Live with _$Live {
  const factory Live({String? name, String? url, String? api, String? ext, @Default([]) List<Group> groups}) = _Live;
  factory Live.fromJson(Map<String, dynamic> json) => _$LiveFromJson(json);
}
@freezed
class Group with _$Group {
  const factory Group({String? name, @Default([]) List<Channel> channel}) = _Group;
  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}
@freezed
class Channel with _$Channel {
  const factory Channel({String? name, @Default([]) List<String> urls, String? epg}) = _Channel;
  factory Channel.fromJson(Map<String, dynamic> json) => _$ChannelFromJson(json);
}
