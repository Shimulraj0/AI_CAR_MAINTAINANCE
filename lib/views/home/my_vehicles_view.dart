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

        final homeController = Get.find<HomeController>();

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
                    final vehicleId =
                        vehicle['id']?.toString() ??
                        vehicle['uuid']?.toString() ??
                        '';
                    final isActive =
                        homeController.activeVehicleId.value == vehicleId;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: InkWell(
                        onTap: () => homeController.selectVehicle(vehicle),
                        borderRadius: BorderRadius.circular(16),
                        child: isActive
                            ? _buildActiveVehicleCard(vehicle)
                            : _buildSecondaryVehicleCard(vehicle),
                      ),
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

  Widget _buildActiveVehicleCard(dynamic vehicle) {
    final title =
        '${vehicle['year']} ${vehicle['manufacturer']} ${vehicle['model']}';
    final subtitle = '${vehicle['fuel_type']} · ${vehicle['engine_size']}';
    final status =
        vehicle['status']?.toString().replaceAll('_', ' ') ?? 'Due soon';
    final statusColor = status.toLowerCase() == 'up to date'
        ? const Color(0xFF059669)
        : const Color(0xFFD97706);
    final statusBgColor = status.toLowerCase() == 'up to date'
        ? const Color(0xFFECFDF5)
        : const Color(0xFFFFF7ED);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2F5EA8), width: 0.8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x192F5EA8),
            blurRadius: 4,
            offset: Offset(0, 2),
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
                    color: const Color(0xFFEDF2F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.directions_car_outlined,
                    color: Color(0xFF2F5EA8),
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
                          color: Color(0xFF1A1D23),
                          fontSize: 16,
                          fontFamily: 'Archivo',
                          fontWeight: FontWeight.w600,
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
                    InkWell(
                      onTap: () => _showStatusPicker(Get.context!, vehicle),
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusBgColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
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
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: const Text(
              'Active vehicle',
              style: TextStyle(
                color: Color(0xFF2F5EA8),
                fontSize: 13,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryVehicleCard(dynamic vehicle) {
    final title =
        '${vehicle['year']} ${vehicle['manufacturer']} ${vehicle['model']}';
    final subtitle = '${vehicle['fuel_type']} · ${vehicle['engine_size']}';
    final status =
        vehicle['status']?.toString().replaceAll('_', ' ') ?? 'Up to date';
    final statusColor = status.toLowerCase() == 'up to date'
        ? const Color(0xFF059669)
        : const Color(0xFFD97706);
    final statusBgColor = status.toLowerCase() == 'up to date'
        ? const Color(0xFFECFDF5)
        : const Color(0xFFFFF7ED);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.06),
          width: 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFEDF2F9),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.directions_car_outlined,
                color: Color(0xFF2F5EA8),
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
                      color: Color(0xFF1A1D23),
                      fontSize: 16,
                      fontFamily: 'Archivo',
                      fontWeight: FontWeight.w600,
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
                InkWell(
                  onTap: () => _showStatusPicker(Get.context!, vehicle),
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
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
    );
  }

  void _showStatusPicker(BuildContext context, dynamic vehicle) {
    final vehicleId =
        vehicle['id']?.toString() ?? vehicle['uuid']?.toString() ?? '';
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Update Vehicle Status',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Archivo',
              ),
            ),
            const SizedBox(height: 16),
            _buildStatusOption(
              'Up to date',
              Icons.check_circle_outline,
              Colors.green,
              () {
                controller.updateStatus(vehicleId, 'up_to_date');
                Get.back();
              },
            ),
            _buildStatusOption(
              'Due soon',
              Icons.access_time,
              Colors.orange,
              () {
                controller.updateStatus(vehicleId, 'due_soon');
                Get.back();
              },
            ),
            _buildStatusOption(
              'Overdue',
              Icons.warning_amber_outlined,
              Colors.red,
              () {
                controller.updateStatus(vehicleId, 'overdue');
                Get.back();
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOption(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: const TextStyle(fontSize: 16, fontFamily: 'Inter'),
      ),
      onTap: onTap,
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
