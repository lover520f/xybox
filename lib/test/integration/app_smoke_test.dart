import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xybox/main.dart';

void main() {
  group('App Smoke Tests', () {
    testWidgets('app should start without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(const XyBoxApp());
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('app should display XYBox title', (WidgetTester tester) async {
      await tester.pumpWidget(const XyBoxApp());
      await tester.pumpAndSettle();

      expect(find.text('XYBox'), findsOneWidget);
    });

    testWidgets('app should have HomePage as initial route', (WidgetTester tester) async {
      await tester.pumpWidget(const XyBoxApp());
      await tester.pumpAndSettle();

      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });
  });
}
