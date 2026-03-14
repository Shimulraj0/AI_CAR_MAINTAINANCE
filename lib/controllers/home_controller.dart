import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../services/api_service.dart';
import '../routes/app_routes.dart';

class HomeController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final currentIndex = 0.obs;
  final autoStartDiagnose = false.obs;
  final isLoadingLogout = false.obs;
  final selectedPlanIndex = 1.obs; // 0 for Starter, 1 for Pro
  final isProcessingPayment = false.obs;

  var userName = '...'.obs;
  var userEmail = '...'.obs;
  var userPhone = ''.obs;
  var userProfileImage = ''.obs;
  var vehicleName = 'Toyota Corolla 2020'.obs; // Default fallback
  var activeVehicleId = ''.obs;
  final RxList<Map<String, dynamic>> userVehicles = <Map<String, dynamic>>[].obs;

  // Maintenance Stats
  var upcomingCount = 0.obs;
  var overdueCount = 0.obs;
  var completedCount = 0.obs;

  // Maintenance Tasks
  final RxList<dynamic> upcomingTasks = <dynamic>[].obs;
  final RxList<dynamic> overdueTasks = <dynamic>[].obs;
  final RxList<dynamic> completedTasks = <dynamic>[].obs;

  var upcomingPage = 1;
  var overduePage = 1;
  var completedPage = 1;

  var upcomingHasNext = true.obs;
  var overdueHasNext = true.obs;
  var completedHasNext = true.obs;

  var upcomingIsLoading = false.obs;
  var overdueIsLoading = false.obs;
  var completedIsLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
    fetchUserVehicles();
    fetchMaintenanceStats();
    fetchAllMaintenanceTasks();
  }

  void fetchUserProfile() {
    // ... Implementation unchanged for clarity ...
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

  void fetchMaintenanceStats() async {
    try {
      final response = await _apiService.getMaintenanceStats();
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Parse the stats based on assumed standard API output
        upcomingCount.value = data['upcoming'] ?? 0;
        overdueCount.value = data['overdue'] ?? 0;
        completedCount.value = data['completed'] ?? 0;
      }
    } catch (e) {
      debugPrint('Error fetching maintenance stats: $e');
    }
  }

  void fetchAllMaintenanceTasks() {
    upcomingPage = 1;
    overduePage = 1;
    completedPage = 1;
    
    upcomingHasNext.value = true;
    overdueHasNext.value = true;
    completedHasNext.value = true;

    _fetchTasksForStatus('upcoming', upcomingTasks, upcomingPage, upcomingHasNext, upcomingIsLoading);
    _fetchTasksForStatus('overdue', overdueTasks, overduePage, overdueHasNext, overdueIsLoading);
    _fetchTasksForStatus('completed', completedTasks, completedPage, completedHasNext, completedIsLoading);
  }

  void nextMaintenanceTasksPage(String status) {
    if (status == 'upcoming' && upcomingHasNext.value && !upcomingIsLoading.value) {
      upcomingPage++;
      _fetchTasksForStatus('upcoming', upcomingTasks, upcomingPage, upcomingHasNext, upcomingIsLoading);
    } else if (status == 'overdue' && overdueHasNext.value && !overdueIsLoading.value) {
      overduePage++;
      _fetchTasksForStatus('overdue', overdueTasks, overduePage, overdueHasNext, overdueIsLoading);
    } else if (status == 'completed' && completedHasNext.value && !completedIsLoading.value) {
      completedPage++;
      _fetchTasksForStatus('completed', completedTasks, completedPage, completedHasNext, completedIsLoading);
    }
  }

  void previousMaintenanceTasksPage(String status) {
    if (status == 'upcoming' && upcomingPage > 1 && !upcomingIsLoading.value) {
      upcomingPage--;
      _fetchTasksForStatus('upcoming', upcomingTasks, upcomingPage, upcomingHasNext, upcomingIsLoading);
    } else if (status == 'overdue' && overduePage > 1 && !overdueIsLoading.value) {
      overduePage--;
      _fetchTasksForStatus('overdue', overdueTasks, overduePage, overdueHasNext, overdueIsLoading);
    } else if (status == 'completed' && completedPage > 1 && !completedIsLoading.value) {
      completedPage--;
      _fetchTasksForStatus('completed', completedTasks, completedPage, completedHasNext, completedIsLoading);
    }
  }

  void _fetchTasksForStatus(
    String status, 
    RxList<dynamic> targetList, 
    int page, 
    RxBool hasNextVal, 
    RxBool isLoadingVal, 
  ) async {
    isLoadingVal.value = true;
    try {
      final response = await _apiService.getMaintenanceTasks(status, page: page);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        List<dynamic> newTasks = [];
        if (data != null && data['results'] != null) {
          newTasks = data['results'];
          hasNextVal.value = data['next'] != null; // DRF standard pagination
        } else if (data is List) {
          newTasks = data;
          hasNextVal.value = false; // No envelope, assume all loaded
        }
        
        targetList.assignAll(newTasks);
      }
    } catch (e) {
      debugPrint('Error fetching $status maintenance tasks on page $page: $e');
    } finally {
      isLoadingVal.value = false;
    }
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
      // Explicitly ensuring rememberMe is also cleared if they logout
      await _apiService.saveRememberMe(false);
    } catch (e) {
      Get.snackbar('Error', 'Failed to logout: \${e.toString()}');
    } finally {
      isLoadingLogout.value = false;
      // Always clear out and go to login
      Get.offAllNamed(Routes.login);
    }
  }
}
