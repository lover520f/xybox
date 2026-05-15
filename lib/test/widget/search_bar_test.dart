import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xybox/features/ui/widgets/search_bar_widget.dart';

void main() {
  group('SearchBarWidget Tests', () {
    testWidgets('should display search input field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should display search button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(),
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should call onSearch when search button tapped', (WidgetTester tester) async {
      String? searchedKeyword;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              onSearch: (keyword) => searchedKeyword = keyword,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'test keyword');
      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();

      expect(searchedKeyword, 'test keyword');
    });
  });
}
