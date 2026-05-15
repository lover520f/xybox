import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
abstract class LiveEvent extends Equatable { const LiveEvent(); @override List<Object?> get props => []; }
class LoadLiveChannels extends LiveEvent { const LoadLiveChannels(); }
abstract class LiveState extends Equatable { const LiveState(); @override List<Object?> get props => []; }
class LiveInitial extends LiveState { const LiveInitial(); }
class LiveLoading extends LiveState { const LiveLoading(); }
class LiveLoaded extends LiveState { const LiveLoaded(); }
class LiveError extends LiveState { const LiveError(); }
class LiveBloc extends Bloc<LiveEvent, LiveState> {
  LiveBloc() : super(const LiveInitial()) {
    on<LoadLiveChannels>((event, emit) async { emit(const LiveLoading()); try { emit(const LiveLoaded()); } catch (_) { emit(const LiveError()); } });
  }
}
