import 'package:get/get.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;
  final autoStartDiagnose = false.obs;

  void changeTabIndex(int index, {bool autoStart = false}) {
    autoStartDiagnose.value = autoStart;
    currentIndex.value = index;
  }
}
