import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable { const HomeEvent(); @override List<Object?> get props => []; }
class LoadHomeConfig extends HomeEvent { const LoadHomeConfig(); }

abstract class HomeState extends Equatable { const HomeState(); @override List<Object?> get props => []; }
class HomeInitial extends HomeState { const HomeInitial(); }
class HomeLoading extends HomeState { const HomeLoading(); }
class HomeSuccess extends HomeState { const HomeSuccess(); }
class HomeError extends HomeState { const HomeError(); }

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitial()) {
    on<LoadHomeConfig>((event, emit) async {
      emit(const HomeLoading());
      try { emit(const HomeSuccess()); } catch (_) { emit(const HomeError()); }
    });
  }
}
