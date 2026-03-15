import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/my_vehicles_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_bottom_nav_bar.dart';

class MyVehiclesView extends GetView<MyVehiclesController> {
  const MyVehiclesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          color: const Color(0xFF2B63A8),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 16,
            bottom: 16,
            left: 26,
            right: 26,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => Get.back(),
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
              const Text(
                'My Vehicles',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Archivo',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 24), // Balance the back button
            ],
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF2F5EA8)),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
            child: Column(
              children: [
                if (controller.vehicles.isEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      'No vehicles registered yet.',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 16,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ] else ...[
                  ...controller.vehicles.map((vehicle) {
                    final vehicleId = vehicle['id']?.toString() ?? '';
                    final isSelected =
                        controller.selectedVehicleId.value == vehicleId;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildAnimatedVehicleCard(vehicle, isSelected),
                    );
                  }),
                ],
                const SizedBox(height: 16),
                _buildAddVehicleButton(),
                const SizedBox(height: 100), // Space for bottom nav
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3, // Profile Tab index
        onTap: (index) {
          if (Get.isRegistered<HomeController>()) {
            Get.find<HomeController>().changeTabIndex(index);
          }
          Get.offAllNamed(Routes.home);
        },
        onFabTap: () {
          Get.offAllNamed(Routes.home);
          Get.toNamed(Routes.aiChat);
        },
      ),
    );
  }

  Widget _buildAnimatedVehicleCard(dynamic vehicle, bool isSelected) {
    final title =
        '${vehicle['year']} ${vehicle['manufacturer']} ${vehicle['model']}';
    final subtitle = '${vehicle['fuel_type']} · ${vehicle['engine_size']}';
    final vehicleId = vehicle['id']?.toString() ?? '';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => controller.selectVehicle(vehicleId),
        child: AnimatedScale(
          scale: isSelected ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF2F5EA8)
                    : Colors.black.withValues(alpha: 0.06),
                width: isSelected ? 1.5 : 0.8,
              ),
              boxShadow: isSelected
                  ? [
                      const BoxShadow(
                        color: Color(0x192F5EA8),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFEDF2F9)
                              : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.directions_car_outlined,
                          color: isSelected
                              ? const Color(0xFF2F5EA8)
                              : const Color(0xFF9CA3AF),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                color: const Color(0xFF1A1D23),
                                fontSize: 16,
                                fontFamily: 'Archivo',
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subtitle,
                              style: const TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 13,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          if (isSelected)
                            const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Icon(
                                Icons.check_circle,
                                color: Color(0xFF2F5EA8),
                                size: 20,
                              ),
                            ),
                          InkWell(
                            onTap: () async {
                              final result = await Get.toNamed(
                                Routes.addVehicles,
                                arguments: {'vehicle': vehicle},
                              );
                              if (result == true) {
                                controller.fetchVehicles();
                              }
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.edit_outlined,
                                size: 16,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isSelected) ...[
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.stars_rounded,
                          size: 14,
                          color: Color(0xFF2F5EA8),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Primary vehicle',
                          style: TextStyle(
                            color: Color(0xFF2F5EA8),
                            fontSize: 13,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddVehicleButton() {
    return InkWell(
      onTap: () => Get.toNamed(Routes.addVehicles),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x4C2F5EA8), width: 0.8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, color: Color(0xFF2F5EA8), size: 20),
            const SizedBox(width: 8),
            const Text(
              'Add Vehicle',
              style: TextStyle(
                color: Color(0xFF2F5EA8),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
