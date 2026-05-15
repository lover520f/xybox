import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:xybox/features/player/bloc/player_bloc.dart';

void main() {
  group('PlayerBloc Tests', () {
    late PlayerBloc bloc;

    setUp(() {
      bloc = PlayerBloc();
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state should be PlayerInitial', () {
      expect(bloc.state, equals(PlayerInitial()));
    });

    blocTest<PlayerBloc, PlayerState>(
      'should emit PlayerLoading when LoadPlayer is added',
      build: () => PlayerBloc(),
      act: (bloc) => bloc.add(LoadPlayer(url: 'https://example.com/video.mp4')),
      expect: () => [isA<PlayerLoading>()],
    );
  });
}
