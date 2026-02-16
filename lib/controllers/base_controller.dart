import 'package:get/get.dart';

class BaseController extends GetxController {
  // Common functionality for all controllers can go here
  // For example, loading state, error handling, etc.

  var isLoading = false.obs;

  void showLoading() => isLoading.value = true;
  void hideLoading() => isLoading.value = false;
}
