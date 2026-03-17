import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class MyVehiclesController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  
  final isLoading = true.obs;
  final vehicles = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchVehicles();
  }

  void fetchVehicles() {
    isLoading.value = true;
    _apiService.getVehicles().listen(
      (response) {
        isLoading.value = false;
        if (response.statusCode == 200 || response.statusCode == 201) {
          final fetchedVehicles = _apiService.parseVehicleList(response.body);
          vehicles.assignAll(fetchedVehicles);
        } else {
          debugPrint('MyVehiclesController: Fetch Error ${response.statusCode}');
          debugPrint('MyVehiclesController: Body ${response.body}');
          Get.snackbar(
             'Error', 
             'Failed to fetch vehicles (${response.statusCode})',
             snackPosition: SnackPosition.BOTTOM,
             backgroundColor: Colors.red,
             colorText: Colors.white,
          );
        }
      },
      onError: (error) {
        isLoading.value = false;
        Get.snackbar(
           'Error', 
           'An error occurred: $error',
           snackPosition: SnackPosition.BOTTOM,
           backgroundColor: Colors.red,
           colorText: Colors.white,
        );
      },
    );
  }

  void updateStatus(String vehicleId, String status) {
    _apiService.updateVehicle(vehicleId, {'status': status}).listen(
      (response) {
        if (response.statusCode == 200) {
          fetchVehicles(); // Refresh list
          Get.snackbar(
            'Success', 
            'Vehicle status updated',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            'Error', 
            'Failed to update status',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
      onError: (error) {
        Get.snackbar(
          'Error', 
          'An error occurred: $error',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    );
  }
}
