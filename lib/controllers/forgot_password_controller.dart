import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';

class ForgotPasswordController extends GetxController {
  final GlobalKey<FormState> forgotPasswordFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    if (args['email'] != null) {
      emailController.text = args['email'];
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  void sendResetLink() {
    if (forgotPasswordFormKey.currentState?.validate() ?? true) {
      if (emailController.text.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'Please enter your email on the previous screen to reset your password.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final apiService = Get.find<ApiService>();

      final payload = {'email': emailController.text.trim()};

      isLoading.value = true;

      apiService
          .initiatePasswordReset(payload)
          .listen(
            (response) {
              if (response.statusCode == 200 || response.statusCode == 201) {
                Get.snackbar(
                  'Success',
                  'Reset link sent to ${emailController.text.trim()}',
                );
                Get.toNamed(Routes.verifyEmail, arguments: {
                  'isSignUp': false,
                  'email': emailController.text.trim(),
                });
              } else {
                print('ForgotPassword API Error Status Code: ${response.statusCode}');
                print('ForgotPassword API Error Body: ${response.body}');
                Get.snackbar(
                  'Failed',
                  response.body?['message'] ?? response.body?['detail'] ??
                      'Unable to process request at this time.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            onError: (error) {
              isLoading.value = false;
              Get.snackbar('Error', 'An unexpected error occurred: $error');
            },
          );
    }
  }

  void navigateToSignIn() {
    Get.back(); // Return to Login
  }
}
