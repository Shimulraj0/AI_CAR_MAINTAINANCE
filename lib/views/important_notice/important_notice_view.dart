import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/important_notice_controller.dart';

class ImportantNoticeView extends GetView<ImportantNoticeController> {
  const ImportantNoticeView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ImportantNoticeController>()) {
      Get.put(ImportantNoticeController());
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF2B63A8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Important Notice',
              style: TextStyle(
                color: Color(0xFF1A1D23),
                fontSize: 24,
                fontFamily: 'Archivo',
                fontWeight: FontWeight.w700,
                height: 1.42,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 344,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Autointel Diagnostics provides ',
                      style: TextStyle(
                        color: Color(0xFF4B5563),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.57,
                      ),
                    ),
                    TextSpan(
                      text: 'advisory information only',
                      style: TextStyle(
                        color: Color(0xFF4B5563),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 1.57,
                      ),
                    ),
                    TextSpan(
                      text:
                          '. Our AI-powered analysis is designed to help you understand potential vehicle issues, but it is ',
                      style: TextStyle(
                        color: Color(0xFF4B5563),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.57,
                      ),
                    ),
                    TextSpan(
                      text: 'not a substitute for professional diagnosis',
                      style: TextStyle(
                        color: Color(0xFF4B5563),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 1.57,
                      ),
                    ),
                    TextSpan(
                      text: '.',
                      style: TextStyle(
                        color: Color(0xFF4B5563),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.57,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: ShapeDecoration(
                color: const Color(0xFFFFF7ED),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 0.80, color: Color(0xFFFDE68A)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Always consult a qualified mechanic before performing any repairs. Vehicle safety is your responsibility, and driving decisions should be made with professional guidance.',
                style: TextStyle(
                  color: Color(0xFF92400E),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.57,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildBulletPoint(
              'Results are based on common patterns and may not cover all scenarios',
            ),
            const SizedBox(height: 12),
            _buildBulletPoint(
              'We do not guarantee accuracy of diagnostic suggestions',
            ),
            const SizedBox(height: 12),
            _buildBulletPoint(
              'Safety ratings are estimates, not definitive assessments',
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Checkbox(
                    value: controller.isChecked.value,
                    onChanged: (value) => controller.toggleCheckbox(),
                    activeColor: const Color(0xFF2B63A8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const Expanded(
                  child: Text(
                    'I understand this is not a professional diagnosis and I accept responsibility for any decisions made based on this information.',
                    style: TextStyle(
                      color: Color(0xFF374151),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.57,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isChecked.value
                      ? controller.continueToDashboard
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.isChecked.value
                        ? const Color(0xFF2B63A8)
                        : const Color(0xFF2B63A8).withOpacity(0.5),
                    disabledBackgroundColor: const Color(
                      0xFF2B63A8,
                    ).withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '• ',
          style: TextStyle(color: Color(0xFF4B5563), fontSize: 14),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF4B5563),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.57,
            ),
          ),
        ),
      ],
    );
  }
}
