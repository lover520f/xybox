import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../spider/spider_service.dart';

part 'vod_event.dart';
part 'vod_state.dart';

class VodBloc extends Bloc<VodEvent, VodState> {
  final SpiderService _spiderService = SpiderService();
  bool _isConfigLoaded = false;

  VodBloc() : super(VodInitial()) {
    on<LoadConfigEvent>(_onLoadConfig);
    on<LoadHomeEvent>(_onLoadHome);
    on<LoadCatesEvent>(_onLoadCates);
    on<LoadCateVodEvent>(_onLoadCateVod);
    on<SearchEvent>(_onSearch);
    on<LoadDetailEvent>(_onLoadDetail);
  }

  Future<void> _onLoadConfig(LoadConfigEvent event) async {
    emit(VodLoading());
    
    try {
      final success = await _spiderService.loadConfig(event.configUrl);
      if (success) {
        _isConfigLoaded = true;
        // 保存配置
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('vod_config_url', event.configUrl);
        emit(VodConfigLoaded(sites: _spiderService.getSites()));
      } else {
        emit(VodError(message: '加载配置失败'));
      }
    } catch (e) {
      emit(VodError(message: '加载配置失败：$e'));
    }
  }

  Future<void> _onLoadHome(LoadHomeEvent event) async {
    if (!_isConfigLoaded) {
      emit(VodError(message: '请先加载配置'));
      return;
    }

    try {
      final vods = await _spiderService.getHomeVod();
      emit(VodHomeLoaded(vods: vods));
    } catch (e) {
      emit(VodError(message: '加载首页失败：$e'));
    }
  }

  Future<void> _onLoadCates(LoadCatesEvent event) async {
    if (!_isConfigLoaded) return;

    try {
      final cates = await _spiderService.getCates();
      emit(VodCatesLoaded(cates: cates));
    } catch (e) {
      // 忽略错误
    }
  }

  Future<void> _onLoadCateVod(LoadCateVodEvent event) async {
    if (!_isConfigLoaded) return;

    emit(VodLoading());
    try {
      final vods = await _spiderService.getCateVod(event.cateId, event.page);
      emit(VodCateVodLoaded(vods: vods));
    } catch (e) {
      emit(VodError(message: '加载分类失败：$e'));
    }
  }

  Future<void> _onSearch(SearchEvent event) async {
    if (!_isConfigLoaded) return;

    emit(VodLoading());
    try {
      final vods = await _spiderService.search(event.keyword);
      emit(VodSearchLoaded(vods: vods));
    } catch (e) {
      emit(VodError(message: '搜索失败：$e'));
    }
  }

  Future<void> _onLoadDetail(LoadDetailEvent event) async {
    if (!_isConfigLoaded) return;

    try {
      final detail = await _spiderService.getVodDetail(event.vodId);
      if (detail != null) {
        emit(VodDetailLoaded(vod: detail));
      } else {
        emit(VodError(message: '获取详情失败'));
      }
    } catch (e) {
      emit(VodError(message: '获取详情失败：$e'));
    }
  }
}
