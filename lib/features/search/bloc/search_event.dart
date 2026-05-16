part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
  
  @override
  List<Object?> get props => [];
}

class SearchEvent extends SearchEvent {
  final String keyword;
  const SearchEvent({required this.keyword});
  
  @override
  List<Object?> get props => [keyword];
}
