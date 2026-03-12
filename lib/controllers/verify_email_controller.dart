import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';

class VerifyEmailController extends GetxController {
  var isLoading = false.obs;
  var otpCodes = List<String>.filled(6, '').obs;

  void updateOtp(int index, String value) {
    otpCodes[index] = value;
  }

  void submitCode() {
    String code = otpCodes.join('');
    verifyCode(code);
  }

  void verifyCode(String code) {
    if (code.length == 6) {
      final Map<String, dynamic> args = Get.arguments ?? {};
      final bool isSignUp = args['isSignUp'] ?? false;
      final String? email = args['email'];
      final apiService = Get.find<ApiService>();

      isLoading.value = true;

      if (isSignUp) {
        final payload = {'code': code}; // Assuming signup verify still uses 'code'
        apiService
            .verifyRegistration(payload)
            .listen(
              (response) {
                isLoading.value = false;
                if (response.statusCode == 200) {
                  Get.snackbar('Success', 'Email verified successfully!');
                  Get.offAllNamed(Routes.vehicleRegistration);
                } else {
                  Get.snackbar(
                    'Verification Failed',
                    response.body?['message'] ?? 'Invalid code',
                  );
                }
              },
              onError: (error) {
                isLoading.value = false;
                Get.snackbar('Error', 'An unexpected error occurred: $error');
              },
            );
      } else {
        // Password Reset Flow
        if (email == null || email.isEmpty) {
          isLoading.value = false;
          Get.snackbar('Error', 'Missing email address for verification');
          return;
        }

        final payload = {
          'email': email,
          'otp': code,
        };

        apiService
            .verifyPasswordReset(payload)
            .listen(
              (response) {
                isLoading.value = false;
                debugPrint('VerifyPasswordReset API Status Code: ${response.statusCode}');
                debugPrint('VerifyPasswordReset API Response Body: ${response.body}');
                
                if (response.statusCode == 200) {
                  // The API might return the token in different keys
                  final responseData = response.body;
                  String? token;
                  
                  if (responseData is Map<String, dynamic>) {
                    if (responseData.containsKey('tokens') && responseData['tokens'] is Map<String, dynamic>) {
                       token = responseData['tokens']['refresh'] ?? responseData['tokens']['access'];
                    }
                    token ??= responseData['reset_token'] ?? responseData['token'] ?? responseData['access'];
                  }
                  
                  // if none of the above, use the string directly if that's what's returned
                  if (token == null && responseData is String && responseData.isNotEmpty) {
                    token = responseData;
                  }
                               
                  debugPrint('Password Reset token extracted: $token');
                  
                  if (token != null) {
                    apiService.saveResetToken(token.toString());
                  }

                  Get.toNamed(
                    Routes.changePassword,
                    arguments: {'token': token},
                  );
                } else {
                  Get.snackbar(
                    'Verification Failed',
                    response.body?['message'] ?? response.body?['detail'] ?? 'Invalid code',
                  );
                }
              },
              onError: (error) {
                isLoading.value = false;
                Get.snackbar('Error', 'An unexpected error occurred: $error');
              },
            );
      }
    } else {
      Get.snackbar('Error', 'Please enter a valid 6-digit code');
    }
  }

  void resendCode() {
    Get.snackbar('Success', 'Code resent to your email');
    // Note: Call the resend API endpoint if available.
  }
}
