import 'package:get/get.dart';
import '../routes/app_routes.dart';

class ImportantNoticeController extends GetxController {
  final isChecked = false.obs;

  void toggleCheckbox() {
    isChecked.value = !isChecked.value;
  }

  void continueToDashboard() {
    if (isChecked.value) {
      Get.offAllNamed(Routes.home);
    }
  }
}
