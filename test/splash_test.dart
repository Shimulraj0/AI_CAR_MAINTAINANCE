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
          GetPage(
            name: '/onboarding',
            page: () => const Scaffold(body: Text('Onboarding')),
          ),
        ],
      ),
    );

    // Verify Splash Background Image is present
    expect(find.byType(Image), findsNWidgets(2)); // Background + Logo

    // Verify Navigation happens (simulated by checking if controller exists)
    expect(Get.isRegistered<SplashController>(), true);

    // Resolve the 3-second timer
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(); // Settle any animations
  });
}
