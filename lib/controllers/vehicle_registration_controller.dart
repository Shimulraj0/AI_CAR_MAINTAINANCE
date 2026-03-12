import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';

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
  final isLoading = false.obs;
  
  final ApiService _apiService = Get.find<ApiService>();

  String? vehicleId;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments['vehicle'] != null) {
      final vehicle = Get.arguments['vehicle'];
      vehicleId = vehicle['id']?.toString() ?? vehicle['uuid']?.toString();
      manufacturerController.text = vehicle['manufacturer']?.toString() ?? '';
      modelController.text = vehicle['model']?.toString() ?? '';
      yearController.text = vehicle['year']?.toString() ?? '';
      fuelTypeController.text = vehicle['fuel_type']?.toString() ?? '';
      engineSizeController.text = vehicle['engine_size']?.toString() ?? '';
      vinController.text = vehicle['vin_number']?.toString() ?? '';
      diagnosticCodesController.text = vehicle['diagnostic_codes']?.toString() ?? '';
    }

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
      isLoading.value = true;
      
      final payload = {
        "engine_size": engineSizeController.text.trim(),
        "fuel_type": fuelTypeController.text.trim(),
        "manufacturer": manufacturerController.text.trim(),
        "model": modelController.text.trim(),
        "vin_number": vinController.text.trim(),
        "year": int.tryParse(yearController.text.trim()) ?? 0,
        "diagnostic_codes": diagnosticCodesController.text.trim()
      };

      final requestStream = vehicleId != null
          ? _apiService.updateVehicle(vehicleId!, payload)
          : _apiService.addVehicle(payload);

      requestStream.listen(
        (response) {
          isLoading.value = false;
          if (response.statusCode == 200 || response.statusCode == 201) {
            Get.snackbar(
              'Success',
              vehicleId != null ? 'Vehicle updated successfully' : 'Vehicle registered successfully',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withValues(alpha: 0.1),
              colorText: Colors.green,
            );
            if (vehicleId != null) {
              // Refresh vehicles list and go back
              Get.back(result: true); 
            } else {
              Get.offAllNamed(Routes.home);
            }
          } else {
            String errorMessage = vehicleId != null ? 'Failed to update vehicle' : 'Failed to register vehicle';
            final bodyStr = response.bodyString ?? '';
            
            if (bodyStr.contains('Vin hash already exists') || bodyStr.contains('already exists')) {
              errorMessage = 'Vehicle is already registered.';
            } else if (response.body is Map && response.body['message'] != null) {
              errorMessage = response.body['message'].toString();
            } else if (response.body is Map && response.body['detail'] != null) {
              errorMessage = response.body['detail'].toString();
            } else if (!bodyStr.toLowerCase().contains('<!doctype html>')) {
              // If it's a short text message, we can show it, otherwise keep generic
              if (bodyStr.length < 100) {
                errorMessage = bodyStr;
              }
            }

            Get.rawSnackbar(
              message: errorMessage,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.black87,
              borderRadius: 20,
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 3),
            );
          }
        },
        onError: (error) {
          isLoading.value = false;
          Get.rawSnackbar(
            message: 'Connection failed. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black87,
            borderRadius: 20,
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
          );
        },
      );
    }
  }
}
