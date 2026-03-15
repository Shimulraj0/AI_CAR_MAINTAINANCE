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
        if (response.statusCode == 200) {
          final data = response.body;
          if (data != null && data['results'] != null) {
            vehicles.assignAll(data['results']);
          } else if (data is List) {
             vehicles.assignAll(data);
          }
        } else {
          Get.snackbar(
             'Error', 
             'Failed to fetch vehicles',
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
