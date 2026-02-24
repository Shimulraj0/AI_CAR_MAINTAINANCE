import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/terms_conditions_controller.dart';

class TermsConditionsView extends GetView<TermsConditionsController> {
  const TermsConditionsView({super.key});

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
          'Terms & Conditions',
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
              title: '1. Acceptance of Terms',
              content: const Text(
                'By using this application, you agree to comply with these Terms & Conditions.',
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
              title: '2. Service Description',
              content: const Text(
                'This app provides AI-based vehicle diagnostic insights and maintenance recommendations.\nThe information provided is for guidance purposes only and does not replace professional mechanical inspection or repair services.',
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
              title: '3. User Responsibilities',
              content: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'You agree to:\n',
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
                          '• Provide accurate vehicle information\n• Use the app lawfully\n• Not misuse or attempt to disrupt the system',
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
              title: '4. No Professional Liability',
              content: const Text(
                'The app provides advisory insights based on AI analysis. We are not responsible for mechanical decisions, repairs, or damages resulting from actions taken based on the app’s recommendations.',
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
              title: '5. Subscription & Payments',
              content: const Text(
                'Premium features may require a paid subscription.\nSubscriptions may renew automatically unless canceled before the renewal date.',
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
              title: '6. Account Termination',
              content: const Text(
                'We reserve the right to suspend or terminate accounts that violate these terms.',
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
              title: '7. Limitation of Liability',
              content: const Text(
                'We are not liable for indirect, incidental, or consequential damages arising from the use of this app.',
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
              title: '8. Updates to Terms',
              content: const Text(
                'We may update these Terms at any time. Continued use of the app indicates acceptance of the updated terms.',
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
