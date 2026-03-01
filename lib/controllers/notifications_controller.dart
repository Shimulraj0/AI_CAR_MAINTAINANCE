import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/notification_model.dart';

class NotificationsController extends GetxController {
  final RxList<NotificationModel> notifications = <NotificationModel>[
    NotificationModel(
      id: '1',
      title: 'Maintenance Due Soon',
      description: 'Tire rotation for your 2021 Toyota Camry is due on Feb 20.',
      date: 'Feb 10',
      isUnread: true,
      iconData: Icons.build_outlined,
      iconColor: const Color(0xFFD97706),
      iconBgColor: const Color(0xFFFFF7ED),
    ),
    NotificationModel(
      id: '2',
      title: 'Brake Inspection Overdue',
      description:
          'Your brake inspection was due on Jan 10. Schedule service soon.',
      date: 'Feb 5',
      isUnread: true,
      iconData: Icons.build_outlined,
      iconColor: const Color(0xFFD97706),
      iconBgColor: const Color(0xFFFFF7ED),
    ),
    NotificationModel(
      id: '3',
      title: 'Diagnostic Report Saved',
      description: 'Your diagnostic report for P0300/P0171 has been saved.',
      date: 'Feb 1',
      isUnread: false,
      iconData: Icons.warning_amber_rounded,
      iconColor: const Color(0xFF2B63A8),
      iconBgColor: const Color(0xFFEDF2F9),
    ),
    NotificationModel(
      id: '4',
      title: 'App Update Available',
      description: 'Version 2.1 includes improved diagnostic accuracy.',
      date: 'Jan 28',
      isUnread: false,
      iconData: Icons.info_outline_rounded,
      iconColor: const Color(0xFF6B7280),
      iconBgColor: const Color(0xFFF3F4F6),
    ),
  ].obs;

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index].isUnread = false;
      notifications.refresh();
    }
  }

  void deleteNotification(String id) {
    notifications.removeWhere((n) => n.id == id);
  }
}
