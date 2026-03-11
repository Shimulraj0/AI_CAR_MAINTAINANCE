import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';

class ChangePasswordController extends GetxController {
  final newPasswordController = TextEditingController(text: 'password123');
  final confirmPasswordController = TextEditingController(text: 'password123');
  final formKey = GlobalKey<FormState>();

  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  var isLoading = false.obs;

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void resetPassword() {
    if (formKey.currentState!.validate()) {
      if (newPasswordController.text == confirmPasswordController.text) {
        final apiService = Get.find<ApiService>();
        final Map<String, dynamic> args = Get.arguments ?? {};
        final String token = args['token'] ?? apiService.getResetToken() ?? '';

        String finalToken = token;
        if (args['token'] is Map) {
           final mapParams = args['token'] as Map;
           finalToken = mapParams['refresh'] ?? mapParams['access'] ?? mapParams['reset_token'] ?? token;
        }

        final payload = {
          'reset_token': finalToken,
          'new_password': newPasswordController.text,
          'confirm_new_password': confirmPasswordController.text,
        };

        isLoading.value = true;

        apiService.confirmPasswordReset(payload).listen(
          (response) {
            isLoading.value = false;
            print('ChangePassword API Status Code: ${response.statusCode}');
            print('ChangePassword API Payload Submitted: $payload');
            print('ChangePassword API Response Body: ${response.body}');
            if (response.statusCode == 200) {
              Get.snackbar('Success', 'Password reset successfully');
              Get.offAllNamed(Routes.changePasswordSuccess);
            } else {
              Get.snackbar(
                'Reset Failed',
                response.body?['message'] ?? response.body?['detail'] ?? 'Could not reset password',
              );
            }
          },
          onError: (error) {
            isLoading.value = false;
            Get.snackbar('Error', 'An unexpected error occurred: $error');
          },
        );
      } else {
        Get.snackbar('Error', 'Passwords do not match');
      }
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
