part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  final List<dynamic> results;
  const SearchLoaded({required this.results});
  
  @override
  List<Object?> get props => [results];
}

class SearchEmpty extends SearchState {
  final String keyword;
  const SearchEmpty({required this.keyword});
  
  @override
  List<Object?> get props => [keyword];
}

class SearchError extends SearchState {
  final String message;
  const SearchError({required this.message});
  
  @override
  List<Object?> get props => [message];
}
