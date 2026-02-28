import 'package:get/get.dart';

class DiagnosticResultController extends GetxController {
  // Key: card index, Value: expanded state
  final RxMap<int, bool> expandedStates = <int, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Default the first cause to expanded
    expandedStates[0] = true;
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
