import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      appBar: AppBar(
        title: const Text(
          'Subscription',
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'Autointel Premium',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF0A0A0A),
                    fontSize: 24,
                    fontFamily: 'Archivo',
                    fontWeight: FontWeight.w700,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Unlock the full power of vehicle intelligence',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF2B63A8),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // --- Starter / Free Card ---
                _FadeInSlide(delay: 100, child: _buildStarterCard()),
                const SizedBox(height: 24),

                // --- One-Time Full Report Unlock Card ---
                _FadeInSlide(delay: 200, child: _buildOneTimeCard()),
                const SizedBox(height: 24),

                // --- Most Popular Pro Card ---
                _FadeInSlide(delay: 300, child: _buildProCard()),
                const SizedBox(height: 40),
              ],
            ),
          ),
          // Payment processing overlay
          Obx(() {
            if (controller.isProcessingPayment.value) {
              return Container(
                color: Colors.black.withValues(alpha: 0.4),
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
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
                      mainAxisSize: MainAxisSize.min,
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
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3,
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

  // ─── Starter / Free Card ────────────────────────────────────────────────────

  Widget _buildStarterCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE1E1E1)),
          borderRadius: BorderRadius.circular(24),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 8,
            offset: Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Starter / ',
                  style: TextStyle(
                    color: const Color(0xFF1A1A1A),
                    fontSize: 24,
                    fontFamily: 'Archivo',
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                TextSpan(
                  text: 'Free',
                  style: TextStyle(
                    color: const Color(0xFF1A1A1A),
                    fontSize: 28,
                    fontFamily: 'Archivo',
                    fontWeight: FontWeight.w600,
                    height: 1.21,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildFeatureRow('Enter vehicle details', isIncluded: true),
          _buildFeatureRow('Enter diagnostic codes', isIncluded: false),
          _buildFeatureRow('Enter symptoms', isIncluded: false),
          _buildFeatureRow(
            'Receive a basic explanation summary',
            isIncluded: false,
          ),
          _buildFeatureRow(
            'View 1–2 likely causes (no deep breakdown)',
            isIncluded: false,
          ),
          _buildFeatureRow(
            'View basic safety-to-drive rating',
            isIncluded: false,
          ),
          _buildFeatureRow(
            'Perform limited basic DIY checks (1–2)',
            isIncluded: false,
          ),
          _buildFeatureRow('Add vehicle profile', isIncluded: false),
          _buildFeatureRow(
            'Use maintenance tracker (basic logging only)',
            isIncluded: false,
          ),
          const SizedBox(height: 32),
          _buildGreyButton('Starter'),
        ],
      ),
    );
  }

  // ─── One-Time Full Report Unlock Card ────────────────────────────────────────

  Widget _buildOneTimeCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE1E1E1)),
          borderRadius: BorderRadius.circular(24),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 8,
            offset: Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'One-Time Full Report Unlock',
            style: TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 24,
              fontFamily: 'Archivo',
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 12),
          _buildFeatureRow('Full ranked 1–5 causes', isIncluded: true),
          _buildFeatureRow('Detailed explanation per cause', isIncluded: false),
          _buildFeatureRow('Enter symptoms', isIncluded: false),
          _buildFeatureRow(
            'Receive a basic explanation summary',
            isIncluded: false,
          ),
          _buildFeatureRow(
            'View 1–2 likely causes (no deep breakdown)',
            isIncluded: false,
          ),
          _buildFeatureRow(
            'View basic safety-to-drive rating',
            isIncluded: false,
          ),
          _buildFeatureRow(
            'Perform limited basic DIY checks (1–2)',
            isIncluded: false,
          ),
          _buildFeatureRow('Add vehicle profile', isIncluded: false),
          _buildFeatureRow(
            'Use maintenance tracker (basic logging only)',
            isIncluded: false,
          ),
          const SizedBox(height: 32),
          _buildGreyButton('Starter'),
        ],
      ),
    );
  }

  // ─── Most Popular Pro Card ───────────────────────────────────────────────────

  Widget _buildProCard() {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 4, right: 4, bottom: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2B63A8), Color(0xFF5B96DD)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 9),
            child: Text(
              'MOST POPULAR PLAN',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'Space Grotesk',
                fontWeight: FontWeight.w600,
                letterSpacing: 0.96,
                height: 1.15,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'One-time Full Report unlock',
                  style: TextStyle(
                    color: Color(0xFF1A1A1A),
                    fontSize: 24,
                    fontFamily: 'Archivo',
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                // Price row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: const [
                    Text(
                      '£',
                      style: TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 28,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        letterSpacing: -1.12,
                        height: 1,
                      ),
                    ),
                    Text(
                      '3.99',
                      style: TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 28,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1.12,
                        height: 1,
                      ),
                    ),
                    Text(
                      ' /per Month',
                      style: TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildFeatureRow(
                  'Lock premium sections behind a paywall',
                  isIncluded: true,
                ),
                _buildFeatureRow(
                  'Unlimited Chat with Chat bot',
                  isIncluded: false,
                ),
                _buildFeatureRow(
                  'Full Vehicle History Tracking',
                  isIncluded: false,
                ),
                _buildFeatureRow('Multiple Vehicles', isIncluded: false),
                _buildFeatureRow('Smart Maintenance System', isIncluded: false),
                _buildFeatureRow('Priority Support', isIncluded: false),
                const SizedBox(height: 32),
                // "Upgrade to Pro" button — triggers native pay sheet on tap
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: Stack(
                    children: [
                      // Visual "Upgrade to Pro" button
                      Container(
                        width: double.infinity,
                        height: 54,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A0A0A),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Upgrade to Pro',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),
                      ),
                      // Transparent native pay button on top to capture taps
                      if (Platform.isIOS)
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.001,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(9999),
                              child: ApplePayButton(
                                key: _applePayKey,
                                paymentConfiguration:
                                    PaymentConfiguration.fromJsonString(
                                      defaultApplePay,
                                    ),
                                paymentItems: const [
                                  PaymentItem(
                                    label: 'AutoIntel Premium',
                                    amount: '3.99',
                                    status: PaymentItemStatus.final_price,
                                  ),
                                ],
                                style: ApplePayButtonStyle.black,
                                type: ApplePayButtonType.subscribe,
                                onPaymentResult: (result) =>
                                    _handlePaymentResult(result, _applePayKey),
                                loadingIndicator: _buildPremiumLoader(),
                              ),
                            ),
                          ),
                        ),
                      if (Platform.isAndroid)
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.001,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(9999),
                              child: GooglePayButton(
                                key: _googlePayKey,
                                paymentConfiguration:
                                    PaymentConfiguration.fromJsonString(
                                      defaultGooglePay,
                                    ),
                                paymentItems: const [
                                  PaymentItem(
                                    label: 'AutoIntel Premium',
                                    amount: '3.99',
                                    status: PaymentItemStatus.final_price,
                                  ),
                                ],
                                type: GooglePayButtonType.subscribe,
                                onPaymentResult: (result) =>
                                    _handlePaymentResult(result, _googlePayKey),
                                loadingIndicator: _buildPremiumLoader(),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  Widget _buildGreyButton(String label) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFD0D0D0),
        borderRadius: BorderRadius.circular(9999),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String text, {required bool isIncluded}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(
              isIncluded ? Icons.check_circle : Icons.check_circle_outline,
              color: isIncluded
                  ? const Color(0xFF1363DF)
                  : const Color(0xFF8599B3),
              size: 16,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isIncluded
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFF0A0A0A),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: isIncluded ? FontWeight.w600 : FontWeight.w400,
                height: 1.43,
                letterSpacing: isIncluded ? -0.42 : 0,
              ),
            ),
          ),
        ],
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
    await Future.delayed(const Duration(milliseconds: 2500));
    controller.isProcessingPayment.value = false;
    Get.toNamed(
      Routes.paymentSuccess,
      arguments: {'revealOffset': _getCenterOfKey(key)},
    );
  }
}

// ─── Animation Widget ─────────────────────────────────────────────────────────

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
    _opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
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
