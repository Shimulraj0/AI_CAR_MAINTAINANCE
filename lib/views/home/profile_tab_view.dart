import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../routes/app_routes.dart';
import 'package:animations/animations.dart';
import '../../utils/responsive_helper.dart';
import 'subscription_view.dart'; // Import the view directly for OpenContainer

class ProfileTabView extends GetView<HomeController> {
  const ProfileTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: ResponsiveHelper.paddingLarge,
        right: ResponsiveHelper.paddingLarge,
        top: 24,
        bottom: 24,
      ),
      child: Column(
        children: [
          _buildProfileCard(),
          const SizedBox(height: 24),
          _buildSubscriptionCard(),
          const SizedBox(height: 24),
          _buildMenuSection(),
          const SizedBox(height: 24),
          _buildLogoutButton(),
          const SizedBox(height: 120), // Space for bottom nav
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.06),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Obx(() => Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: controller.userProfileImage.value.isNotEmpty
                    ? NetworkImage(controller.userProfileImage.value)
                    : const AssetImage('assets/images/profile.png') as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          )),
          const SizedBox(width: 16),
          Expanded(
            child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.userName.value.isNotEmpty ? controller.userName.value : 'Loading...',
                  style: const TextStyle(
                    color: Color(0xFF1A1D23),
                    fontSize: 18,
                    fontFamily: 'Archivo',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.userEmail.value.isNotEmpty ? controller.userEmail.value : 'Loading...',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard() {
    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      openBuilder: (context, _) => SubscriptionView(),
      closedElevation: 0,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      closedColor: const Color(0xFFEDF2F9),
      closedBuilder: (context, openContainer) {
        return InkWell(
          onTap: openContainer,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEDF2F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x192F5EA8), width: 0.8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Plan',
                      style: TextStyle(
                        color: Color(0xFF2F5EA8),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Pro Plan',
                      style: TextStyle(
                        color: Color(0xFF2F5EA8),
                        fontSize: 18,
                        fontFamily: 'Archivo',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2F5EA8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Manage',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.06),
          width: 0.8,
        ),
      ),
      child: Column(
        children: [
          _buildMenuItem(
            'assets/images/editprofile.svg',
            'Edit Profile',
            onTap: () => Get.toNamed(Routes.editProfile),
          ),
          _buildDivider(),
          _buildMenuItem(
            'assets/images/Caricon.svg',
            'My Vehicles',
            onTap: () => Get.toNamed(Routes.myVehicles),
          ),
          _buildDivider(),
          _buildMenuItem(
            'assets/images/reports.svg',
            'Saved Reports',
            onTap: () => Get.toNamed(Routes.saveReports),
          ),
          _buildDivider(),
          _buildMenuItem(
            'assets/images/notification.svg',
            'Notifications',
            onTap: () => Get.toNamed(Routes.notifications),
          ),
          _buildDivider(),
          _buildMenuItem(
            Icons.credit_card_outlined,
            'Subscription',
            onTap: () => Get.toNamed(Routes.subscription),
          ),
          _buildDivider(),
          _buildMenuItem(
            Icons.shield_outlined,
            'Privacy & Terms',
            onTap: () => Get.toNamed(Routes.privacyTerms),
          ),
          _buildDivider(),
          _buildMenuItem(
            Icons.help_outline,
            'FAQs',
            onTap: () => Get.toNamed(Routes.faqs),
          ),
          _buildDivider(),
          _buildMenuItem(
            Icons.support_agent_outlined,
            'Contact Support',
            onTap: () => Get.toNamed(Routes.contactSupport),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    dynamic iconOrAsset,
    String title, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (iconOrAsset is String)
                  iconOrAsset.endsWith('.svg')
                      ? SvgPicture.asset(iconOrAsset, width: 22, height: 22)
                      : Image.asset(iconOrAsset, width: 20, height: 20)
                else if (iconOrAsset is IconData)
                  Icon(
                    iconOrAsset,
                    size: 20,
                    color: const Color(0xFF6B7280),
                  ), // Adjusted color for lucide icons
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1A1D23),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const Icon(Icons.chevron_right, size: 20, color: Color(0xFFCBD5E1)),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 1, color: Colors.black.withValues(alpha: 0.04));
  }

  Widget _buildLogoutButton() {
    return Obx(
      () => controller.isLoadingLogout.value
          ? const Center(child: CircularProgressIndicator())
          : InkWell(
              onTap: () => controller.logout(),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, size: 20, color: Color(0xFFDC2626)),
                    SizedBox(width: 8),
                    Text(
                      'Log Out',
                      style: TextStyle(
                        color: Color(0xFFDC2626),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
