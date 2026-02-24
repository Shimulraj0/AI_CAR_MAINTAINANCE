import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../routes/app_routes.dart';

class TaskDetailsView extends GetView<HomeController> {
  const TaskDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final status = args['status'] as String? ?? 'UPCOMING';
    final title = args['title'] as String? ?? 'Brake Inspection';
    final date = args['date'] as String? ?? '11/15/2023';
    final mileage = args['mileage'] as String? ?? '50,000 mi';
    final notes =
        args['notes'] as String? ??
        'No additional notes provided for this task.';

    final bool isOverdue = status == 'OVERDUE';

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
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 16),
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Task Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Archivo',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 26,
                right: 26,
                top: 16,
                bottom: 24,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x19000000),
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: ShapeDecoration(
                        color: isOverdue
                            ? const Color(0xFFFFE2E2)
                            : const Color(0xFFDBEAFE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: isOverdue
                              ? const Color(0xFFE7000B)
                              : const Color(0xFF155DFC),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF0F172B),
                        fontSize: 24,
                        fontFamily: 'Archivo',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildDetailRow(
                      Icons.calendar_today_outlined,
                      'Due Date',
                      date,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      Icons.access_time_outlined,
                      'Mileage Interval',
                      mileage,
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: Color(0xFFF1F5F9), thickness: 1),
                    const SizedBox(height: 12),
                    Text(
                      notes,
                      style: const TextStyle(
                        color: Color(0xFF62748E),
                        fontSize: 14,
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 26, right: 26, bottom: 24),
            decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
            child: Column(
              children: [
                _buildActionButton(
                  icon: Icons.check_circle_outline,
                  label: 'Mark as Completed',
                  backgroundColor: const Color(0xFF2F5EA8),
                  textColor: Colors.white,
                  onTap: () {
                    // Handle complete action
                  },
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  icon: Icons.delete_outline,
                  label: 'Delete Task',
                  backgroundColor: Colors.white,
                  textColor: const Color(0xFF314158),
                  borderColor: const Color(0xFFE2E8F0),
                  onTap: () {
                    // Handle delete action
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2, // Maintenance Tab index
        onTap: (index) {
          controller.changeTabIndex(index);
          Get.offAllNamed(Routes.home); // Go back home and switch tab
        },
        onFabTap: () {
          Get.offAllNamed(Routes.home); // Ensuring stack resets
          Get.toNamed(Routes.aiChat);
        },
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF90A1B9)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF90A1B9),
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF62748E),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            side: borderColor != null
                ? BorderSide(width: 1.60, color: borderColor)
                : BorderSide.none,
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: borderColor == null
                    ? FontWeight.w500
                    : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
