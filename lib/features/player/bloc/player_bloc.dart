import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
abstract class PlayerEvent extends Equatable { const PlayerEvent(); @override List<Object?> get props => []; }
class LoadPlayer extends PlayerEvent { final String url; const LoadPlayer({required this.url}); @override List<Object?> get props => [url]; }
class ToggleDanmaku extends PlayerEvent { const ToggleDanmaku(); }
abstract class PlayerState extends Equatable { const PlayerState(); @override List<Object?> get props => []; }
class PlayerInitial extends PlayerState { const PlayerInitial(); }
class PlayerLoading extends PlayerState { const PlayerLoading(); }
class PlayerLoaded extends PlayerState { const PlayerLoaded(); }
class PlayerError extends PlayerState { const PlayerError(); }
class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  PlayerBloc() : super(const PlayerInitial()) {
    on<LoadPlayer>((event, emit) async { emit(const PlayerLoading()); try { emit(const PlayerLoaded()); } catch (_) { emit(const PlayerError()); } });
    on<ToggleDanmaku>((event, emit) async { emit(const PlayerLoading()); emit(const PlayerLoaded()); });
  }
}
