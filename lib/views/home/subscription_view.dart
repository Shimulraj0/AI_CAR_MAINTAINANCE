import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import 'dart:io' show Platform;
import 'package:pay/pay.dart';
import '../../configs/payment_config.dart';

class SubscriptionView extends GetView<HomeController> {
  SubscriptionView({super.key});

  final GlobalKey _applePayKey = GlobalKey();
  final GlobalKey _googlePayKey = GlobalKey();

  Offset? _getCenterOfKey(GlobalKey key) {
    try {
      final RenderBox? renderBox =
          key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero);
        return Offset(
          position.dx + renderBox.size.width / 2,
          position.dy + renderBox.size.height / 2,
        );
      }
    } catch (e) {
      debugPrint('Error getting button position: $e');
    }
    return null;
  }

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
                'Subscription',
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 32),
                const Text(
                  'Autointel Premium',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF0A0A0A),
                    fontSize: 24,
                    fontFamily: 'Archivo',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Unlock the full power of vehicle intelligence',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF2B63A8),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 32),
                _FadeInSlide(
                  delay: 100,
                  child: _buildStarterPlan(),
                ),
                const SizedBox(height: 24),
                _FadeInSlide(
                  delay: 200,
                  child: _buildOneTimeUnlockPlan(),
                ),
                const SizedBox(height: 24),
                _FadeInSlide(
                  delay: 300,
                  child: _buildProPlan(),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          Obx(() {
            if (controller.isProcessingPayment.value) {
              return Container(
                color: Colors.black.withValues(alpha: 0.4),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF2B63A8),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Processing Payment...',
                              style: TextStyle(
                                color: Color(0xFF1A1A1A),
                                fontSize: 16,
                                fontFamily: 'Archivo',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Setting up your premium experience',
                              style: TextStyle(
                                color: Color(0xFF787878),
                                fontSize: 13,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3, // Originating from Profile tab
        onTap: (index) {
          controller.changeTabIndex(index);
          Get.offAllNamed(Routes.home);
        },
        onFabTap: () {
          Get.offAllNamed(Routes.home);
          Get.toNamed(Routes.aiChat);
        },
      ),
    );
  }

  Widget _buildPremiumLoader() {
    return const Center(
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2B63A8)),
        ),
      ),
    );
  }

  Future<void> _handlePaymentResult(dynamic result, GlobalKey key) async {
    debugPrint('Payment Result: $result');
    controller.isProcessingPayment.value = true;
    
    // Simulate premium verification delay
    await Future.delayed(const Duration(milliseconds: 2500));
    
    controller.isProcessingPayment.value = false;
    
    Get.toNamed(
      Routes.paymentSuccess,
      arguments: {'revealOffset': _getCenterOfKey(key)},
    );
  }
  Widget _buildStarterPlan() {
    return Obx(() => GestureDetector(
      onTap: () => controller.selectedPlanIndex.value = 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 26),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: controller.selectedPlanIndex.value == 0
                ? const Color(0xFF1363DF)
                : const Color(0xFFE1E1E1),
            width: controller.selectedPlanIndex.value == 0 ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Starter',
              style: TextStyle(
                color: Color(0xFF1A1A1A),
                fontSize: 24,
                fontFamily: 'Archivo',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Essential vehicle tools for free',
              style: TextStyle(
                color: Color(0xFF787878),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '\$0.00',
              style: TextStyle(
                color: Color(0xFF1A1A1A),
                fontSize: 32,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            _buildFeatureRow('Basic AI Diagnosis', true),
            _buildFeatureRow('Limited AI Chat (5/day)', true),
            _buildFeatureRow('Single Vehicle Profile', true),
            _buildFeatureRow('Standard Notifications', true),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(30),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Current Plan',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildOneTimeUnlockPlan() {
    return Obx(() => GestureDetector(
      onTap: () => controller.selectedPlanIndex.value = 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 26),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: controller.selectedPlanIndex.value == 1
                ? const Color(0xFF1363DF)
                : const Color(0xFFE1E1E1),
            width: controller.selectedPlanIndex.value == 1 ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'One-Time Unlock',
              style: TextStyle(
                color: Color(0xFF1A1A1A),
                fontSize: 24,
                fontFamily: 'Archivo',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Full access for a single scan',
              style: TextStyle(
                color: Color(0xFF787878),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '\$1.99',
              style: TextStyle(
                color: Color(0xFF1A1A1A),
                fontSize: 32,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            _buildFeatureRow('One-Time Full Report', true),
            _buildFeatureRow('Unlimited AI Chat (24h)', true),
            _buildFeatureRow('Deep OBD-II Analysis', true),
            _buildFeatureRow('PDF Export Capability', true),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(30),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Unlock Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildProPlan() {
    return Obx(() => GestureDetector(
      onTap: () => controller.selectedPlanIndex.value = 2,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 26),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2B63A8), Color(0xFF5B96DD)],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: controller.selectedPlanIndex.value == 2
                ? const Color(0xFFFFFFFF)
                : Colors.transparent,
            width: controller.selectedPlanIndex.value == 2 ? 2 : 0,
          ),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text(
                'MOST POPULAR PLAN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontFamily: 'Space Grotesk',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Autointel Pro',
                    style: TextStyle(
                      color: Color(0xFF1A1A1A),
                      fontSize: 24,
                      fontFamily: 'Archivo',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'The ultimate vehicle companion',
                    style: TextStyle(
                      color: Color(0xFF787878),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        '\$3.99',
                        style: TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontSize: 32,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          letterSpacing: -1.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6, left: 2),
                        child: const Text(
                          ' /per Month',
                          style: TextStyle(
                            color: Color(0xFF1A1A1A),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildFeatureRow('Unlimited AI Diagnostics', true),
                  _buildFeatureRow('Priority 24/7 AI Chat', true),
                  _buildFeatureRow('Advanced Maintenance AI', true),
                  _buildFeatureRow('Manage Unlimited Vehicles', true),
                  _buildFeatureRow('Early Access to New Features', true),
                  _buildFeatureRow('Concierge Support', true),
                  const SizedBox(height: 32),
                  if (Platform.isIOS)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: SizedBox(
                        key: _applePayKey,
                        width: double.infinity,
                        height: 50,
                        child: ApplePayButton(
                          paymentConfiguration:
                              PaymentConfiguration.fromJsonString(
                                defaultApplePay,
                              ),
                          paymentItems: const [
                            PaymentItem(
                              label: 'AutoIntel Pro',
                              amount: '3.99',
                              status: PaymentItemStatus.final_price,
                            ),
                          ],
                          style: ApplePayButtonStyle.black,
                          type: ApplePayButtonType.subscribe,
                          onPaymentResult: (result) => _handlePaymentResult(result, _applePayKey),
                          loadingIndicator: _buildPremiumLoader(),
                        ),
                      ),
                    ),
                  if (Platform.isAndroid)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: SizedBox(
                        key: _googlePayKey,
                        width: double.infinity,
                        height: 50,
                        child: GooglePayButton(
                          paymentConfiguration:
                              PaymentConfiguration.fromJsonString(
                                defaultGooglePay,
                              ),
                          paymentItems: const [
                            PaymentItem(
                              label: 'AutoIntel Pro',
                              amount: '3.99',
                              status: PaymentItemStatus.final_price,
                            ),
                          ],
                          type: GooglePayButtonType.subscribe,
                          onPaymentResult: (result) => _handlePaymentResult(result, _googlePayKey),
                          loadingIndicator: _buildPremiumLoader(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildFeatureRow(String text, bool isIncluded) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isIncluded ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
            color: isIncluded
                ? const Color(0xFF2B63A8)
                : const Color(0xFF94A3B8),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isIncluded
                    ? const Color(0xFF0F172A)
                    : const Color(0xFF64748B),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: isIncluded ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FadeInSlide extends StatefulWidget {
  final Widget child;
  final int delay;

  const _FadeInSlide({required this.child, required this.delay});

  @override
  State<_FadeInSlide> createState() => _FadeInSlideState();
}

class _FadeInSlideState extends State<_FadeInSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _offset = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _offset, child: widget.child),
    );
  }
}
