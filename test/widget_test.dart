import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scavengerhutn/main.dart';
import 'package:scavengerhutn/article_page.dart';
import 'package:scavengerhutn/blank_page.dart';

void main() {
  testWidgets('MapImagePage displays map image, button, and player marker', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Check if map image exists
    expect(
      find.byWidgetPredicate((widget) {
        if (widget is Image && widget.image is AssetImage) {
          return (widget.image as AssetImage).assetName == 'images/map_image.png';
        }
        return false;
      }),
      findsOneWidget,
    );

    // Check if button exists
    expect(
      find.byWidgetPredicate((widget) {
        if (widget is Image && widget.image is AssetImage) {
          return (widget.image as AssetImage).assetName == 'images/button_image.png';
        }
        return false;
      }),
      findsOneWidget,
    );

    // Check if player marker (tiger) exists
    expect(
      find.byWidgetPredicate((widget) {
        if (widget is Image && widget.image is AssetImage) {
          return (widget.image as AssetImage).assetName == 'images/player_marker.png';
        }
        return false;
      }),
      findsOneWidget,
    );

    // Check if scrollbar exists (for horizontal scrolling)
    expect(find.byType(Scrollbar), findsOneWidget);
  });

  testWidgets('Navigation to ArticlePage on button tap', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    await tester.tap(find.byWidgetPredicate((widget) => widget is GestureDetector));
    await tester.pumpAndSettle();

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

    expect(find.byType(Image), findsOneWidget);
    expect(find.text('This is the first article.'), findsOneWidget);

    expect(find.byType(TextField), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Unlock'), findsOneWidget);
  });

  testWidgets('MapImagePage advances level after correct code entry and moves tiger', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    final buttonFinder = find.byWidgetPredicate((widget) {
      return widget is Image &&
             widget.image is AssetImage &&
             (widget.image as AssetImage).assetName == 'images/button_image.png';
    });

    final tigerFinder = find.byWidgetPredicate((widget) {
      return widget is Image &&
             widget.image is AssetImage &&
             (widget.image as AssetImage).assetName == 'images/player_marker.png';
    });

    expect(buttonFinder, findsOneWidget);
    expect(tigerFinder, findsOneWidget);

    final initialButtonOffset = tester.getTopLeft(buttonFinder);
    final initialTigerOffset = tester.getTopLeft(tigerFinder);

    await tester.tap(find.byWidgetPredicate((widget) => widget is GestureDetector));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '1234');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Unlock'));
    await tester.pumpAndSettle();

    final newButtonOffset = tester.getTopLeft(buttonFinder);
    final newTigerOffset = tester.getTopLeft(tigerFinder);

    expect(newButtonOffset, isNot(equals(initialButtonOffset))); // Button moved
    expect(newTigerOffset, isNot(equals(initialTigerOffset))); // Tiger marker moved
  });

  testWidgets('BlankPage appears after unlocking a code', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ArticlePage(
        articleImage: 'images/article1.png',
        articleText: 'This is the first article.',
        correctCode: '1234',
      ),
    ));

    await tester.enterText(find.byType(TextField), '1234');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Unlock'));
    await tester.pumpAndSettle();

    expect(find.text("Continue"), findsOneWidget);
    expect(find.byType(BlankPage), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Continue'));
    await tester.pumpAndSettle();

    expect(find.byType(BlankPage), findsNothing); // Blank page should close
  });
}
