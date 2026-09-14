// Basic smoke test: the app boots and shows the Intro view's "let's start"
// button without throwing.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:simple_weather_app/core/routes/app_router.dart';
import 'package:simple_weather_app/core/routes/routes.dart';

void main() {
  testWidgets('Intro view shows the lets start button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        onGenerateRoute: AppRouter().generateRoute,
        initialRoute: Routes.intro,
      ),
    );
    await tester.pump();

    expect(find.text("let's start"), findsOneWidget);
  });
}
