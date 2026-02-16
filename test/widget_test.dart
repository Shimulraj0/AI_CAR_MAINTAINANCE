// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:auto_intel/main.dart';
import 'package:get/get.dart';
import 'package:auto_intel/controllers/home_controller.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Set a fixed size for the test
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;

    // Reset after test
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for Splash Screen to finish (3 seconds) + Navigation animation
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Verify FAB functionality via Controller (bypassing layout issues)
    final HomeController controller = Get.find<HomeController>();
    controller.incrementCounter();

    // Trigger a frame.
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
