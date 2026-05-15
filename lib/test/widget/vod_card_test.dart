import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xybox/features/ui/widgets/vod_card.dart';
import 'package:xybox/data/models/vod_model.dart';

void main() {
  group('VodCard Widget Tests', () {
    final testVod = const Vod(id: '1', name: 'Test VOD', pic: 'https://example.com/pic.jpg');

    testWidgets('should display vod name', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VodCard(vod: testVod),
          ),
        ),
      );

      expect(find.text('Test VOD'), findsOneWidget);
    });

    testWidgets('should display vod image', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VodCard(vod: testVod),
          ),
        ),
      );

      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VodCard(
              vod: testVod,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      expect(tapped, true);
    });
  });
}
