import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:xybox/features/live/bloc/live_bloc.dart';

void main() {
  group('LiveBloc Tests', () {
    late LiveBloc bloc;

    setUp(() {
      bloc = LiveBloc();
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state should be LiveInitial', () {
      expect(bloc.state, equals(LiveInitial()));
    });

    blocTest<LiveBloc, LiveState>(
      'should emit LiveLoading when LoadLiveChannels is added',
      build: () => LiveBloc(),
      act: (bloc) => bloc.add(const LoadLiveChannels()),
      expect: () => [isA<LiveLoading>()],
    );
  });
}
