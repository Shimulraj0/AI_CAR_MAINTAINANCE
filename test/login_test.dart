import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:auto_intel/views/login/login_view.dart';
import 'package:auto_intel/controllers/login_controller.dart';

void main() {
  testWidgets('LoginView smoke test', (WidgetTester tester) async {
    // Build the LoginView wrapped in GetMaterialApp
    await tester.pumpWidget(GetMaterialApp(home: const LoginView()));

    // Verify "Log In" header is present
    expect(find.text('Log In'), findsOneWidget);

    // Verify "Welcome Back !" is present
    expect(find.text('Welcome Back !'), findsOneWidget);

    // Verify Email field
    expect(find.text('Email'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2)); // Email and Password

    // Verify "Sign in" button
    expect(find.text('Sign in'), findsOneWidget);

    // Verify "Sign up" link
    expect(find.text('Sign up'), findsOneWidget);

    // Verify Controller is initialized
    expect(Get.isRegistered<LoginController>(), true);
  });
}
