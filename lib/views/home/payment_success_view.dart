import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PaymentSuccessView extends StatefulWidget {
  final Offset? revealOffset;
  const PaymentSuccessView({super.key, this.revealOffset});

  @override
  State<PaymentSuccessView> createState() => _PaymentSuccessViewState();
}

class _PaymentSuccessViewState extends State<PaymentSuccessView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _revealAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _revealAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Circular Reveal Background
            AnimatedBuilder(
              animation: _revealAnimation,
              builder: (context, child) {
                final size = MediaQuery.of(context).size;
                final center = widget.revealOffset ??
                    Offset(size.width / 2, size.height / 2);

                // Max radius to cover entire screen from trigger point
                final double maxRadius = 1000;
                final radius = maxRadius * _revealAnimation.value;

                return Stack(
                  children: [
                    Positioned(
                      left: center.dx - radius,
                      top: center.dy - radius,
                      child: Container(
                        width: radius * 2,
                        height: radius * 2,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2B63A8),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            // Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Color(0xFF2B63A8),
                        size: 64,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  FadeTransition(
                    opacity: _scaleAnimation,
                    child: Column(
                      children: [
                        const Text(
                          'Payment Successful!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Archivo',
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Welcome to AutoIntel Premium',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 48),
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () => Get.back(),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
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
      ),
    );
  }
}
