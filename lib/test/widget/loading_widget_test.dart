import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xybox/features/ui/widgets/loading_widget.dart';

void main() {
  group('LoadingWidget Tests', () {
    testWidgets('should display CircularProgressIndicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: const Scaffold(
            body: LoadingWidget(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display loading text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: const Scaffold(
            body: LoadingWidget(),
          ),
        ),
      );

      expect(find.text('加载中...'), findsOneWidget);
    });
  });
}
