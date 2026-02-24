import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/notifications_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_bottom_nav_bar.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

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
          'Notifications',
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
          children: [
            _buildNotificationCard(
              iconBgColor: const Color(0xFFFFF7ED),
              iconAsset: 'assets/images/wrench.png',
              iconData: Icons.build_outlined, // Fallback
              iconColor: const Color(0xFFD97706),
              title: 'Maintenance Due Soon',
              isUnread: true,
              description:
                  'Tire rotation for your 2021 Toyota Camry is due on Feb 20.',
              date: 'Feb 10',
            ),
            const SizedBox(height: 12),
            _buildNotificationCard(
              iconBgColor: const Color(0xFFFFF7ED),
              iconData: Icons.build_outlined, // Fallback
              iconColor: const Color(0xFFD97706),
              title: 'Brake Inspection Overdue',
              isUnread: true,
              description:
                  'Your brake inspection was due on Jan 10. Schedule service soon.',
              date: 'Feb 5',
            ),
            const SizedBox(height: 12),
            _buildNotificationCard(
              iconBgColor: const Color(0xFFEDF2F9),
              iconData: Icons.warning_amber_rounded, // Fallback
              iconColor: const Color(0xFF2B63A8),
              title: 'Diagnostic Report Saved',
              isUnread: false,
              description:
                  'Your diagnostic report for P0300/P0171 has been saved.',
              date: 'Feb 1',
            ),
            const SizedBox(height: 12),
            _buildNotificationCard(
              iconBgColor: const Color(0xFFF3F4F6),
              iconData: Icons.info_outline_rounded, // Fallback
              iconColor: const Color(0xFF6B7280),
              title: 'App Update Available',
              isUnread: false,
              description: 'Version 2.1 includes improved diagnostic accuracy.',
              date: 'Jan 28',
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

  Widget _buildNotificationCard({
    required Color iconBgColor,
    String? iconAsset,
    required IconData iconData,
    required Color iconColor,
    required String title,
    required bool isUnread,
    required String description,
    required String date,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 0.80,
            color: isUnread
                ? const Color(0x332F5EA8)
                : Colors.black.withValues(alpha: 0.06),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: ShapeDecoration(
              color: iconBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Center(child: Icon(iconData, size: 18, color: iconColor)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: const Color(0xFF1A1D23),
                          fontSize: 14,
                          fontFamily: 'Archivo',
                          fontWeight: isUnread
                              ? FontWeight.w600
                              : FontWeight.w500,
                          height: 1.50,
                        ),
                      ),
                    ),
                    if (isUnread) ...[
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const ShapeDecoration(
                          color: Color(0xFF2F5EA8),
                          shape: OvalBorder(),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 13,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.40,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 11,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
