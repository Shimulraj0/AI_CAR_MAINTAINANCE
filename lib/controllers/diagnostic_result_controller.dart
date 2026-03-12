import 'package:get/get.dart';
import '../controllers/diagnose_controller.dart';
import '../services/api_service.dart';
import 'dart:convert';

class DiagnosticResultController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final DiagnoseController _diagnoseController = Get.find<DiagnoseController>();
  
  final Rx<dynamic> _localResult = Rx<dynamic>(null);
  
  List<Map<String, dynamic>> get resultsList {
    final dynamic rawData = _localResult.value ?? _diagnoseController.diagnosticResult.value;
    if (rawData == null) return [];
    
    List<Map<String, dynamic>> aggregatedResults = [];
    
    void processItem(dynamic item) {
      if (item is Map<String, dynamic>) {
        // Check for wrapping
        if (item.containsKey('data') && item['data'] is Map<String, dynamic>) {
          aggregatedResults.add(item['data']);
        } else if (item.containsKey('results') && item['results'] is List) {
          for (var r in item['results']) {
            if (r is Map<String, dynamic>) aggregatedResults.add(r);
          }
        } else {
          aggregatedResults.add(item);
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
        print('DIAGNOSTIC DATA RECEIVED: \$body');
        
        if (body is Map<String, dynamic>) {
          _localResult.value = body;
        } else if (body is List && body.isNotEmpty) {
          final firstItem = body[0];
          if (firstItem is Map<String, dynamic>) {
            _localResult.value = firstItem;
          }
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch details: \${response.reasonPhrase}');
      }
    } catch (error) {
      isLoading.value = false;
      Get.snackbar('Error', 'An error occurred: \$error');
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
