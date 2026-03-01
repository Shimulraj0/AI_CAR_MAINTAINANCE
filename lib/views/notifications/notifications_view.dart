import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/notifications_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../models/notification_model.dart';

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
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off_outlined,
                  size: 64,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'No notifications yet',
                  style: TextStyle(color: Colors.grey[500], fontSize: 16),
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
          itemCount: controller.notifications.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            return Dismissible(
              key: Key(notification.id),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                controller.deleteNotification(notification.id);
                Get.snackbar(
                  'Deleted',
                  'Notification removed',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 1),
                );
              },
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                ),
              ),
              child: GestureDetector(
                onTap: () => controller.markAsRead(notification.id),
                child: _buildNotificationCard(notification),
              ),
            );
          },
        );
      }),
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

  Widget _buildNotificationCard(NotificationModel notification) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 0.80,
            color: notification.isUnread
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
              color: notification.iconBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Center(
              child: Icon(
                notification.iconData,
                size: 18,
                color: notification.iconColor,
              ),
            ),
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
                        notification.title,
                        style: TextStyle(
                          color: const Color(0xFF1A1D23),
                          fontSize: 14,
                          fontFamily: 'Archivo',
                          fontWeight: notification.isUnread
                              ? FontWeight.w600
                              : FontWeight.w500,
                          height: 1.50,
                        ),
                      ),
                    ),
                    if (notification.isUnread) ...[
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
                  notification.description,
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
                  notification.date,
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
