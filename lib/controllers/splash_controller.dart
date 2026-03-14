import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> opacityAnimation;
  late Animation<double> scaleAnimation;

  @override
  void onInit() {
    super.onInit();
    // Increased duration slightly for a premium, non-rushed feel
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    // Fade in gracefully during the first portion
    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    // Start slightly scaled down (0.6) and use a spring/elastic curve to pop to 1.0
    scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.elasticOut),
      ),
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
