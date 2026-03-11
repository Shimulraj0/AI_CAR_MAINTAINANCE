import 'package:get/get.dart';

import '../services/api_service.dart';
import '../routes/app_routes.dart';

class HomeController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final currentIndex = 0.obs;
  final autoStartDiagnose = false.obs;
  final isLoadingLogout = false.obs;

  void changeTabIndex(int index, {bool autoStart = false}) {
    autoStartDiagnose.value = autoStart;
    currentIndex.value = index;
  }

  Future<void> logout() async {
    isLoadingLogout.value = true;
    try {
      _apiService.logout();
      await _apiService.clearToken();
    } catch (e) {
      Get.snackbar('Error', 'Failed to logout: \${e.toString()}');
    } finally {
      isLoadingLogout.value = false;
      // Always clear out and go to login
      Get.offAllNamed(Routes.login);
    }
  }
}
