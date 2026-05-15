import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:xybox/features/search/bloc/search_bloc.dart';

void main() {
  group('SearchBloc Tests', () {
    late SearchBloc bloc;

    setUp(() {
      bloc = SearchBloc();
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state should be SearchInitial', () {
      expect(bloc.state, equals(SearchInitial()));
    });

    blocTest<SearchBloc, SearchState>(
      'should emit SearchLoading when Search is added',
      build: () => SearchBloc(),
      act: (bloc) => bloc.add(const Search(keyword: 'test', sourceKey: 'source1')),
      expect: () => [isA<SearchLoading>()],
    );
  });
}
