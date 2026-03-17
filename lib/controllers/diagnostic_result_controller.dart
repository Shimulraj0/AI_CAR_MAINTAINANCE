import 'package:get/get.dart';
import '../controllers/diagnose_controller.dart';
import '../services/api_service.dart';
import 'dart:convert';

class DiagnosticResultController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final DiagnoseController _diagnoseController = Get.find<DiagnoseController>();
  
  final Rx<dynamic> _localResult = Rx<dynamic>(null);
  final RxString sessionId = "".obs;
  
  List<Map<String, dynamic>> get resultsList {
    final dynamic rawData = _localResult.value ?? _diagnoseController.diagnosticResult.value;
    if (rawData == null) return [];

    // Extract session ID if not already set
    if (sessionId.value.isEmpty) {
      final id = _apiService.recursiveSearch(rawData, 'session_id') ?? 
               _apiService.recursiveSearch(rawData, 'id') ?? 
               _apiService.recursiveSearch(rawData, 'uuid');
      if (id != null) {
        sessionId.value = id.toString();
      }
    }
    
    List<Map<String, dynamic>> aggregatedResults = [];
    
    void processItem(dynamic item, [Map<String, dynamic>? parentData]) {
      if (item is Map<String, dynamic>) {
        // Collect current data to pass down
        Map<String, dynamic> currentData = parentData != null ? Map.from(parentData) : {};
        item.forEach((key, value) {
          if (key != 'response' && key != 'data' && key != 'results') {
            currentData[key] = value;
          }
        });

        if (item.containsKey('response')) {
          processItem(item['response'], currentData);
        } else if (item.containsKey('data') && item['data'] is Map<String, dynamic>) {
          processItem(item['data'], currentData);
        } else if (item.containsKey('results') && item['results'] is List) {
          for (var r in item['results']) {
            if (r is Map<String, dynamic>) {
              Map<String, dynamic> merged = Map.from(currentData)..addAll(r);
              aggregatedResults.add(merged);
            }
          }
        } else if (item.containsKey('likely_causes') || item.containsKey('causes') || item.containsKey('summary')) {
          Map<String, dynamic> merged = Map.from(currentData)..addAll(item);
          aggregatedResults.add(merged);
        } else {
          if (item.isNotEmpty) {
            Map<String, dynamic> merged = Map.from(currentData)..addAll(item);
            aggregatedResults.add(merged);
          }
        }
      }
    }

    if (rawData is List) {
      for (var item in rawData) {
        processItem(item);
      }
    } else {
      processItem(rawData);
    }
    
    return aggregatedResults;
  }

  // Deprecated shim for single-result logic
  Map<String, dynamic> get result => resultsList.isNotEmpty ? resultsList[0] : {};

  final RxBool isLoading = false.obs;

  // Key: card index, Value: expanded state
  final RxMap<int, bool> expandedStates = <int, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Default the first cause to expanded
    expandedStates[0] = true;

    // Check if an ID was passed in arguments to fetch specific details
    if (Get.arguments != null && Get.arguments['diagnostic_id'] != null) {
      fetchResultByID(Get.arguments['diagnostic_id'].toString());
    }
  }

  void fetchResultByID(String id) async {
    isLoading.value = true;
    try {
      final response = await _apiService.getDiagnosticDetails(id);
      isLoading.value = false;
      
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        // Data received
        
        if (body is Map<String, dynamic>) {
          _localResult.value = body;
        } else if (body is List && body.isNotEmpty) {
          final firstItem = body[0];
          if (firstItem is Map<String, dynamic>) {
            _localResult.value = firstItem;
          }
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch details: ${response.reasonPhrase}');
      }
    } catch (error) {
      isLoading.value = false;
      Get.snackbar('Error', 'An error occurred: $error');
    }
  }


  void toggleExpansion(int index) {
    if (expandedStates.containsKey(index)) {
      expandedStates[index] = !expandedStates[index]!;
    } else {
      expandedStates[index] = true;
    }
  }

  bool isExpanded(int index) {
    return expandedStates[index] ?? false;
  }
}
