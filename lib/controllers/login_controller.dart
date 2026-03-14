import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';
import '../widgets/custom_glass_toast.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isPasswordHidden = true.obs;
  var rememberMe = false.obs;

  var isLoading = false.obs;

  final ApiService _apiService = Get.find<ApiService>();

  @override
  void onInit() {
    super.onInit();
    rememberMe.value = _apiService.getRememberMe();
  }

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
      final apiService = _apiService;

      final payload = {
        'email': emailController.text.trim(),
        'password': passwordController.text,
      };

      debugPrint('--- Login Payload ---');
      debugPrint('Email: ${payload['email']}');
      debugPrint('Password: ${payload['password']}');

      isLoading.value = true;

      apiService
          .loginUser(payload)
          .listen(
            (response) {
              isLoading.value = false;
              debugPrint('Login API Status Code: ${response.statusCode}');
              debugPrint('Login API Response Body: ${response.body}');

              if (response.statusCode == 200 || response.statusCode == 201) {
                final responseData = response.body;

                String? token;
                String? resetToken;
                if (responseData is Map<String, dynamic>) {
                  if (responseData.containsKey('tokens') &&
                      responseData['tokens'] is Map<String, dynamic>) {
                    token = responseData['tokens']['access'];
                    resetToken = responseData['tokens']['refresh'];
                  }
                  token ??= responseData['access'] ?? responseData['token'];
                  resetToken ??=
                      responseData['refresh'] ?? responseData['reset_token'];
                }

                debugPrint('Extracted Token: $token');
                debugPrint('Extracted Reset Token: $resetToken');
                if (token != null) {
                  apiService.saveToken(token.toString());
                }
                if (resetToken != null) {
                  apiService.saveResetToken(resetToken.toString());
                }

                // Save Remember Me status
                apiService.saveRememberMe(rememberMe.value);

                // Fetch vehicles to decide routing
                apiService.getVehicles().listen(
                  (vehResponse) {
                    if (vehResponse.statusCode == 200 || vehResponse.statusCode == 201) {
                      final data = vehResponse.body;
                      bool hasVehicles = false;

                      if (data != null && data['results'] != null) {
                        hasVehicles = (data['results'] as List).isNotEmpty;
                      } else if (data is List) {
                        hasVehicles = data.isNotEmpty;
                      }

                      if (hasVehicles) {
                        Get.offAllNamed(Routes.home);
                      } else {
                        Get.offAllNamed(Routes.vehicleRegistration);
                      }
                    } else {
                      // Default to registration if we can't fetch vehicles
                      Get.offAllNamed(Routes.vehicleRegistration);
                    }
                  },
                  onError: (_) {
                    Get.offAllNamed(Routes.vehicleRegistration);
                  },
                );
              } else {
                var rawMessage =
                    response.body?['message'] ??
                    response.body?['detail'] ??
                    'Invalid credentials';

                String message = (rawMessage is List && rawMessage.isNotEmpty)
                    ? rawMessage.first.toString()
                    : rawMessage.toString();

                if (message.toLowerCase().contains('inactive')) {
                  CustomGlassToast.showInactiveUser();
                } else if (message.toLowerCase().contains('disabled')) {
                  CustomGlassToast.show(
                    title: 'Account Disabled',
                    message: 'User is disabled',
                    icon: Icons.block_flipped,
                  );
                } else {
                  CustomGlassToast.show(
                    title: 'Login Failed',
                    message: message,
                  );
                }
              }
            },
            onError: (error) {
              isLoading.value = false;
              debugPrint('Login API Error: $error');
              CustomGlassToast.show(
                title: 'Error',
                message: 'An unexpected error occurred',
              );
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
            if (response.statusCode == 200 || response.statusCode == 201) {
              // Fetch vehicles to decide routing
              apiService.getVehicles().listen(
                (vehResponse) {
                  if (vehResponse.statusCode == 200 || vehResponse.statusCode == 201) {
                    final data = vehResponse.body;
                    bool hasVehicles = false;

                    if (data != null && data['results'] != null) {
                      hasVehicles = (data['results'] as List).isNotEmpty;
                    } else if (data is List) {
                      hasVehicles = data.isNotEmpty;
                    }

                    if (hasVehicles) {
                      Get.offAllNamed(Routes.home);
                    } else {
                      Get.offAllNamed(Routes.vehicleRegistration);
                    }
                  } else {
                    Get.offAllNamed(Routes.vehicleRegistration);
                  }
                },
                onError: (_) {
                  Get.offAllNamed(Routes.vehicleRegistration);
                },
              );
            } else {
              CustomGlassToast.show(
                title: 'Google Login Failed',
                message: 'Request failed: ${response.statusCode}',
              );
            }
          },
          onError: (error) {
            isLoading.value = false;
            CustomGlassToast.show(
              title: 'Error',
              message: 'An unexpected error occurred',
            );
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
            if (response.statusCode == 200 || response.statusCode == 201) {
              // Fetch vehicles to decide routing
              apiService.getVehicles().listen(
                (vehResponse) {
                  if (vehResponse.statusCode == 200 || vehResponse.statusCode == 201) {
                    final data = vehResponse.body;
                    bool hasVehicles = false;

                    if (data != null && data['results'] != null) {
                      hasVehicles = (data['results'] as List).isNotEmpty;
                    } else if (data is List) {
                      hasVehicles = data.isNotEmpty;
                    }

                    if (hasVehicles) {
                      Get.offAllNamed(Routes.home);
                    } else {
                      Get.offAllNamed(Routes.vehicleRegistration);
                    }
                  } else {
                    Get.offAllNamed(Routes.vehicleRegistration);
                  }
                },
                onError: (_) {
                  Get.offAllNamed(Routes.vehicleRegistration);
                },
              );
            } else {
              CustomGlassToast.show(
                title: 'Apple Login Failed',
                message: 'Request failed: ${response.statusCode}',
              );
            }
          },
          onError: (error) {
            isLoading.value = false;
            CustomGlassToast.show(
              title: 'Error',
              message: 'An unexpected error occurred',
            );
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
