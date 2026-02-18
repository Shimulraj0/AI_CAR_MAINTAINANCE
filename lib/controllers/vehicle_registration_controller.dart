import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class VehicleRegistrationController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final manufacturerController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  final fuelTypeController = TextEditingController();
  final engineSizeController = TextEditingController();
  final vinController = TextEditingController(); // Optional
  final diagnosticCodesController = TextEditingController(); // Optional

  final isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Add listeners to validate form on change
    manufacturerController.addListener(_validateForm);
    modelController.addListener(_validateForm);
    yearController.addListener(_validateForm);
    fuelTypeController.addListener(_validateForm);
    engineSizeController.addListener(_validateForm);
  }

  void _validateForm() {
    isFormValid.value =
        manufacturerController.text.isNotEmpty &&
        modelController.text.isNotEmpty &&
        yearController.text.isNotEmpty &&
        fuelTypeController.text.isNotEmpty &&
        engineSizeController.text.isNotEmpty;
  }

  @override
  void onClose() {
    manufacturerController.dispose();
    modelController.dispose();
    yearController.dispose();
    fuelTypeController.dispose();
    engineSizeController.dispose();
    vinController.dispose();
    diagnosticCodesController.dispose();
    super.onClose();
  }

  void saveVehicle() {
    if (formKey.currentState!.validate()) {
      // Logic to save vehicle data
      Get.toNamed(Routes.importantNotice);
    }
  }
}
