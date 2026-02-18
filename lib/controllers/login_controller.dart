import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isPasswordHidden = true.obs;
  var rememberMe = false.obs;

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
      // Perform login logic here
      Get.offAllNamed(Routes.vehicleRegistration);
    }
  }

  void navigateToSignUp() {
    Get.toNamed(Routes.signup);
  }

  void navigateToForgotPassword() {
    Get.toNamed(Routes.forgotPassword);
  }
}
