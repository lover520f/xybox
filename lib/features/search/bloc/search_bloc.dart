import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
abstract class SearchEvent extends Equatable { const SearchEvent(); @override List<Object?> get props => []; }
class Search extends SearchEvent { final String keyword; final String sourceKey; const Search({required this.keyword, required this.sourceKey}); @override List<Object?> get props => [keyword, sourceKey]; }
class ClearSearch extends SearchEvent { const ClearSearch(); }
abstract class SearchState extends Equatable { const SearchState(); @override List<Object?> get props => []; }
class SearchInitial extends SearchState { const SearchInitial(); }
class SearchLoading extends SearchState { const SearchLoading(); }
class SearchLoaded extends SearchState { const SearchLoaded(); }
class SearchError extends SearchState { const SearchError(); }
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchInitial()) {
    on<Search>((event, emit) async { emit(const SearchLoading()); try { emit(const SearchLoaded()); } catch (_) { emit(const SearchError()); } });
    on<ClearSearch>((event, emit) async { emit(const SearchLoading()); emit(const SearchInitial()); });
  }
}
