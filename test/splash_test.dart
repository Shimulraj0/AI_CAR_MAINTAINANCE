import 'package:auto_intel/controllers/splash_controller.dart';
import 'package:auto_intel/views/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  testWidgets('SplashView renders and controller initializes', (
    WidgetTester tester,
  ) async {
    // Build the SplashView
    await tester.pumpWidget(
      GetMaterialApp(
        home: const SplashView(),
        getPages: [
          GetPage(
            name: '/home',
            page: () => const Scaffold(body: Text('Home')),
          ),
        ],
      ),
    );

    // Verify background painter is present (CustomPaint)
    expect(find.byKey(const Key('splash_background')), findsOneWidget);

    // Verify "Autointel" text is present
    expect(find.text('Autointel'), findsOneWidget);

    // Verify Navigation happens (simulated by checking if controller exists)
    expect(Get.isRegistered<SplashController>(), true);

    // Resolve the 3-second timer
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(); // Settle any animations
  });
}
