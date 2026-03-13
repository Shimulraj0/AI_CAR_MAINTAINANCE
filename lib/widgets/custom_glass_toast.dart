import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomGlassToast {
  static void show({
    required String message,
    String? title,
    IconData icon = Icons.info_outline,
    Color iconColor = Colors.white,
    bool isError = true,
  }) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();

    Get.showSnackbar(
      GetSnackBar(
        titleText: title != null
            ? Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  fontFamily: 'Archivo',
                ),
              )
            : null,
        messageText: Text(
          message,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
        icon: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
            color: (isError ? Colors.red : const Color(0xFF2B63A8)).withValues(
              alpha: 0.2,
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: (isError ? Colors.red : const Color(0xFF2B63A8))
                  .withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Icon(
            isError ? Icons.error_outline_rounded : icon,
            color: isError ? const Color(0xFFFF5F5F) : iconColor,
            size: 22,
          ),
        ),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        borderRadius: 24,
        backgroundColor: Colors.white.withValues(alpha: 0.1),
        barBlur: 20,
        borderColor: Colors.white.withValues(alpha: 0.2),
        duration: const Duration(seconds: 4),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        boxShadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 40,
            spreadRadius: -10,
            offset: const Offset(0, -10),
          ),
        ],
        isDismissible: true,
        dismissDirection: DismissDirection.down,
        snackStyle: SnackStyle.FLOATING,
        forwardAnimationCurve: Curves.easeOutQuart,
      ),
    );
  }

  static void showInactiveUser() {
    show(
      title: 'User Inactive',
      message:
          'Your account is currently inactive. Please contact support for assistance.',
      icon: Icons.person_off_outlined,
      iconColor: const Color(0xFFFFD700), // Gold/Amber for status
      isError: true,
    );
  }
}
