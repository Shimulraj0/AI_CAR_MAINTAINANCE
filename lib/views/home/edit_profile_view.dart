import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/edit_profile_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_bottom_nav_bar.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the editing controller
    Get.put(EditProfileController());

    // We still need the HomeController for bottom nav navigation
    final homeController = Get.find<HomeController>();

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
                'Edit Profile',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            _buildProfileImage(),
            const SizedBox(height: 32),
            _buildInputField(
              'Full Name',
              controller.nameController,
              TextInputType.name,
            ),
            const SizedBox(height: 20),
            _buildInputField(
              'Email',
              controller.emailController,
              TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            _buildInputField(
              'Phone',
              controller.phoneController,
              TextInputType.phone,
            ),
            const SizedBox(height: 48),
            _buildSaveButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3, // Profile Tab index
        onTap: (index) {
          homeController.changeTabIndex(index);
          Get.offAllNamed(Routes.home);
        },
        onFabTap: () {
          Get.offAllNamed(Routes.home);
          Get.toNamed(Routes.aiChat);
        },
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: GestureDetector(
        onTap: () => controller.pickImage(),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Obx(
              () => Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: controller.pickedImagePath.value.isNotEmpty
                        ? FileImage(File(controller.pickedImagePath.value))
                              as ImageProvider
                        : const AssetImage('assets/images/profile.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              width: 26,
              height: 26,
              margin: const EdgeInsets.only(bottom: 2, right: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.10),
                  width: 0.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.edit_outlined,
                  size: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController textController,
    TextInputType keyboardType,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF374151),
              fontSize: 14,
              fontFamily: 'Archivo',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: TextField(
              controller: textController,
              keyboardType: keyboardType,
              style: const TextStyle(
                color: Color(0xFF0F0F0F),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: InkWell(
        onTap: () {
          // Handle Save
          controller.saveChanges();
          Future.delayed(const Duration(milliseconds: 1500), () {
            Get.back();
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF2B63A8),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: const Text(
            'Save Changes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
