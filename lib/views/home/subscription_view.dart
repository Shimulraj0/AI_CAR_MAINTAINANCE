import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../routes/app_routes.dart';
import '../../services/iap_service.dart';
import '../../widgets/custom_bottom_nav_bar.dart';

class SubscriptionView extends GetView<HomeController> {
  SubscriptionView({super.key});

  // 0 = Starter (free), 1 = One-Time, 2 = Pro
  final RxInt _selectedIndex = 2.obs;
  final GlobalKey _proButtonKey = GlobalKey();

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
        actions: [
          TextButton(
            onPressed: () => Get.find<IAPService>().restorePurchases(),
            child: const Text(
              'Restore',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
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
                _FadeInSlide(
                  delay: 100,
                  child: Obx(
                    () => _buildStarterCard(
                      isSelected: _selectedIndex.value == 0,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // --- One-Time Full Report Unlock Card ---
                _FadeInSlide(
                  delay: 200,
                  child: Obx(
                    () => _buildOneTimeCard(
                      isSelected: _selectedIndex.value == 1,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // --- Most Popular Pro Card ---
                _FadeInSlide(
                  delay: 300,
                  child: Obx(
                    () => _buildProCard(isSelected: _selectedIndex.value == 2),
                  ),
                ),
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
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF2B63A8),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Processing Payment...',
                          style: TextStyle(
                            color: Color(0xFF1A1A1A),
                            fontSize: 16,
                            fontFamily: 'Archivo',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
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

  Widget _buildStarterCard({required bool isSelected}) {
    return GestureDetector(
      onTap: () => _selectedIndex.value = 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: isSelected ? 2 : 1,
              color: isSelected
                  ? const Color(0xFF2B63A8)
                  : const Color(0xFFE1E1E1),
            ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Starter / ',
                        style: const TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontSize: 24,
                          fontFamily: 'Archivo',
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                      const TextSpan(
                        text: 'Free',
                        style: TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontSize: 28,
                          fontFamily: 'Archivo',
                          fontWeight: FontWeight.w600,
                          height: 1.21,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isSelected ? Icons.verified : Icons.verified_outlined,
                  color: isSelected
                      ? const Color(0xFF2B63A8)
                      : const Color(0xFFBBBBBB),
                  size: 24,
                ),
              ],
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
            _buildGreyButton('Starter', onTap: () => Get.back()),
          ],
        ),
      ),
    );
  }

  // ─── One-Time Full Report Unlock Card ────────────────────────────────────────

  Widget _buildOneTimeCard({required bool isSelected}) {
    return GestureDetector(
      onTap: () => _selectedIndex.value = 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: isSelected ? 2 : 1,
              color: isSelected
                  ? const Color(0xFF2B63A8)
                  : const Color(0xFFE1E1E1),
            ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'One-Time Full \nReport Unlock',
                  style: TextStyle(
                    color: Color(0xFF1A1A1A),
                    fontSize: 22,
                    fontFamily: 'Archivo',
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                Icon(
                  isSelected ? Icons.verified : Icons.verified_outlined,
                  color: isSelected
                      ? const Color(0xFF2B63A8)
                      : const Color(0xFFBBBBBB),
                  size: 24,
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              '£1.99 one-time',
              style: TextStyle(
                color: Color(0xFF2B63A8),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildFeatureRow('Full ranked 1–5 causes', isIncluded: true),
            _buildFeatureRow(
              'Detailed explanation per cause',
              isIncluded: true,
            ),
            _buildFeatureRow('Full safety-to-drive rating', isIncluded: true),
            _buildFeatureRow('DIY checks (up to 5)', isIncluded: true),
            _buildFeatureRow('Unlimited AI Chat', isIncluded: false),
            _buildFeatureRow('Add vehicle profile', isIncluded: false),
            _buildFeatureRow(
              'Use maintenance tracker (basic logging only)',
              isIncluded: false,
            ),
            const SizedBox(height: 32),
            _buildActionButton(
              label: 'Unlock Report — £1.99',
              productId: IAPProductIds.reportUnlock,
              isSelected: isSelected,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Most Popular Pro Card ───────────────────────────────────────────────────

  Widget _buildProCard({required bool isSelected}) {
    return GestureDetector(
      onTap: () => _selectedIndex.value = 2,
      child: Container(
        padding: const EdgeInsets.only(top: 10, left: 4, right: 4, bottom: 4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2B63A8), Color(0xFF5B96DD)],
          ),
          borderRadius: BorderRadius.circular(28),
          border: isSelected
              ? Border.all(color: const Color(0xFF0A3D8F), width: 2)
              : null,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Pro Subscription',
                        style: TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontSize: 24,
                          fontFamily: 'Archivo',
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                      Icon(
                        isSelected ? Icons.verified : Icons.verified_outlined,
                        color: isSelected
                            ? const Color(0xFF2B63A8)
                            : const Color(0xFFBBBBBB),
                        size: 24,
                      ),
                    ],
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
                    isIncluded: true,
                  ),
                  _buildFeatureRow(
                    'Full Vehicle History Tracking',
                    isIncluded: true,
                  ),
                  _buildFeatureRow('Multiple Vehicles', isIncluded: true),
                  _buildFeatureRow(
                    'Smart Maintenance System',
                    isIncluded: true,
                  ),
                  _buildFeatureRow('Priority Support', isIncluded: true),
                  const SizedBox(height: 32),
                  _buildActionButton(
                    label: 'Upgrade to Pro',
                    productId: IAPProductIds.proMonthly,
                    isSelected: isSelected,
                    dark: true,
                    buttonKey: _proButtonKey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  Widget _buildGreyButton(String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required String productId,
    required bool isSelected,
    bool dark = false,
    GlobalKey? buttonKey,
  }) {
    return GestureDetector(
      onTap: () {
        final offset = buttonKey != null ? _getCenterOfKey(buttonKey) : null;
        controller.startSubscription(productId, revealOffset: offset);
      },
      child: Container(
        key: buttonKey,
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF0A0A0A) : const Color(0xFF2B63A8),
          borderRadius: BorderRadius.circular(9999),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
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
              isIncluded ? Icons.verified : Icons.verified_outlined,
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
