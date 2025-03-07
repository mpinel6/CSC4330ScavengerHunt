import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scavengerhutn/main.dart';

void main() {
  testWidgets('MapImagePage displays map image', (WidgetTester tester) async {
    // Build our app.
    await tester.pumpWidget(MyApp());

    // Verify the map image is present.
    expect(
      find.byWidgetPredicate((widget) {
        if (widget is Image && widget.image is AssetImage) {
          return (widget.image as AssetImage).assetName == 'assets/map_image.png';
        }
        return false;
      }),
      findsOneWidget,
    );
  });
}
