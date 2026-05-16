part of 'vod_bloc.dart';

abstract class VodState extends Equatable {
  const VodState();
  
  @override
  List<Object?> get props => [];
}

class VodInitial extends VodState {
  const VodInitial();
}

class VodLoading extends VodState {
  const VodLoading();
}

class VodConfigLoaded extends VodState {
  final List<dynamic> sites;
  const VodConfigLoaded({required this.sites});
  
  @override
  List<Object?> get props => [sites];
}

class VodHomeLoaded extends VodState {
  final List<dynamic> vods;
  const VodHomeLoaded({required this.vods});
  
  @override
  List<Object?> get props => [vods];
}

class VodCatesLoaded extends VodState {
  final List<dynamic> cates;
  const VodCatesLoaded({required this.cates});
  
  @override
  List<Object?> get props => [cates];
}

class VodCateVodLoaded extends VodState {
  final List<dynamic> vods;
  const VodCateVodLoaded({required this.vods});
  
  @override
  List<Object?> get props => [vods];
}

class VodSearchLoaded extends VodState {
  final List<dynamic> vods;
  const VodSearchLoaded({required this.vods});
  
  @override
  List<Object?> get props => [vods];
}

class VodDetailLoaded extends VodState {
  final dynamic vod;
  const VodDetailLoaded({required this.vod});
  
  @override
  List<Object?> get props => [vod];
}

class VodError extends VodState {
  final String message;
  const VodError({required this.message});
  
  @override
  List<Object?> get props => [message];
}
