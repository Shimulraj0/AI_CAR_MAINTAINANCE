import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../controllers/home_controller.dart';
import 'diagnose_tab_view.dart';
import 'maintenance_tab_view.dart';
import 'profile_tab_view.dart';
import '../../utils/responsive_helper.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(controller.currentIndex.value),
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: [
            _buildHomeContent(context),
            const DiagnoseTabView(),
            const MaintenanceTabView(),
            const ProfileTabView(),
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: controller.currentIndex.value,
          onTap: (index) {
            controller.changeTabIndex(index);
          },
          onFabTap: () {
            Get.toNamed(Routes.aiChat);
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(int index) {
    String title = '';
    Widget? leading;
    List<Widget>? actions;

    switch (index) {
      case 0:
        title = 'Home';
        leading = null;
        actions = [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              child: Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      Get.toNamed(Routes.notifications);
                    },
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF2B63A8),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
        break;
      case 1:
        title = 'Diagnose';
        leading = _buildBackLeading();
        break;
      case 2:
        title = 'Maintenance';
        leading = _buildBackLeading();
        actions = [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFFEDF2F9),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.add, color: Color(0xFF2B63A8), size: 20),
                onPressed: () {
                  Get.toNamed(Routes.addMaintenance);
                },
              ),
            ),
          ),
        ];
        break;
      case 3:
        title = 'Profile';
        leading = _buildBackLeading();
        break;
    }

    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontFamily: 'Archivo',
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFF2B63A8),
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      toolbarHeight: kToolbarHeight,
      automaticallyImplyLeading: false,
      leading: leading,
      actions: actions,
    );
  }

  Widget _buildBackLeading() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(left: 16),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
          onPressed: () {
            controller.changeTabIndex(0);
          },
        ),
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.only(bottom: context.h(24)),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: context.w(24)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back, ${controller.userName.value}',
                        style: const TextStyle(
                          color: Color(0xFF0F0F0F),
                          fontSize: 20,
                          fontFamily: 'Archivo',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.directions_car, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            controller.vehicleName.value,
                            style: const TextStyle(
                              color: Color(0xFF0F0F0F),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        height: context.h(220),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF2B63A8,
                              ).withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          image: const DecorationImage(
                            image: AssetImage('assets/images/new_car.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 12,
                              left: 16,
                              right: 16,
                              child: SizedBox(
                                width: double.infinity,
                                height: context.h(48),
                                child: ElevatedButton(
                                  onPressed: () {
                                    controller.changeTabIndex(
                                      1,
                                      autoStart: true,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF3866A1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Quick Analyze',
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
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Active Issues Section
          Obx(() => Padding(
                padding: EdgeInsets.all(context.w(24.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.overdueTasks.isNotEmpty ||
                        controller.lastSessionId.value.isNotEmpty) ...[
                      const Text(
                        'Active Issues',
                        style: TextStyle(
                          color: Color(0xFF0F0F0F),
                          fontSize: 18,
                          fontFamily: 'Archivo',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildActiveIssueCard(context),
                    ],
                    const SizedBox(height: 32),

                    // Upcoming Service Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Upcoming Service',
                          style: TextStyle(
                            color: Color(0xFF0F0F0F),
                            fontSize: 18,
                            fontFamily: 'Archivo',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            controller.changeTabIndex(2); // Switch to Maintenance Tab
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'View All',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Color(0xFF2B63A8),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (controller.upcomingTasks.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'No upcoming maintenance scheduled',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      ...controller.upcomingTasks.take(3).map((task) {
                        final String nextDate = task['next_due_date']?.toString() ?? task['due_date']?.toString() ?? '';
                        final DateTime? parsedDate = nextDate.isNotEmpty ? DateTime.tryParse(nextDate) : null;
                        
                        final String day = parsedDate?.day.toString() ?? '0';
                        final String month = parsedDate != null ? _getMonthName(parsedDate.month) : 'JAN';

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _buildServiceItem(
                            day: day,
                            month: month,
                            id: task['id']?.toString() ?? task['uuid']?.toString() ?? '',
                            title: task['service_type'] ??
                                task['service type'] ??
                                task['task_type'] ??
                                task['title'] ??
                                'Maintenance',
                            subtitle: (task['mileage'] ?? task['Mileage']) != null
                                ? 'Due at ${task['mileage'] ?? task['Mileage']} mi'
                                : 'Upcoming',
                            statusType: 'upcoming',
                            notes: task['notes'],
                            date: task['next_due_date']?.toString() ?? task['due_date']?.toString(),
                          ),
                        );
                      }),
                    const SizedBox(height: 80), // Space for bottom nav
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildActiveIssueCard(BuildContext context) {
    // If there's an overdue task, prioritize it
    if (controller.overdueTasks.isNotEmpty) {
      final task = controller.overdueTasks.first;
      return _buildIssueCard(
        context,
        title: task['service_type'] ?? task['service type'] ?? task['task_type'] ?? task['title'] ?? 'Overdue Maintenance',
        subtitle: 'OVERDUE ${ (task['mileage'] ?? task['Mileage']) != null ? '• ${task['mileage'] ?? task['Mileage']} mi' : ''}',
        isOverdue: true,
        onTap: () {
          Get.toNamed(
            '/task-details',
            arguments: {
              'id': task['id']?.toString() ?? task['uuid']?.toString() ?? '',
              'status': 'OVERDUE',
              'title': task['service_type'] ?? task['service type'] ?? task['task_type'] ?? task['title'] ?? 'Overdue Maintenance',
              'date': task['next_due_date']?.toString() ?? task['due_date']?.toString() ?? 'N/A',
              'mileage': '${task['mileage'] ?? task['Mileage'] ?? "N/A"} mi',
              'notes': task['notes'] ?? 'No notes provided.',
            },
          );
        },
        buttonLabel: 'Schedule Service',
        onButtonTap: () {
          Get.toNamed(Routes.addMaintenance);
        },
      );
    }

    // Otherwise, show the latest diagnostic link if available
    if (controller.lastSessionId.value.isNotEmpty) {
      return _buildIssueCard(
        context,
        title: 'Recent Diagnostic Available',
        subtitle: 'View your last vehicle checkup',
        onTap: () {
          Get.toNamed(
            Routes.diagnosticResult,
            arguments: {
              'diagnostic_id': controller.lastSessionId.value,
            },
          );
        },
        buttonLabel: 'View Results',
        onButtonTap: () {
          Get.toNamed(
            Routes.diagnosticResult,
            arguments: {
              'diagnostic_id': controller.lastSessionId.value,
            },
          );
        },
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildIssueCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required String buttonLabel,
    required VoidCallback onButtonTap,
    bool isOverdue = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(context.w(12)),
          child: Container(
            padding: EdgeInsets.all(context.w(16)),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: isOverdue ? const Color(0xFFFF6900) : const Color(0xFF2B63A8),
                  width: 4,
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(context.w(8)),
                      decoration: BoxDecoration(
                        color: isOverdue ? const Color(0xFFFFF7ED) : const Color(0xFFEFF6FF),
                        shape: BoxShape.circle,
                      ),
                      child: isOverdue
                          ? Image.asset(
                              'assets/images/cautions.png',
                              width: context.w(24),
                              height: context.w(24),
                            )
                          : const Icon(
                              Icons.info_outline,
                              color: Color(0xFF2B63A8),
                              size: 24,
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Color(0xFF0F0F0F),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const SizedBox(width: 52), // Align with text
                    SizedBox(
                      height: 36,
                      child: OutlinedButton(
                        onPressed: onButtonTap,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          buttonLabel,
                          style: const TextStyle(
                            color: Color(0xFF0F0F0F),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];
    if (month >= 1 && month <= 12) {
      return months[month - 1];
    }
    return 'JAN';
  }

  Widget _buildServiceItem({
    required String day,
    required String month,
    required String title,
    required String subtitle,
    required String statusType,
    required String id,
    String? notes,
    String? date,
  }) {
    final isOverdue = statusType == 'overdue';
    final primaryColor = isOverdue
        ? const Color(0xFFDC2626)
        : const Color(0xFF2B63A8);
    final bgColor = isOverdue
        ? const Color(0xFFFEF2F2)
        : const Color(0xFFEFF6FF);

    return InkWell(
      onTap: () {
        Get.toNamed(
          '/task-details', // Or Routes.taskDetails if available
          arguments: {
            'id': id,
            'status': statusType.toUpperCase(),
            'title': title,
            'date': date ?? '$month $day',
            'mileage': subtitle.replaceAll('Due at ', ''),
            'notes': notes ?? 'No additional notes provided.',
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEFEFEF)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
                child: isOverdue 
                    ? Center(
                        child: Image.asset(
                          'assets/images/cautions.png',
                          width: 32,
                          height: 32,
                          fit: BoxFit.contain,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            day,
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            month,
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF0F0F0F),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isOverdue
                          ? const Color(0xFFDC2626)
                          : Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFBDBDBD)),
          ],
        ),
      ),
    );
  }
}
