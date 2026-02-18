import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../routes/app_routes.dart';

class PasswordResetSuccessView extends StatelessWidget {
  const PasswordResetSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            // Blue Header Background
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10,
                  bottom: 16,
                ),
                decoration: const BoxDecoration(color: Color(0xFF2B63A8)),
                child: const Center(
                  child: Text(
                    'Reset Password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Archivo',
                      fontWeight: FontWeight.w600,
                      height: 1.22,
                    ),
                  ),
                ),
              ),
            ),

            // Content
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 208,
                    height: 208,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: 208,
                            height: 208,
                            decoration: const ShapeDecoration(
                              color: Color(0xFFEAF3FF),
                              shape: OvalBorder(),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 17,
                          top: 17,
                          child: Container(
                            width: 174,
                            height: 174,
                            decoration: const ShapeDecoration(
                              color: Colors.white,
                              shape: OvalBorder(),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 38, // Center the icon visually
                          top: 38,
                          child: Container(
                            width: 132,
                            height: 132,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/images/Shield Done.svg',
                                width: 132,
                                height: 132,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: 290,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          'Success!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF1F2A37),
                            fontSize: 20,
                            fontFamily: 'Archivo',
                            fontWeight: FontWeight.w600,
                            height: 1.30,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'You password has been changed. Please log in again with a new password.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF949CA9),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.29,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Continue Button at the bottom
            Positioned(
              left: 24,
              right: 24,
              bottom: 40,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed(Routes.login);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B63A8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                    ),
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
