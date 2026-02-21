import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class VehicleRegistrationController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final manufacturerController = TextEditingController(text: 'Toyota');
  final modelController = TextEditingController(text: 'Camry');
  final yearController = TextEditingController(text: '2022');
  final fuelTypeController = TextEditingController(text: 'Hybrid');
  final engineSizeController = TextEditingController(text: '2.5L');
  final vinController = TextEditingController(
    text: '1HGCM82633A00000',
  ); // Optional
  final diagnosticCodesController = TextEditingController(
    text: 'P0171',
  ); // Optional

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

    // Initial validation since fields are pre-filled
    _validateForm();
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
