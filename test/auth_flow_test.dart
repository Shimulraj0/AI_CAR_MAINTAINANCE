import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:auto_intel/routes/app_routes.dart';
import 'package:auto_intel/routes/app_pages.dart';

void main() {
  testWidgets('Authentication Flow Navigation Test', (
    WidgetTester tester,
  ) async {
    // Set a fixed size for the test (Massive dimensions to strictly avoid all overflows)
    tester.view.physicalSize = const Size(3000, 3000);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Build the app with routes
    await tester.pumpWidget(
      GetMaterialApp(initialRoute: Routes.login, getPages: AppPages.routes),
    );

    // Verify Login Page
    expect(find.text('Log In'), findsOneWidget);

    // Navigate to Sign Up
    await tester.ensureVisible(find.text('Sign up'));
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    // Verify Sign Up Page
    expect(find.text('Sign Up'), findsOneWidget); // Header text
    expect(find.text('Create Account'), findsOneWidget); // Body text

    // Navigate back to Login
    await tester.ensureVisible(find.text('Sign in'));
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    // Verify Login Page again
    expect(find.text('Log In'), findsOneWidget);

    // Navigate to Forgot Password
    await tester.tap(find.text('Forgot password ?'));
    await tester.pumpAndSettle();

    // Verify Forgot Password Page
    expect(
      find.text('Forgot Password'),
      findsNWidgets(2),
    ); // Header and Body Title

    // Check for "Via email" text and tap it (acting as button now)
    expect(find.text('Via email'), findsOneWidget);
    await tester.tap(find.text('Via email'));
    await tester.pump(const Duration(seconds: 4)); // Wait for Snackbar timer
    await tester.pumpAndSettle();

    // Verify Verify Email Page
    expect(find.text('Verify Your Email'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget); // Verify Button

    // Tap Verify Button (using mock code '1234' logic in controller)
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify Change Password Page
    expect(find.text('Change Password'), findsOneWidget);
    expect(
      find.byType(TextFormField),
      findsNWidgets(2),
    ); // New & Confirm Password
    expect(find.text('Reset Password'), findsOneWidget);

    // Enter Passwords
    await tester.enterText(find.byType(TextFormField).at(0), 'password123');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.pump();

    // Tap Reset Password Button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(const Duration(seconds: 4)); // Wait for snackbar
    await tester.pumpAndSettle();

    // Verify Login Page again
    expect(find.text('Log In'), findsOneWidget);
  });

  testWidgets('Full Sign Up Flow Test', (WidgetTester tester) async {
    // Set a fixed size for the test (Massive dimensions to strictly avoid all overflows)
    tester.view.physicalSize = const Size(3000, 3000);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      GetMaterialApp(initialRoute: Routes.login, getPages: AppPages.routes),
    );

    // Navigate to Sign Up
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    // Fill Sign Up Form
    await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'john@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(2), 'password123');
    await tester.enterText(find.byType(TextFormField).at(3), 'password123');

    // Scroll to find Checkbox
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -200),
    );
    await tester.pump();

    // Agree to Terms (Tap checkbox)
    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    // Tap Sign Up Button
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    // Verify Verify Email Page
    expect(find.text('Verify Your Email'), findsOneWidget);

    // Tap Verify Button (using mock code '123456')
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify Home Page (Sign Up success flow)
    expect(find.text('Home'), findsOneWidget);
  });
}
