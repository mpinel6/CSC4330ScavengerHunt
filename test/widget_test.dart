import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scavengerhutn/main.dart';

void main() {
  testWidgets('MapImagePage displays map and button, then navigates on tap', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(
      find.byWidgetPredicate((widget) {
        if (widget is Image && widget.image is AssetImage) {
          return (widget.image as AssetImage).assetName == 'assets/map_image.png';
        }
        return false;
      }),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((widget) {
        if (widget is Image && widget.image is AssetImage) {
          return (widget.image as AssetImage).assetName == 'assets/button_image.png';
        }
        return false;
      }),
      findsOneWidget,
    );

    await tester.tap(find.byWidgetPredicate((widget) => widget is GestureDetector));
    await tester.pumpAndSettle();

    expect(find.text('Enter Unlock Code'), findsOneWidget);
  });
}
