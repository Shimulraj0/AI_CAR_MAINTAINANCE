import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../routes/app_routes.dart';

class AddMaintenanceView extends GetView<HomeController> {
  const AddMaintenanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
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
          'Add Maintenance',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Archivo',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 26,
          right: 26,
          top: 16,
          bottom: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField('Service Type', hintText: ''),
            const SizedBox(height: 16),
            _buildInputField('Date', hintText: 'YYYY-MM-DD'),
            const SizedBox(height: 16),
            _buildInputField('Mileage', hintText: 'Current mileage'),
            const SizedBox(height: 16),
            _buildInputField(
              'Notes(optional)',
              hintText: 'Additional notes...',
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            _buildInputField('Next Due Date', hintText: 'YYYY-MM-DD'),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle save action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFF8FB1D6,
                  ), // Disabled looking blue from design
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Save Service Record',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2, // Originating from Maintenance view
        onTap: (index) {
          controller.changeTabIndex(index);
          Get.offAllNamed(Routes.home);
        },
        onFabTap: () {
          Get.offAllNamed(Routes.home);
          Get.toNamed(Routes.aiChat);
        },
      ),
    );
  }

  Widget _buildInputField(
    String label, {
    required String hintText,
    int maxLines = 1,
  }) {
    // Handling the rich text for 'Notes(optional)'
    Widget labelWidget;
    if (label == 'Notes(optional)') {
      labelWidget = const Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Notes',
              style: TextStyle(
                color: Color(0xFF0A0A0A),
                fontSize: 14,
                fontFamily: 'Archivo',
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: '(optional)',
              style: TextStyle(
                color: Color(0xFF949CA9),
                fontSize: 14,
                fontFamily: 'Archivo',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    } else {
      labelWidget = Text(
        label,
        style: const TextStyle(
          color: Color(0xFF0A0A0A),
          fontSize: 14,
          fontFamily: 'Archivo',
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelWidget,
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: const Color(0xFFF3F4F6),
            contentPadding: const EdgeInsets.all(12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.black.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2B63A8), width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
