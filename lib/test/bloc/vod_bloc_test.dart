import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:xybox/features/vod/bloc/vod_bloc.dart';

void main() {
  group('VodBloc Tests', () {
    late VodBloc bloc;

    setUp(() {
      bloc = VodBloc();
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state should be VodInitial', () {
      expect(bloc.state, equals(VodInitial()));
    });

    blocTest<VodBloc, VodState>(
      'should emit VodLoading when LoadVodClasses is added',
      build: () => VodBloc(),
      act: (bloc) => bloc.add(const LoadVodClasses()),
      expect: () => [isA<VodLoading>()],
    );
  });
}
