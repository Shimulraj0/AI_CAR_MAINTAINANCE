import 'package:get/get.dart';
import '../routes/app_routes.dart';

class VerifyEmailController extends GetxController {
  // Logic for OTP verification can go here
  // For now, it will just navigate to Change Password

  void verifyCode(String code) {
    if (code.length == 6) {
      final Map<String, dynamic> args = Get.arguments ?? {};
      final bool isSignUp = args['isSignUp'] ?? false;

      if (isSignUp) {
        Get.offAllNamed(Routes.home);
      } else {
        Get.toNamed(Routes.changePassword);
      }
    } else {
      Get.snackbar('Error', 'Please enter a valid 6-digit code');
    }
  }

  void resendCode() {
    Get.snackbar('Success', 'Code resent to your email');
  }
}
