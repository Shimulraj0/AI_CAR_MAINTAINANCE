import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import '../services/api_service.dart';
import '../routes/app_routes.dart';
import 'home_controller.dart';

class DiagnoseController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  
  final diagnosticCodeController = TextEditingController();
  final symptomsController = TextEditingController();
  
  final RxList<String> diagnosticCodes = <String>[].obs;
  final RxString selectedVehicleId = "".obs;
  
  var isLoading = false.obs;
  
  // Store the diagnostic result to be displayed in the result view
  final Rx<dynamic> diagnosticResult = Rx<dynamic>(null);

  @override
  void onInit() {
    super.onInit();
    // Initialize with active vehicle from HomeController if available
    if (Get.isRegistered<HomeController>()) {
      final homeCtrl = Get.find<HomeController>();
      
      // Initial value
      if (selectedVehicleId.value.isEmpty) {
        selectedVehicleId.value = homeCtrl.activeVehicleId.value;
      }
      
      // Listen for changes in activeVehicleId and update ONLY if we don't have a selection yet
      ever(homeCtrl.activeVehicleId, (String newId) {
        if (selectedVehicleId.value.isEmpty && newId.isNotEmpty) {
          selectedVehicleId.value = newId;
        }
      });
    }
  }

  void addDiagnosticCode() {
    final code = diagnosticCodeController.text.trim().toUpperCase();
    if (code.isNotEmpty && !diagnosticCodes.contains(code)) {
      diagnosticCodes.add(code);
      diagnosticCodeController.clear();
    }
  }

  void removeDiagnosticCode(int index) {
    diagnosticCodes.removeAt(index);
  }

  Future<void> startAnalysis() async {
    if (selectedVehicleId.value.isEmpty) {
      Get.snackbar('Error', 'Please select a vehicle first');
      return;
    }

    final payload = {
      "vehicle": selectedVehicleId.value,
      "diagnostic_codes": diagnosticCodes.toList(),
      "symptoms": symptomsController.text.trim(),
    };

    isLoading.value = true;
    
    // Navigate to the analyzing view first (for UI feedback)
    Get.toNamed(Routes.analyzing);

    try {
      final response = await _apiService.createDiagnostic(payload);
      isLoading.value = false;
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic body = json.decode(response.body);
        // Result received
        
        diagnosticResult.value = body;
        
        final sessionId = _apiService.recursiveSearch(body, 'session_id') ?? 
                        _apiService.recursiveSearch(body, 'id') ?? 
                        _apiService.recursiveSearch(body, 'uuid');

        if (sessionId != null) {
          await _apiService.saveSessionId(sessionId.toString());
        }

        // After a short delay to allow the animation to show, go to results
        Future.delayed(const Duration(seconds: 1), () {
          Get.offNamed(
            Routes.diagnosticResult,
            arguments: {'diagnostic_id': sessionId},
          );
        });
      } else {
        Get.back(); // Come back from analyzing view
        Get.snackbar('Error', 'Failed to perform diagnostics: ${response.reasonPhrase}');
      }
    } catch (error) {
      isLoading.value = false;
      if (Get.currentRoute == Routes.analyzing) Get.back();
      Get.snackbar('Error', 'An unexpected error occurred: $error');
    }
  }

  @override
  void onClose() {
    diagnosticCodeController.dispose();
    symptomsController.dispose();
    super.onClose();
  }
}
