import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scavengerhutn/main.dart';
import 'package:scavengerhutn/article_page.dart';

void main() {
  testWidgets('MapImagePage displays map image and button', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Verify the map image is displayed.
    expect(
      find.byWidgetPredicate((widget) {
        if (widget is Image && widget.image is AssetImage) {
          return (widget.image as AssetImage).assetName == 'images/map_image.png';
        }
        return false;
      }),
      findsOneWidget,
    );

    // Verify the button image is displayed.
    expect(
      find.byWidgetPredicate((widget) {
        if (widget is Image && widget.image is AssetImage) {
          return (widget.image as AssetImage).assetName == 'images/button_image.png';
        }
        return false;
      }),
      findsOneWidget,
    );
  });

  testWidgets('Navigation to ArticlePage on button tap', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Tap the button.
    await tester.tap(find.byWidgetPredicate((widget) => widget is GestureDetector));
    await tester.pumpAndSettle();

    // Verify ArticlePage is displayed.
    expect(find.text('Unlock the Next Level'), findsOneWidget);
  });

  testWidgets('ArticlePage displays content and unlock elements', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ArticlePage(
        articleImage: 'images/article1.png',
        articleText: 'This is the first article.',
        correctCode: '1234',
      ),
    ));

    // Check the article image and text.
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('This is the first article.'), findsOneWidget);

    // Check for unlock field and button.
    expect(find.byType(TextField), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Unlock'), findsOneWidget);
  });

  testWidgets('MapImagePage advances level after correct code entry', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Locate button image and record position.
    final buttonFinder = find.byWidgetPredicate((widget) {
      return widget is Image &&
             widget.image is AssetImage &&
             (widget.image as AssetImage).assetName == 'images/button_image.png';
    });

    expect(buttonFinder, findsOneWidget);
    final initialButtonOffset = tester.getTopLeft(buttonFinder);

    // Tap the button to navigate to the ArticlePage.
    await tester.tap(find.byWidgetPredicate((widget) => widget is GestureDetector));
    await tester.pumpAndSettle();

    // Enter correct code.
    await tester.enterText(find.byType(TextField), '1234');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Unlock'));
    await tester.pumpAndSettle();

    // Verify button moved.
    final newButtonOffset = tester.getTopLeft(buttonFinder);
    expect(newButtonOffset, isNot(equals(initialButtonOffset)));
  });
}