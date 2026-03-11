import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
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
      Get.offNamed(Routes.onboarding);
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
