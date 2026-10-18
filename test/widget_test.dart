import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:citrus/app/app.dart';

void main() {
  testWidgets('Citrus app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CitrusApp());

    // Verify that the app loads without crashing.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
