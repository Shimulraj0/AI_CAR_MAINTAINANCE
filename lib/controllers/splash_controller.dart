import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );
    animationController.forward();
  }

  @override
  void onReady() {
    super.onReady();
    // Simulate loading process
    Future.delayed(const Duration(seconds: 3), () {
      final apiService = Get.find<ApiService>();
      final token = apiService.getToken();
      final rememberMe = apiService.getRememberMe();

      if (rememberMe && token != null && token.isNotEmpty) {
        Get.offAllNamed(Routes.home);
      } else {
        Get.offNamed(Routes.onboarding);
      }
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
