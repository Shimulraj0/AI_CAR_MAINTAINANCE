import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../routes/app_routes.dart';

class ProfileTabView extends GetView<HomeController> {
  const ProfileTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        toolbarHeight: kToolbarHeight,
        leading: Center(
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
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 26,
          right: 26,
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
            const SizedBox(height: 100), // Space for bottom nav
          ],
        ),
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
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/profile.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alex Johnson',
                  style: TextStyle(
                    color: Color(0xFF1A1D23),
                    fontSize: 18,
                    fontFamily: 'Archivo',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'alex.johnson@email.com',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard() {
    return Container(
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
          InkWell(
            onTap: () => Get.toNamed(Routes.subscription),
            borderRadius: BorderRadius.circular(8),
            child: Container(
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
          ),
        ],
      ),
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
    return InkWell(
      onTap: () => Get.offAllNamed(Routes.login),
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
    );
  }
}
