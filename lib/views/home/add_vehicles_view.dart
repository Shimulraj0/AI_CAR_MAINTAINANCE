import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/vehicle_registration_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_bottom_nav_bar.dart';

class AddVehiclesView extends GetView<VehicleRegistrationController> {
  const AddVehiclesView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<VehicleRegistrationController>()) {
      Get.put(VehicleRegistrationController());
    }

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
              Text(
                controller.vehicleId != null ? 'Edit Vehicle' : 'Add Vehicle',
                style: const TextStyle(
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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 26,
              right: 26,
              top: 24,
              bottom: 120,
            ),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  _buildInputField(
                    icon: Icons.precision_manufacturing_outlined,
                    label: 'Manufacturer',
                    hint: 'Enter Vehicle Manufacturer',
                    txtController: controller.manufacturerController,
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    icon: Icons.directions_car_outlined,
                    label: 'Vehicle Model',
                    hint: 'Enter Vehicle Model',
                    txtController: controller.modelController,
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    icon: Icons.calendar_today_outlined,
                    label: 'Vehicle Year',
                    hint: 'Enter Vehicle Year',
                    txtController: controller.yearController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    icon: Icons.local_gas_station_outlined,
                    label: 'Fuel Type',
                    hint: 'Enter Fuel Type',
                    txtController: controller.fuelTypeController,
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    icon: Icons
                        .build_outlined, // Closer match since engineering is material icons
                    label: 'Engine Size',
                    hint: 'Enter Engine Size',
                    txtController: controller.engineSizeController,
                  ),
                  const SizedBox(height: 16),
                  _buildOptionalInputField(
                    icon: Icons
                        .person_outline, // Representing ownership/registration
                    label: 'VIN/Registration',
                    hint: 'Enter VIN or Registration',
                    txtController: controller.vinController,
                  ),
                  const SizedBox(height: 16),
                  _buildOptionalInputField(
                    icon: Icons.troubleshoot_outlined,
                    label: 'Diagonostic Codes',
                    hint: 'Enter Diagonostic Codes',
                    txtController: controller.diagnosticCodesController,
                  ),
                  const SizedBox(height: 32),
                  Obx(() => Opacity(
                    opacity: controller.isFormValid.value ? 1.0 : 0.50,
                    child: InkWell(
                      onTap: controller.isFormValid.value && !controller.isLoading.value 
                          ? controller.saveVehicle 
                          : null,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B63A8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20, width: 20, 
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                            )
                          : Text(
                          controller.vehicleId != null ? 'Update Vehicle' : 'Save Vehicle',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3, // Since it originates from Profile tree
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

  Widget _buildInputField({
    required IconData icon,
    required String label,
    required String hint,
    required TextEditingController txtController,
    TextInputType? keyboardType,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.04),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF0A0A0A)),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF0A0A0A),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 180,
            child: TextFormField(
              controller: txtController,
              keyboardType: keyboardType,
              style: const TextStyle(
                color: Color(0xFF0A0A0A),
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return ''; // Validation feedback shown by generic text coloring if needed, but visually we use isFormValid
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Color(0xFF949CA9),
                  fontSize: 11,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                fillColor: const Color(0x192B63A8),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.black.withValues(alpha: 0.06),
                    width: 0.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF2B63A8), width: 1),
                ),
                errorStyle: const TextStyle(height: 0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionalInputField({
    required IconData icon,
    required String label,
    required String hint,
    required TextEditingController txtController,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.04),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF0A0A0A)),
              const SizedBox(width: 8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$label ',
                      style: const TextStyle(
                        color: Color(0xFF0F0F0F),
                        fontSize: 12,
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: '(Optional)',
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.50),
                        fontSize: 11,
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: txtController,
            style: const TextStyle(
              color: Color(0xFF0A0A0A),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFF949CA9),
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              fillColor: const Color(0x192B63A8),
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.black.withValues(alpha: 0.06),
                  width: 0.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF2B63A8), width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
