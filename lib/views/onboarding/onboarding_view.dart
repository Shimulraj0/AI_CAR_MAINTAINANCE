import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "image": "assets/images/onboarding1.png",
      "title": "Monitor Your Vehicle in\nReal Time",
      "body":
          "Get instant diagnostics, live data insights, and AI-powered vehicle health reports.",
    },
    {
      "image": "assets/images/onboarding2.png",
      "title": "Monitor Your Vehicle in\nReal Time",
      "body":
          "Get instant diagnostics, live data insights, and AI-powered vehicle health reports.",
    },
    {
      "image": "assets/images/onboarding3.png",
      "title": "Monitor Your Vehicle in Real Time",
      "body":
          "Get instant diagnostics, live data insights, and AI-powered vehicle health reports.",
    },
  ];

  void _onSkip() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offNamed(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Status Bar / Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "9:41",
                    style: TextStyle(
                      fontFamily: 'SF Pro Text', // System font usually
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.signal_cellular_alt, size: 16),
                      const SizedBox(width: 4),
                      const Icon(Icons.wifi, size: 16),
                      const SizedBox(width: 4),
                      // Battery icon placeholder or custom
                      Transform.rotate(
                        angle: 1.5708, // 90 degrees
                        child: const Icon(Icons.battery_full, size: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // PageView Content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Section (First)
                        Container(
                          width: 350,
                          height: 408,
                          decoration: ShapeDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                _onboardingData[index]['image']!,
                              ),
                              fit: BoxFit.fill,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Text Section (Second)
                        Text(
                          _onboardingData[index]['title']!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _onboardingData[index]['body']!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Indicators
            Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 40),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    _onboardingData.length,
                    (index) => Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: _currentPage == index ? 30 : 10,
                          height: 10,
                          decoration: ShapeDecoration(
                            color: _currentPage == index
                                ? const Color(0xFF1E3A8A)
                                : const Color(
                                    0xFFD9D9D9,
                                  ), // Light gray for inactive
                            shape: _currentPage == index
                                ? RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      5,
                                    ), // Pill shape
                                  )
                                : const OvalBorder(), // Circle
                          ),
                        ),
                        if (index != _onboardingData.length - 1)
                          const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Skip Button
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TextButton(
                onPressed: _onSkip,
                child: const Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.w400, // Matched font weight to image
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
