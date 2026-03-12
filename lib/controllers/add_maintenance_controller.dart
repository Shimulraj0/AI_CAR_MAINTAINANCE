import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import 'home_controller.dart';

class AddMaintenanceController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  final TextEditingController serviceTypeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController mileageController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController nextDueDateController = TextEditingController();

  var isLoading = false.obs;
  var isValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    serviceTypeController.addListener(checkValidation);
    dateController.addListener(checkValidation);
  }

  void checkValidation() {
    isValid.value = serviceTypeController.text.trim().isNotEmpty && 
                    dateController.text.trim().isNotEmpty;
  }

  @override
  void onClose() {
    serviceTypeController.removeListener(checkValidation);
    dateController.removeListener(checkValidation);
    serviceTypeController.dispose();
    dateController.dispose();
    mileageController.dispose();
    notesController.dispose();
    nextDueDateController.dispose();
    super.onClose();
  }

  void saveServiceRecord() {
    if (formKey.currentState?.validate() ?? false) {
      if (serviceTypeController.text.trim().isEmpty || dateController.text.trim().isEmpty) {
        Get.snackbar('Error', 'Service Type and Date are required');
        return;
      }

      final homeController = Get.find<HomeController>();
      final payload = <String, dynamic>{
        'service_type': serviceTypeController.text.trim(),
        'mileage': int.tryParse(mileageController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
        'vehicle': homeController.activeVehicleId.value,
      };

      if (nextDueDateController.text.trim().isNotEmpty) {
        payload['next_due_date'] = nextDueDateController.text.trim();
      } else if (dateController.text.trim().isNotEmpty) {
        // Fallback to the 'Date' field if 'Next Due Date' is empty, 
        // as the user's snippet uses next_due_date.
        payload['next_due_date'] = dateController.text.trim();
      }

      if (notesController.text.trim().isNotEmpty) {
        payload['notes'] = notesController.text.trim();
      }

      isLoading.value = true;
      final apiService = Get.find<ApiService>();

      apiService.createMaintenanceTask(payload).listen(
        (response) {
          isLoading.value = false;
          
          if (response.statusCode == 200 || response.statusCode == 201) {
            Get.snackbar('Success', 'Maintenance task added successfully');
            Get.back(); // Go back to the maintenance list
          } else {
            String errorMsg = 'Failed to add task';
            if (response.body != null) {
              if (response.body is Map) {
                if (response.body['message'] != null) {
                  errorMsg = response.body['message'].toString();
                } else if (response.body['detail'] != null) {
                  errorMsg = response.body['detail'].toString();
                } else {
                  errorMsg = response.body.toString();
                }
              } else {
                errorMsg = response.body.toString();
              }
            }
            Get.snackbar(
              'Error',
              errorMsg,
              snackPosition: SnackPosition.BOTTOM,
            );
            debugPrint('AddMaintenance API Error: ${response.statusCode} - $errorMsg');
          }
        },
        onError: (error) {
          isLoading.value = false;
          Get.snackbar('Error', 'An unexpected error occurred: $error');
        },
      );
    }
  }
}
