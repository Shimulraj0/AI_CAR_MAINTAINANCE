import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/vehicle_registration_controller.dart';

class VehicleRegistrationView extends GetView<VehicleRegistrationController> {
  const VehicleRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is registered if not using bindings
    if (!Get.isRegistered<VehicleRegistrationController>()) {
      Get.put(VehicleRegistrationController());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                _buildInputField(
                  label: 'Manufacturer',
                  hintText: 'Enter Vehicle Manufacturer',
                  controller: controller.manufacturerController,
                  icon: Icons.build_circle_outlined, // Placeholder icon
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: 'Vehicle Model',
                  hintText: 'Enter Vehicle Model',
                  controller: controller.modelController,
                  icon: Icons.directions_car_outlined,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: 'Vehicle Year',
                  hintText: 'Enter Vehicle Year',
                  controller: controller.yearController,
                  icon: Icons.calendar_today_outlined,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: 'Fuel Type',
                  hintText: 'Enter Fuel Type',
                  controller: controller.fuelTypeController,
                  icon: Icons.local_gas_station_outlined,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: 'Engine Size',
                  hintText: 'Enter Engine Size',
                  controller: controller.engineSizeController,
                  icon: Icons.settings_outlined, // Placeholder
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: 'VIN/Registration',
                  hintText: 'Enter VIN or Registration',
                  controller: controller.vinController,
                  icon: Icons.confirmation_number_outlined,
                  isOptional: true,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  label: 'Diagnostic Codes',
                  hintText: 'Enter Diagnostic Codes',
                  controller: controller.diagnosticCodesController,
                  icon: Icons.bug_report_outlined,
                  isOptional: true,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: controller.saveVehicle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.isFormValid.value
                            ? const Color(0xFF2B63A8)
                            : const Color(0xFF95B1D3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Save Vehicle',
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
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required IconData icon,
    bool isOptional = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: Colors.black.withValues(alpha: 0.04),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 24, color: const Color(0xFF0F0F0F)),
                  const SizedBox(width: 4),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '$label ',
                          style: const TextStyle(
                            color: Color(0xFF0A0A0A),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (isOptional)
                          TextSpan(
                            text: '(Optional)',
                            style: TextStyle(
                              color: Colors.black.withValues(alpha: 0.50),
                              fontSize: 10,
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.only(left: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: ShapeDecoration(
                    color: const Color(0x192B63A8),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.50,
                        color: Colors.black.withValues(alpha: 0.06),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: TextFormField(
                    controller: controller,
                    keyboardType: keyboardType,
                    style: const TextStyle(fontSize: 12, fontFamily: 'Inter'),
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: const TextStyle(
                        color: Color(0xFF949CA9),
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(bottom: 12),
                    ),
                    validator: isOptional
                        ? null
                        : (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
