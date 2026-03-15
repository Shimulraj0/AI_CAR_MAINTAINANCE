import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/api_service.dart';
import 'home_controller.dart';

class TaskDetailsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  
  var isLoading = true.obs;
  var taskDetails = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final id = args['id']?.toString();
    if (id != null && id.isNotEmpty) {
      fetchTaskDetails(id);
    } else {
      isLoading.value = false;
    }
  }

  void fetchTaskDetails(String id) async {
    isLoading.value = true;
    try {
      final response = await _apiService.getMaintenanceTask(id);
      if (response.statusCode == 200) {
        taskDetails.value = json.decode(response.body);
      } else {
        debugPrint('Failed to fetch task details: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception fetching task details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  var isCompleting = false.obs;

  Future<void> markAsCompleted() async {
    final id = taskDetails['id']?.toString() ?? (Get.arguments as Map<String, dynamic>?)?['id']?.toString();
    if (id == null) return;

    isCompleting.value = true;
    try {
      final response = await _apiService.markTaskAsCompleted(id, true);
      if (response.statusCode == 200) {
        // Refresh stats/lists in HomeController
        if (Get.isRegistered<HomeController>()) {
          final homeController = Get.find<HomeController>();
          homeController.fetchMaintenanceStats();
          homeController.fetchAllMaintenanceTasks();
        }
        Get.back(); // Navigate back
        Get.snackbar(
          'Success',
          'Task marked as completed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
        );
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
    } finally {
      isCompleting.value = false;
    }
  }

  var isDeleting = false.obs;

  Future<void> deleteTask() async {
    final id = taskDetails['id']?.toString() ?? (Get.arguments as Map<String, dynamic>?)?['id']?.toString();
    if (id == null) return;

    // Direct confirmation using Get.dialog or similar would be better, 
    // but for now implementing the core logic.
    isDeleting.value = true;
    try {
      final response = await _apiService.deleteMaintenanceTask(id);
      if (response.statusCode == 200 || response.statusCode == 204) {
        if (Get.isRegistered<HomeController>()) {
          final homeController = Get.find<HomeController>();
          homeController.fetchMaintenanceStats();
          homeController.fetchAllMaintenanceTasks();
        }
        Get.back(); // Navigate back
        Get.snackbar(
          'Success',
          'Task deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete task: ${response.statusCode}\n${response.body}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      debugPrint('Error deleting task: $e');
    } finally {
      isDeleting.value = false;
    }
  }
}
