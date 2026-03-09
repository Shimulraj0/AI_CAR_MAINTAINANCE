import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';

class SignUpController extends GetxController {
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController(
    text: 'Mock User',
  );
  final TextEditingController emailController = TextEditingController(
    text: 'mockuser@example.com',
  );
  final TextEditingController passwordController = TextEditingController(
    text: 'password123',
  );
  final TextEditingController confirmPasswordController = TextEditingController(
    text: 'password123',
  );

  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;
  var agreeToTerms = true.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  void toggleTerms() {
    agreeToTerms.value = !agreeToTerms.value;
  }

  void signUp() {
    if (signUpFormKey.currentState!.validate()) {
      if (!agreeToTerms.value) {
        Get.snackbar('Error', 'Please agree to the terms and conditions');
        return;
      }

      if (passwordController.text != confirmPasswordController.text) {
        Get.snackbar('Error', 'Passwords do not match');
        return;
      }

      final apiService = Get.find<ApiService>();

      final payload = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text,
      };

      apiService
          .initiateRegistration(payload)
          .listen(
            (response) {
              if (response.isOk) {
                // 200 or 201 check loosely depending on backend
                Get.snackbar(
                  'Success',
                  'Registration initiated successfully. Please check your email.',
                );
                Get.toNamed(Routes.verifyEmail, arguments: {'isSignUp': true});
              } else {
                Get.snackbar(
                  'Registration Failed',
                  response.body?['message'] ??
                      'Unable to process request at this time.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            onError: (error) {
              Get.snackbar('Error', 'An unexpected error occurred: $error');
            },
          );
    }
  }

  void navigateToSignIn() {
    Get.back(); // Return to Login
  }
}
