import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/api_service.dart';
import '../services/iap_service.dart';
import '../routes/app_routes.dart';

class HomeController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final IAPService _iapService = Get.find<IAPService>();

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
  var lastSessionId = ''.obs;
  final RxList<Map<String, dynamic>> userVehicles =
      <Map<String, dynamic>>[].obs;

  // Maintenance Stats
  var upcomingCount = 0.obs;
  var overdueCount = 0.obs;
  var completedCount = 0.obs;

  // Diagnostic Stats
  var diagnosticTotalCount = 0.obs;
  var diagnosticFreeCount = 0.obs;
  var diagnosticFullCount = 0.obs;
  var diagnosticUnlockedCount = 0.obs;

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
    fetchDiagnosticStats();
    fetchAllMaintenanceTasks();
    lastSessionId.value = _apiService.getSessionId() ?? '';
    // Wire up IAP success callback
    _iapService.onPurchaseSuccess = () {
      isProcessingPayment.value = false;
      Get.toNamed(
        Routes.paymentSuccess,
        arguments: {'revealOffset': _lastRevealOffset},
      );
    };
  }

  Offset? _lastRevealOffset;

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
            userProfileImage.value =
                data['profile_picture'] ??
                data['image'] ??
                data['avatar'] ??
                '';

            // Try to set vehicle name if available in profile
            if (data['vehicles'] != null) {
              final vehiclesList = data['vehicles'] as List;
              userVehicles.value = vehiclesList
                  .map((e) => Map<String, dynamic>.from(e))
                  .toList();

              if (userVehicles.isNotEmpty) {
                final vehicle = userVehicles[0];
                activeVehicleId.value =
                    vehicle['id']?.toString() ??
                    vehicle['uuid']?.toString() ??
                    '';
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

  void fetchDiagnosticStats() async {
    try {
      final response = await _apiService.getDiagnosticStats();
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        diagnosticTotalCount.value = data['total_diagnostics'] ?? 0;
        diagnosticFreeCount.value = data['free_diagnostics'] ?? 0;
        diagnosticFullCount.value = data['full_diagnostics'] ?? 0;
        diagnosticUnlockedCount.value = data['unlocked_sessions'] ?? 0;
      }
    } catch (e) {
      debugPrint('Error fetching diagnostic stats: $e');
    }
  }

  void fetchAllMaintenanceTasks() {
    upcomingPage = 1;
    overduePage = 1;
    completedPage = 1;

    upcomingHasNext.value = true;
    overdueHasNext.value = true;
    completedHasNext.value = true;

    _fetchTasksForStatus(
      'upcoming',
      upcomingTasks,
      upcomingPage,
      upcomingHasNext,
      upcomingIsLoading,
    );
    _fetchTasksForStatus(
      'overdue',
      overdueTasks,
      overduePage,
      overdueHasNext,
      overdueIsLoading,
    );
    _fetchTasksForStatus(
      'completed',
      completedTasks,
      completedPage,
      completedHasNext,
      completedIsLoading,
    );
  }

  void nextMaintenanceTasksPage(String status) {
    if (status == 'upcoming' &&
        upcomingHasNext.value &&
        !upcomingIsLoading.value) {
      upcomingPage++;
      _fetchTasksForStatus(
        'upcoming',
        upcomingTasks,
        upcomingPage,
        upcomingHasNext,
        upcomingIsLoading,
      );
    } else if (status == 'overdue' &&
        overdueHasNext.value &&
        !overdueIsLoading.value) {
      overduePage++;
      _fetchTasksForStatus(
        'overdue',
        overdueTasks,
        overduePage,
        overdueHasNext,
        overdueIsLoading,
      );
    } else if (status == 'completed' &&
        completedHasNext.value &&
        !completedIsLoading.value) {
      completedPage++;
      _fetchTasksForStatus(
        'completed',
        completedTasks,
        completedPage,
        completedHasNext,
        completedIsLoading,
      );
    }
  }

  void previousMaintenanceTasksPage(String status) {
    if (status == 'upcoming' && upcomingPage > 1 && !upcomingIsLoading.value) {
      upcomingPage--;
      _fetchTasksForStatus(
        'upcoming',
        upcomingTasks,
        upcomingPage,
        upcomingHasNext,
        upcomingIsLoading,
      );
    } else if (status == 'overdue' &&
        overduePage > 1 &&
        !overdueIsLoading.value) {
      overduePage--;
      _fetchTasksForStatus(
        'overdue',
        overdueTasks,
        overduePage,
        overdueHasNext,
        overdueIsLoading,
      );
    } else if (status == 'completed' &&
        completedPage > 1 &&
        !completedIsLoading.value) {
      completedPage--;
      _fetchTasksForStatus(
        'completed',
        completedTasks,
        completedPage,
        completedHasNext,
        completedIsLoading,
      );
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
      final response = await _apiService.getMaintenanceTasks(
        status,
        page: page,
      );
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
        if (response.statusCode == 200 || response.statusCode == 201) {
          final fetchedVehicles = _apiService.parseVehicleList(response.body);

          if (fetchedVehicles.isNotEmpty) {
            userVehicles.assignAll(fetchedVehicles);

            // Set active vehicle if not already set
            if (activeVehicleId.value.isEmpty) {
              final vehicle = userVehicles[0];
              activeVehicleId.value =
                  vehicle['id']?.toString() ??
                  vehicle['uuid']?.toString() ??
                  "";
              updateVehicleDisplayName(vehicle);
            }
          } else {
            userVehicles.clear();
          }
        } else {
          debugPrint('Failed to fetch vehicles in HomeController: ${response.statusCode}');
          Get.snackbar(
            'Error',
            'Failed to load vehicles (${response.statusCode})',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withValues(alpha: 0.1),
            colorText: Colors.red,
          );
        }
      },
      onError: (error) {
        debugPrint('Error in fetchUserVehicles in HomeController: $error');
        Get.snackbar(
          'Error',
          'A connection error occurred while loading vehicles',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
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

  void selectVehicle(dynamic vehicle) {
    final vehicleMap = vehicle is Map
        ? vehicle
        : Map<String, dynamic>.from(vehicle);
    activeVehicleId.value =
        vehicleMap['id']?.toString() ?? vehicleMap['uuid']?.toString() ?? "";
    updateVehicleDisplayName(Map<String, dynamic>.from(vehicleMap));
  }

  void changeTabIndex(int index, {bool autoStart = false}) {
    autoStartDiagnose.value = autoStart;
    currentIndex.value = index;
    if (index == 0) {
      fetchUserVehicles();
    }
    if (index == 3) {
      // 3 is usually the Profile tab index, refresh when navigated here
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

  Future<void> markTaskCompleted(String taskId) async {
    try {
      final response = await _apiService.markTaskCompleted(taskId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Sync the latest session ID picked up from the completed task response
        lastSessionId.value = _apiService.getSessionId() ?? '';
        
        debugPrint('HomeController - Synced new Session ID after task completion: ${lastSessionId.value}');

        Get.snackbar(
          'Success',
          'Task marked as completed successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
        );
        // Refresh data
        fetchMaintenanceStats();
        fetchAllMaintenanceTasks();
        
        // Go back to Maintenance tab
        changeTabIndex(2);
        Get.offAllNamed(Routes.home);
      } else {
        Get.snackbar(
          'Error',
          'Failed to mark task as completed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error marking task as completed: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      final response = await _apiService.deleteMaintenanceTask(taskId);
      if (response.statusCode == 200 || response.statusCode == 204) {
        Get.snackbar(
          'Success',
          'Task deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
        );
        // Refresh data
        fetchMaintenanceStats();
        fetchAllMaintenanceTasks();
        
        // Go back to Maintenance tab
        changeTabIndex(2);
        Get.offAllNamed(Routes.home);
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete task',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error deleting task: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
    }
  }

  Future<void> startSubscription(String productId, {Offset? revealOffset}) async {
    isProcessingPayment.value = true;
    _lastRevealOffset = revealOffset;
    try {
      final launched = await _iapService.buyProduct(productId);
      if (!launched) {
        isProcessingPayment.value = false;
      }
    } catch (e) {
      debugPrint('Subscription Error: $e');
      Get.snackbar('Error', 'An unexpected error occurred during payment');
      isProcessingPayment.value = false;
    }
  }
}
