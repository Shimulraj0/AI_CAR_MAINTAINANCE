import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../services/api_service.dart';
import '../routes/app_routes.dart';

class HomeController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final currentIndex = 0.obs;
  final autoStartDiagnose = false.obs;
  final isLoadingLogout = false.obs;

  var userName = '...'.obs;
  var userEmail = '...'.obs;
  var userPhone = ''.obs;
  var userProfileImage = ''.obs;
  var vehicleName = 'Toyota Corolla 2020'.obs; // Default fallback
  var activeVehicleId = ''.obs;
  final RxList<Map<String, dynamic>> userVehicles = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
    fetchUserVehicles();
  }

  void fetchUserProfile() {
    _apiService.getProfile().listen(
      (response) {
        if (response.statusCode == 200) {
          final data = response.body;
          if (data != null) {
            userName.value = data['full_name'] ?? data['name'] ?? 'User';
            userEmail.value = data['email'] ?? '';
            userPhone.value = data['phone'] ?? '';
            userProfileImage.value = data['profile_picture'] ?? data['image'] ?? data['avatar'] ?? '';
            
            // Try to set vehicle name if available in profile
            if (data['vehicles'] != null) {
               final vehiclesList = data['vehicles'] as List;
               userVehicles.value = vehiclesList.map((e) => Map<String, dynamic>.from(e)).toList();
               
               if (userVehicles.isNotEmpty) {
                 final vehicle = userVehicles[0];
                 activeVehicleId.value = vehicle['id']?.toString() ?? vehicle['uuid']?.toString() ?? '';
                 updateVehicleDisplayName(vehicle);
               }
            }
          }
        }
      },
      onError: (error) {
        debugPrint('Failed to load profile in HomeController: $error');
      },
    );
  }

  void fetchUserVehicles() {
    _apiService.getVehicles().listen(
      (response) {
        if (response.statusCode == 200) {
          final data = response.body;
          List<Map<String, dynamic>> fetchedVehicles = [];
          
          if (data != null && data['results'] != null) {
            fetchedVehicles = List<Map<String, dynamic>>.from(data['results']);
          } else if (data is List) {
            fetchedVehicles = List<Map<String, dynamic>>.from(data);
          }
          
          if (fetchedVehicles.isNotEmpty) {
            userVehicles.assignAll(fetchedVehicles);
            
            // Set active vehicle if not already set
            if (activeVehicleId.value.isEmpty) {
              final vehicle = userVehicles[0];
              activeVehicleId.value = vehicle['id']?.toString() ?? vehicle['uuid']?.toString() ?? "";
              updateVehicleDisplayName(vehicle);
            }
          }
        }
      },
      onError: (error) {
        debugPrint('Failed to fetch vehicles in HomeController: $error');
      },
    );
  }

  void updateVehicleDisplayName(Map<String, dynamic> vehicle) {
    String manufacturer = vehicle['manufacturer'] ?? vehicle['make'] ?? '';
    String model = vehicle['model'] ?? '';
    String year = vehicle['year']?.toString() ?? '';
    if (manufacturer.isNotEmpty || model.isNotEmpty) {
      vehicleName.value = '$year $manufacturer $model'.trim();
    }
  }

  void changeTabIndex(int index, {bool autoStart = false}) {
    autoStartDiagnose.value = autoStart;
    currentIndex.value = index;
    if (index == 0) {
       fetchUserVehicles();
    }
    if (index == 3) { // 3 is usually the Profile tab index, refresh when navigated here
      fetchUserProfile();
      fetchUserVehicles();
    }
  }

  Future<void> logout() async {
    isLoadingLogout.value = true;
    try {
      _apiService.logout();
      await _apiService.clearToken();
    } catch (e) {
      Get.snackbar('Error', 'Failed to logout: \${e.toString()}');
    } finally {
      isLoadingLogout.value = false;
      // Always clear out and go to login
      Get.offAllNamed(Routes.login);
    }
  }
}
