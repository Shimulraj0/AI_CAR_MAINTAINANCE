import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Status Bar Placeholder (using the user's provided structure logic)
            // Note: In a real app, SafeArea handles status bar, but user provided specific UI for it.
            // I'll stick to the requested visual structure as much as possible but use Flutter widgets.

            // Image Section
            Expanded(
              flex: 5,
              child: Container(
                width: 350,
                // height: 408, // allowing flex to handle height
                decoration: ShapeDecoration(
                  image: const DecorationImage(
                    image: NetworkImage("https://placehold.co/350x408"),
                    fit: BoxFit.fill,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Text Section
            Container(
              width: 350,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monitor Your Vehicle in Real Time',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w600,
                      height: 1.33,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Get instant diagnostics, live data insights, and AI-powered vehicle health reports.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.43,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(flex: 2),

            // Pagination Indicator (dots)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 38), // align with text approximately
                Container(
                  width: 25,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B5998), // Example active color
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0E0E0), // Example inactive color
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0E0E0),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),

            const Spacer(flex: 1),

            // Skip Button
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: TextButton(
                onPressed: () {
                  Get.offNamed(Routes.home);
                },
                child: const Text(
                  'SKIP',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
            // Bottom handle indicator placeholder
            Container(
              width: 144,
              height: 5,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
