import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final String title;
  final String description;
  final String date;
  bool isUnread;
  final IconData iconData;
  final Color iconColor;
  final Color iconBgColor;
  final String? iconAsset;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.isUnread = true,
    required this.iconData,
    required this.iconColor,
    required this.iconBgColor,
    this.iconAsset,
  });
}
