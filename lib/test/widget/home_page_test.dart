import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xybox/features/home/bloc/home_bloc.dart';
import 'package:xybox/features/home/pages/home_page.dart';

void main() {
  group('HomePage Widget Tests', () {
    testWidgets('should display app title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<HomeBloc>(
            create: (_) => HomeBloc(),
            child: const HomePage(),
          ),
        ),
      );

      expect(find.text('XYBox'), findsOneWidget);
    });

    testWidgets('should display bottom navigation bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<HomeBloc>(
            create: (_) => HomeBloc(),
            child: const HomePage(),
          ),
        ),
      );

      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('should have 5 navigation items', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<HomeBloc>(
            create: (_) => HomeBloc(),
            child: const HomePage(),
          ),
        ),
      );

      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.movie), findsOneWidget);
      expect(find.byIcon(Icons.live_tv), findsOneWidget);
      expect(find.byIcon(Icons.history), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });
  });
}
