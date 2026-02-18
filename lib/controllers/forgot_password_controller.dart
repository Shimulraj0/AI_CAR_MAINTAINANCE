import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  final GlobalKey<FormState> forgotPasswordFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  void sendResetLink() {
    // Navigate to next screen or show success
    // For now, simulating success since email is "pre-selected"
    Get.snackbar('Success', 'Reset link sent to mu***@gmail.com');
    Get.toNamed(Routes.verifyEmail, arguments: {'isSignUp': false});
  }

  void navigateToSignIn() {
    Get.back(); // Return to Login
  }
}
