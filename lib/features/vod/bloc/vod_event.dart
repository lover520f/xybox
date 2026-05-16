part of 'vod_bloc.dart';

abstract class VodEvent extends Equatable {
  const VodEvent();
  
  @override
  List<Object?> get props => [];
}

class LoadConfigEvent extends VodEvent {
  final String configUrl;
  const LoadConfigEvent({required this.configUrl});
  
  @override
  List<Object?> get props => [configUrl];
}

class LoadHomeEvent extends VodEvent {
  const LoadHomeEvent();
}

class LoadCatesEvent extends VodEvent {
  const LoadCatesEvent();
}

class LoadCateVodEvent extends VodEvent {
  final String cateId;
  final int page;
  const LoadCateVodEvent({required this.cateId, this.page = 1});
  
  @override
  List<Object?> get props => [cateId, page];
}

class SearchEvent extends VodEvent {
  final String keyword;
  const SearchEvent({required this.keyword});
  
  @override
  List<Object?> get props => [keyword];
}

class LoadDetailEvent extends VodEvent {
  final String vodId;
  const LoadDetailEvent({required this.vodId});
  
  @override
  List<Object?> get props => [vodId];
}
