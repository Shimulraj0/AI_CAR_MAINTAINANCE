import 'package:get/get.dart';
import 'base_controller.dart';

class HomeController extends BaseController {
  var counter = 0.obs;

  void incrementCounter() {
    counter++;
  }
}
