import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class AddMaintenanceController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  final TextEditingController serviceTypeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController mileageController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController nextDueDateController = TextEditingController();

  var isLoading = false.obs;

  @override
  void onClose() {
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

      final payload = {
        'service_type': serviceTypeController.text.trim(),
        'mileage': int.tryParse(mileageController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
        'next_due_date': nextDueDateController.text.trim(),
        'vehicle': 'Toyota Camry', // Hardcoded for now based on example
        'notes': notesController.text.trim(),
      };

      isLoading.value = true;
      final apiService = Get.find<ApiService>();

      apiService.createMaintenanceTask(payload).listen(
        (response) {
          isLoading.value = false;
          print('CreateMaintenance API Status Code: ${response.statusCode}');
          print('CreateMaintenance API Payload Submitted: $payload');
          print('CreateMaintenance API Response Body: ${response.body}');
          
          if (response.statusCode == 200 || response.statusCode == 201) {
            Get.snackbar('Success', 'Maintenance task added successfully');
            Get.back(); // Go back to the maintenance list
          } else {
            Get.snackbar(
              'Error',
              response.body?['message'] ?? response.body?['detail'] ?? 'Failed to add task',
            );
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
