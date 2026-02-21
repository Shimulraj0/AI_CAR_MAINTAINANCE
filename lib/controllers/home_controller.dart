import 'package:get/get.dart';
import 'base_controller.dart';

class HomeController extends BaseController {
  final RxInt currentIndex = 0.obs;

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }
}
