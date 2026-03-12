import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';

class SignUpController extends GetxController {
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;
  var agreeToTerms = true.obs;
  var isLoading = false.obs;

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
        'full_name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text,
        'confirm_password': confirmPasswordController.text,
      };

      isLoading.value = true;

      apiService
          .initiateRegistration(payload)
          .listen(
            (response) {
              isLoading.value = false;
              debugPrint('Signup API Status Code: ${response.statusCode}');
              debugPrint('Signup API Response Body: ${response.body}');

              if (response.statusCode == 200 || response.statusCode == 201) {
                Get.snackbar('Success', 'Account created successfully!');
                Get.toNamed(Routes.verifyEmail, arguments: {
                  'isSignUp': true,
                  'email': emailController.text.trim(),
                });
              } else {
                debugPrint('SignUp API Error Status Code: ${response.statusCode}');
                debugPrint('SignUp API Error Body: ${response.body}');
                Get.snackbar(
                  'Sign Up Failed',
                  response.body?['message'] ?? response.body?['detail'] ??
                      'Unable to process request at this time.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            onError: (error) {
              isLoading.value = false;
              debugPrint('Signup API Error: $error');
              Get.snackbar('Error', 'An unexpected error occurred: $error');
            },
          );
    }
  }

  void navigateToSignIn() {
    Get.back(); // Return to Login
  }
}
