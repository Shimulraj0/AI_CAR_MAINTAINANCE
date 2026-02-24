import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/faqs_controller.dart';

class FaqsView extends GetView<FaqsController> {
  const FaqsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B63A8),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 16),
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'FAQs',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Archivo',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors
              .transparent, // Removes the divider lines between ExpansionTiles
        ),
        child: ListView(
          padding: const EdgeInsets.only(
            left: 26,
            right: 26,
            top: 24,
            bottom: 40, // Extra padding at bottom for scrollability
          ),
          children: [
            _buildSection(
              title: 'How does the AI diagnosis work?',
              content: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'The AI analyzes the vehicle symptoms and any diagnostic codes you provide to identify possible issues.\nIt compares your inputs with a large database of known vehicle fault patterns and generates the most likely causes based on probability and confidence level.\nYou’ll receive:\n',
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.60),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.30,
                      ),
                    ),
                    TextSpan(
                      text:
                          '• A severity level\n• Possible causes ranked by probability\n• Recommended next steps\n',
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.60),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.30,
                      ),
                    ),
                    TextSpan(
                      text:
                          'The system is designed to provide guidance, but it does not replace a professional mechanic inspection.',
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.60),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Do I need a diagnostic code to use the app?',
              content: Text(
                'No, entering a diagnostic code is optional.\nYou can simply describe your vehicle symptoms (e.g., check engine light, rough idle, reduced fuel economy), and the AI will still generate an assessment.\nHowever, adding a diagnostic code (such as P0133) improves accuracy and allows the system to provide more precise recommendations.',
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.60),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.30,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'How accurate are the diagnostic results?',
              content: Text(
                'Our AI models are trained on extensive data, but accuracy depends on the details provided. Complex issues might require physical inspection.',
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.60),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.30,
                ),
              ),
              isExpanded: false, // Default closed based on UI
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Can I track my vehicle’s maintenance history?',
              content: Text(
                'Yes, you can save reports and log maintenance history within the "Saved Reports" and "My Vehicles" sections of the app.',
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.60),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.30,
                ),
              ),
              isExpanded: false, // Default closed based on UI
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'What features are included in the premium plan?',
              content: Text(
                'The premium plan includes advanced AI insights, unlimited vehicle profiles, historical data analysis, and priority support.',
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.60),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.30,
                ),
              ),
              isExpanded: false, // Default closed based on UI
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget content,
    bool isExpanded = true,
  }) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: Colors.black.withValues(alpha: 0.10),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: ExpansionTile(
        initiallyExpanded: isExpanded,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        iconColor: const Color(0xFF0F0F0F),
        collapsedIconColor: const Color(0xFF0F0F0F),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF0F0F0F),
            fontSize: 16,
            fontFamily: 'Archivo',
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [Align(alignment: Alignment.centerLeft, child: content)],
      ),
    );
  }
}
