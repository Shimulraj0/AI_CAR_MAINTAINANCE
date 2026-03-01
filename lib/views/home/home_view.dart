import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../controllers/home_controller.dart';
import 'diagnose_tab_view.dart';
import 'maintenance_tab_view.dart';
import 'profile_tab_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: const Text(
                  'Home',
                  style: TextStyle(
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
                actions: [
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
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header Section
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Welcome Back, Mugdho',
                                  style: TextStyle(
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
                                    const Text(
                                      'Toyota Corolla 2020',
                                      style: TextStyle(
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
                                  height: 220,
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
                                      image: AssetImage(
                                        'assets/images/new_car.png',
                                      ),
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
                                          height: 48,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (Get.isRegistered<
                                                HomeController
                                              >()) {
                                                Get.find<HomeController>()
                                                    .changeTabIndex(
                                                      1,
                                                      autoStart: true,
                                                    );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF3866A1,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
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
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          InkWell(
                            onTap: () {
                              Get.snackbar(
                                'Active Issues',
                                'Viewing active issues report...',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
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
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        color: Color(0xFFFF6900),
                                        width: 4,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFFFF7ED),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.warning_amber_rounded,
                                              color: Color(0xFFFF6900),
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'O2 Sensor Slow Response',
                                                  style: TextStyle(
                                                    color: Color(0xFF0F0F0F),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    fontFamily: 'Inter',
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'MODERATE • Detected 2023-10-10',
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
                                          const SizedBox(
                                            width: 52,
                                          ), // Align with text
                                          SizedBox(
                                            height: 36,
                                            child: OutlinedButton(
                                              onPressed: () {
                                                Get.snackbar(
                                                  'Schedule Service',
                                                  'Redirecting to service scheduling...',
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                );
                                              },
                                              style: OutlinedButton.styleFrom(
                                                side: const BorderSide(
                                                  color: Color(0xFFE0E0E0),
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              child: const Text(
                                                'Schedule Service',
                                                style: TextStyle(
                                                  color: Color(0xFF0F0F0F),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          TextButton(
                                            onPressed: () {
                                              Get.toNamed(Routes.aiChat);
                                            },
                                            child: const Text(
                                              'Ask AI',
                                              style: TextStyle(
                                                color: Color(0xFF2B63A8),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
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
                          ),

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
                                  Get.snackbar(
                                    'View All',
                                    'Loading all upcoming services...',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
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
                          _buildServiceItem(
                            day: '1',
                            month: 'OCT',
                            title: 'Oil Change',
                            subtitle: 'Overdue • 48,000 mi',
                            statusType: 'overdue',
                          ),
                          const SizedBox(height: 12),
                          _buildServiceItem(
                            day: '15',
                            month: 'NOV',
                            title: 'Brake Inspection',
                            subtitle: 'Upcoming • 50,000 mi',
                            statusType: 'upcoming',
                          ),
                          const SizedBox(height: 80), // Space for bottom nav
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const DiagnoseTabView(),
            const MaintenanceTabView(), // Third tab
            const ProfileTabView(), // Fourth tab (Profile)
          ],
        ),
      ),
      // Custom Animated Bottom Navigation Bar
      bottomNavigationBar: Obx(
        () => CustomBottomNavBar(
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

  Widget _buildServiceItem({
    required String day,
    required String month,
    required String title,
    required String subtitle,
    required String statusType,
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
        Get.snackbar(
          title,
          'Viewing details for $title...',
          snackPosition: SnackPosition.BOTTOM,
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
              child: Column(
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
