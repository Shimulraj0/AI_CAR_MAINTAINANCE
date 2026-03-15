import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/diagnose_controller.dart';
import '../../utils/responsive_helper.dart';

class DiagnoseTabView extends GetView<DiagnoseController> {
  const DiagnoseTabView({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if we need to auto-start the analysis process
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<HomeController>()) {
        final homeCtrl = Get.find<HomeController>();
        if (homeCtrl.autoStartDiagnose.value) {
          homeCtrl.autoStartDiagnose.value = false; // Reset flag
          controller.startAnalysis();
        }
      }
    });

    final homeController = Get.find<HomeController>();
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveHelper.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vehicle',
            style: TextStyle(
              color: Color(0xFF0F0F0F),
              fontSize: 14,
              fontFamily: 'Archivo',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.08),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: controller.selectedVehicleId.value.isEmpty
                      ? null
                      : controller.selectedVehicleId.value,
                  isExpanded: true,
                  hint: const Text("Select Vehicle"),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  items: homeController.userVehicles.map((vehicle) {
                    final make =
                        vehicle['manufacturer'] ?? vehicle['make'] ?? '';
                    final model = vehicle['model'] ?? '';
                    final year = vehicle['year']?.toString() ?? '';
                    final vehicleId =
                        vehicle['id']?.toString() ??
                        vehicle['uuid']?.toString() ??
                        "";

                    String displayName = "$year $make $model".trim();
                    if (displayName.isEmpty) displayName = "Unnamed Vehicle";

                    return DropdownMenuItem<String>(
                      value: vehicleId,
                      child: Text(
                        displayName,
                        style: const TextStyle(
                          color: Color(0xFF1A1D23),
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      controller.selectedVehicleId.value = newValue;
                    }
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Diagnostic Codes',
            style: TextStyle(
              color: Color(0xFF0F0F0F),
              fontSize: 14,
              fontFamily: 'Archivo',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Enter OBD-II codes (e.g. P0300, P0171)',
            style: TextStyle(
              color: Color(0xFF62748E),
              fontSize: 12,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.08),
                    ),
                  ),
                  child: TextField(
                    controller: controller.diagnosticCodeController,
                    decoration: InputDecoration(
                      hintText: 'Enter code',
                      hintStyle: const TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => controller.addDiagnosticCode(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: controller.addDiagnosticCode,
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDF2F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Add',
                    style: TextStyle(
                      color: Color(0xFF2F5EA8),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Added codes list
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.diagnosticCodes.asMap().entries.map((
                entry,
              ) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B63A8).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF2B63A8).withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        entry.value,
                        style: const TextStyle(
                          color: Color(0xFF2B63A8),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () =>
                            controller.removeDiagnosticCode(entry.key),
                        child: const Icon(
                          Icons.close,
                          size: 14,
                          color: Color(0xFF2B63A8),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Symptoms',
            style: TextStyle(
              color: Color(0xFF0F0F0F),
              fontSize: 14,
              fontFamily: 'Archivo',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Describe what you\'re experiencing in plain language',
            style: TextStyle(
              color: Color(0xFF62748E),
              fontSize: 12,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
            ),
            child: TextField(
              controller: controller.symptomsController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                hintText:
                    'e.g. Engine misfires at idle, rough vibration, reduced fuel economy...',
                hintStyle: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),

          const SizedBox(height: 48), // Spacer before button

          Obx(
            () => Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: controller.isLoading.value
                    ? null
                    : const Color(0xFF2B63A8),
                gradient: controller.isLoading.value
                    ? const LinearGradient(
                        colors: [Color(0xFF8BB8E8), Color(0xFFA5C9F0)],
                      )
                    : null,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.startAnalysis,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: Colors.transparent,
                  disabledForegroundColor: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (controller.isLoading.value)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    else
                      CustomPaint(
                        size: const Size(20, 20),
                        painter: _ScanIconPainter(),
                      ),
                    const SizedBox(width: 8),
                    Text(
                      controller.isLoading.value ? 'Analyzing...' : 'Analyze',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 120), // Bottom nav padding
        ],
      ),
    );
  }
}

class _ScanIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    // Outer broken arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 8.5),
      0.5,
      4.0,
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 8.5),
      5.0,
      1.2,
      false,
      paint,
    );

    // Inner broken arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 4.5),
      2.0,
      3.0,
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 4.5),
      -0.5,
      2.0,
      false,
      paint,
    );

    // Center dot
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(center, 1.5, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
