import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'router/router.dart';
import 'features/home/bloc/home_bloc.dart';
import 'features/vod/bloc/vod_bloc.dart';
import 'features/live/bloc/live_bloc.dart';
import 'features/search/bloc/search_bloc.dart';
import 'features/player/bloc/player_bloc.dart';
import 'data/repositories/vod_repository_impl.dart';
import 'data/repositories/live_repository_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const XyBoxApp());
}

class XyBoxApp extends StatelessWidget {
  const XyBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(create: (_) => HomeBloc()),
        BlocProvider<VodBloc>(create: (_) => VodBloc()),
        BlocProvider<LiveBloc>(create: (_) => LiveBloc()),
        BlocProvider<SearchBloc>(create: (_) => SearchBloc()),
        BlocProvider<PlayerBloc>(create: (_) => PlayerBloc()),
      ],
      child: MaterialApp.router(
        title: 'XYBox',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFF1a1a1a),
        ),
        routerConfig: router,
      ),
    );
  }
}
