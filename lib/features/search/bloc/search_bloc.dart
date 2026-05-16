import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../spider/spider_service.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SpiderService _spiderService = SpiderService();

  SearchBloc() : super(SearchInitial()) {
    on<SearchEvent>(_onSearch);
  }

  Future<void> _onSearch(SearchEvent event) async {
    if (event.keyword.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    try {
      final results = await _spiderService.search(event.keyword);
      if (results.isEmpty) {
        emit(SearchEmpty(keyword: event.keyword));
      } else {
        emit(SearchLoaded(results: results));
      }
    } catch (e) {
      emit(SearchError(message: '搜索失败：$e'));
    }
  }
}
