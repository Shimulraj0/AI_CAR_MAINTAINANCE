import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/privacy_terms_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_bottom_nav_bar.dart';

class PrivacyTermsView extends GetView<PrivacyTermsController> {
  const PrivacyTermsView({super.key});

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
          'Privacy & Terms',
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
          top: 24,
          bottom: 24,
        ),
        child: Column(
          children: [
            _buildListItem(
              title: 'Privacy Policy',
              onTap: () {
                Get.toNamed(Routes.privacyPolicy);
              },
            ),
            const SizedBox(height: 16),
            _buildListItem(
              title: 'Terms & Conditions',
              onTap: () {
                Get.toNamed(Routes.termsConditions);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3, // Profile Tab index
        onTap: (index) {
          Get.offAllNamed(Routes.home); // Go back home and switch tab
        },
        onFabTap: () {
          Get.offAllNamed(Routes.home); // Ensuring stack resets
          Get.toNamed(Routes.aiChat);
        },
      ),
    );
  }

  Widget _buildListItem({required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: const Color(0xFFF3F7FF),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const ShapeDecoration(
                    color: Color(0xFF0F0F0F),
                    shape: OvalBorder(),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF0F0F0F),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.20,
                  ),
                ),
              ],
            ),
            const Icon(Icons.chevron_right, size: 20, color: Color(0xFF0F0F0F)),
          ],
        ),
      ),
    );
  }
}
