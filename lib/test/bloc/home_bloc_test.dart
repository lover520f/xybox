import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:xybox/features/home/bloc/home_bloc.dart';

void main() {
  group('HomeBloc Tests', () {
    late HomeBloc bloc;

    setUp(() {
      bloc = HomeBloc();
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state should be HomeInitial', () {
      expect(bloc.state, equals(HomeInitial()));
    });

    blocTest<HomeBloc, HomeState>(
      'should emit HomeLoading and HomeSuccess when LoadHomeConfig is added',
      build: () => HomeBloc(),
      act: (bloc) => bloc.add(const LoadHomeConfig()),
      expect: () => [
        isA<HomeLoading>(),
        isA<HomeSuccess>(),
      ],
    );
  });
}
