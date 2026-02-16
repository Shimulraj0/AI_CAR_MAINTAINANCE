import 'package:get/get.dart';
import '../routes/app_routes.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final dynamic animationController;
  // Using dynamic effectively or AnimationController if we import flutter material/animation

  @override
  void onInit() {
    super.onInit();
    // Simulate loading process
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed(Routes.home);
    });
  }
}
