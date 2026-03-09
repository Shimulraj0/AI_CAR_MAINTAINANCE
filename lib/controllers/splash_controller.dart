import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    // Simulate loading process
    Future.delayed(const Duration(seconds: 3), () {
      print("Splash timer expired! Generating navigation intent.");
      try {
        if (Get.context != null) {
          Navigator.pushReplacementNamed(Get.context!, Routes.onboarding);
          print("Navigator.pushReplacementNamed command executed.");
        } else {
          print("Get context is null!");
        }
      } catch (e) {
        print("Routing error: $e");
      }
    });
  }
}
