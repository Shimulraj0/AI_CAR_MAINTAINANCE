import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../controllers/diagnose_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<DiagnoseController>(() => DiagnoseController());
  }
}
