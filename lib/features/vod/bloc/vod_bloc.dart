import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
abstract class VodEvent extends Equatable { const VodEvent(); @override List<Object?> get props => []; }
class LoadVodClasses extends VodEvent { const LoadVodClasses(); }
class SearchVod extends VodEvent { final String keyword; const SearchVod({required this.keyword}); @override List<Object?> get props => [keyword]; }
abstract class VodState extends Equatable { const VodState(); @override List<Object?> get props => []; }
class VodInitial extends VodState { const VodInitial(); }
class VodLoading extends VodState { const VodLoading(); }
class VodLoaded extends VodState { const VodLoaded(); }
class VodError extends VodState { const VodError(); }
class VodBloc extends Bloc<VodEvent, VodState> {
  VodBloc() : super(const VodInitial()) {
    on<LoadVodClasses>((event, emit) async { emit(const VodLoading()); try { emit(const VodLoaded()); } catch (_) { emit(const VodError()); } });
    on<SearchVod>((event, emit) async { emit(const VodLoading()); try { emit(const VodLoaded()); } catch (_) { emit(const VodError()); } });
  }
}
