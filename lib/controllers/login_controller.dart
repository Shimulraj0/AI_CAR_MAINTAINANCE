import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isPasswordHidden = true.obs;
  var rememberMe = false.obs;

  var isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  void login() {
    if (loginFormKey.currentState!.validate()) {
      final apiService = Get.find<ApiService>();

      final payload = {
        'email': emailController.text.trim(),
        'password': passwordController.text,
      };

      isLoading.value = true;

      apiService
          .loginUser(payload)
          .listen(
            (response) {
              isLoading.value = false;
              print('Login API Status Code: ${response.statusCode}');
              print('Login API Response Body: ${response.body}');

              if (response.statusCode == 200) {
                final responseData = response.body;
                
                String? token;
                String? resetToken;
                if (responseData is Map<String, dynamic>) {
                  if (responseData.containsKey('tokens') && responseData['tokens'] is Map<String, dynamic>) {
                     token = responseData['tokens']['access'];
                     resetToken = responseData['tokens']['refresh'];
                  }
                  token ??= responseData['access'] ?? responseData['token'];
                  resetToken ??= responseData['refresh'] ?? responseData['reset_token'];
                }

                print('Extracted Token: $token');
                print('Extracted Reset Token: $resetToken');
                if (token != null) {
                  apiService.saveToken(token.toString());
                }
                if (resetToken != null) {
                  apiService.saveResetToken(resetToken.toString());
                }
                Get.offAllNamed(Routes.vehicleRegistration);
              } else {
                Get.snackbar(
                  'Login Failed',
                  response.body?['message'] ??
                      response.body?['detail'] ??
                      'Invalid credentials',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            onError: (error) {
              isLoading.value = false;
              print('Login API Error: $error');
              Get.snackbar('Error', 'An unexpected error occurred: $error');
            },
          );
    }
  }

  void googleLogin() {
    final apiService = Get.find<ApiService>();
    // Note: Normally, you'd integrate GoogleSignIn SDK here to get the token/idToken
    final payload = {'token': 'dummy_google_token'};

    isLoading.value = true;
    apiService
        .googleLogin(payload)
        .listen(
          (response) {
            isLoading.value = false;
            if (response.statusCode == 200) {
              Get.offAllNamed(Routes.vehicleRegistration);
            } else {
              Get.snackbar(
                'Google Login Failed',
                'Request failed: ${response.statusCode}',
              );
            }
          },
          onError: (error) {
            isLoading.value = false;
            Get.snackbar('Error', 'An unexpected error occurred: $error');
          },
        );
  }

  void appleLogin() {
    final apiService = Get.find<ApiService>();
    // Note: Normally, you'd integrate Sign in with Apple SDK here
    final payload = {'token': 'dummy_apple_token'};

    isLoading.value = true;
    apiService
        .appleLogin(payload)
        .listen(
          (response) {
            isLoading.value = false;
            if (response.statusCode == 200) {
              Get.offAllNamed(Routes.vehicleRegistration);
            } else {
              Get.snackbar(
                'Apple Login Failed',
                'Request failed: ${response.statusCode}',
              );
            }
          },
          onError: (error) {
            isLoading.value = false;
            Get.snackbar('Error', 'An unexpected error occurred: $error');
          },
        );
  }

  void navigateToSignUp() {
    Get.toNamed(Routes.signup);
  }

  void navigateToForgotPassword() {
    Get.toNamed(
      Routes.forgotPassword,
      arguments: {'email': emailController.text.trim()},
    );
  }
}
