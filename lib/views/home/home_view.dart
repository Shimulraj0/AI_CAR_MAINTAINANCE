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
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        appBar: controller.currentIndex.value == 0 
          ? AppBar(
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
            )
          : controller.currentIndex.value == 1
              ? AppBar(
                  title: const Text(
                    'Diagnose',
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
                  automaticallyImplyLeading: false,
                )
              : controller.currentIndex.value == 2
                  ? AppBar(
                      title: const Text(
                        'Maintenance',
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
                      automaticallyImplyLeading: false,
                    )
                  : controller.currentIndex.value == 3
                      ? AppBar(
                          title: const Text(
                            'Profile',
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
                          automaticallyImplyLeading: false,
                        )
                      : null,
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: [
            SingleChildScrollView(
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
                              Text(
                                'Welcome Back, ${controller.userName.value}',
                                style: const TextStyle(
                                  color: Color(0xFF0F0F0F),
                                  fontSize: 18,
                                  fontFamily: 'Archivo',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Add other HomeView specific content here
                      ],
                    ),
                  ),
                  // Placeholder for dynamic content
                ],
              ),
            ),
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
}
