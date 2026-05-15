import 'package:freezed_annotation/freezed_annotation.dart';
part 'network.freezed.dart';
part 'network.g.dart';
@freezed
class Doh with _$Doh {
  const factory Doh({String? name, String? url, @Default([]) List<String> ips}) = _Doh;
  factory Doh.fromJson(Map<String, dynamic> json) => _$DohFromJson(json);
}
@freezed
class Proxy with _$Proxy {
  const factory Proxy({String? name, @Default([]) List<String> hosts, @Default([]) List<String> urls}) = _Proxy;
  factory Proxy.fromJson(Map<String, dynamic> json) => _$ProxyFromJson(json);
}
@freezed
class Rule with _$Rule {
  const factory Rule({String? name, @Default([]) List<String> hosts, @Default([]) List<String> regex}) = _Rule;
  factory Rule.fromJson(Map<String, dynamic> json) => _$RuleFromJson(json);
}
