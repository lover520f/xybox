import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xybox/features/home/bloc/home_bloc.dart';
import 'package:xybox/features/vod/bloc/vod_bloc.dart';
import 'package:xybox/features/live/bloc/live_bloc.dart';
import 'package:xybox/features/home/pages/home_page.dart';

void main() {
  group('Navigation Integration Tests', () {
    testWidgets('should navigate between tabs', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<HomeBloc>(create: (_) => HomeBloc()),
              BlocProvider<VodBloc>(create: (_) => VodBloc()),
              BlocProvider<LiveBloc>(create: (_) => LiveBloc()),
            ],
            child: const HomePage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify initial tab (Home)
      expect(find.byType(HomePage), findsOneWidget);

      // Tap on VOD tab
      final vodTab = find.text('影视');
      await tester.tap(vodTab);
      await tester.pumpAndSettle();

      // Tap on Live tab
      final liveTab = find.text('直播');
      await tester.tap(liveTab);
      await tester.pumpAndSettle();

      // Tap on Settings tab
      final settingsTab = find.text('设置');
      await tester.tap(settingsTab);
      await tester.pumpAndSettle();
    });
  });
}
