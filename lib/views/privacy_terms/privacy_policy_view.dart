import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/privacy_policy_controller.dart';

class PrivacyPolicyView extends GetView<PrivacyPolicyController> {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B63A8),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 16),
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Archivo',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors
              .transparent, // Removes the divider lines between ExpansionTiles
        ),
        child: ListView(
          padding: const EdgeInsets.only(
            left: 26,
            right: 26,
            top: 24,
            bottom: 40, // Extra padding at bottom for scrollability
          ),
          children: [
            _buildSection(
              title: '1. Introduction',
              content: const Text(
                'We respect your privacy and are committed to protecting your personal information. This Privacy Policy explains how we collect, use, and safeguard your data when you use our vehicle diagnostic application.',
                style: TextStyle(
                  color: Colors
                      .black54, // Closest to Colors.black.withValues(alpha: 0.60)
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.30,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: '2. Information We Collect',
              content: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Personal Information:\n',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 1.30,
                      ),
                    ),
                    TextSpan(
                      text:
                          '• Name\n• Email address\n• Contact details\n• Account credentials\n',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.30,
                      ),
                    ),
                    TextSpan(
                      text: '\nVehicle Information:\n',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 1.30,
                      ),
                    ),
                    TextSpan(
                      text:
                          '• Vehicle make, model, year\n• Diagnostic codes entered\n• Reported symptoms\n• Maintenance history\n',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.30,
                      ),
                    ),
                    TextSpan(
                      text: '\nUsage Data:\n',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 1.30,
                      ),
                    ),
                    TextSpan(
                      text:
                          '• App interactions\n• Diagnostic activity\n• Feature usage',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: '3. How We Use Your Information',
              content: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'We use your information to:\n',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 1.30,
                      ),
                    ),
                    TextSpan(
                      text:
                          '• Provide AI-based diagnostic insights\n• Improve diagnostic accuracy\n• Store vehicle history and reports\n• Send maintenance reminders\n• Manage subscriptions and premium features\n• Improve app performance and user experience\n',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.30,
                      ),
                    ),
                    TextSpan(
                      text:
                          '\nWe do not sell your personal data to third parties.',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: '4. Data Security',
              content: const Text(
                'We implement reasonable technical and organizational measures to protect your data from unauthorized access, misuse, or disclosure.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.30,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: '5. Third-Party Services',
              content: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'We may use trusted third-party services for:\n',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 1.30,
                      ),
                    ),
                    TextSpan(
                      text:
                          '• Payment processing\n• Analytics\n• Cloud storage\n',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.30,
                      ),
                    ),
                    TextSpan(
                      text:
                          'These providers are required to handle your data securely.',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: '6. Your Rights',
              content: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'You may:\n',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 1.30,
                      ),
                    ),
                    TextSpan(
                      text:
                          '• Update your profile information\n• Request account deletion\n• Contact us regarding your data',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: '7. Changes to This Policy',
              content: const Text(
                'We may update this Privacy Policy periodically. Continued use of the app indicates acceptance of any updates.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget content}) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: Colors.black.withValues(alpha: 0.10),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        iconColor: const Color(0xFF0F0F0F),
        collapsedIconColor: const Color(0xFF0F0F0F),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF0F0F0F),
            fontSize: 16,
            fontFamily: 'Archivo',
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [Align(alignment: Alignment.centerLeft, child: content)],
      ),
    );
  }
}
