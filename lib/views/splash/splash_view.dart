import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/splash_controller.dart';
import '../../widgets/painters/splash_background_painter.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    Get.put(SplashController());

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Painter
          // Background Painter
          CustomPaint(
            key: const Key('splash_background'),
            painter: SplashBackgroundPainter(),
          ),

          // Center Content
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 216,
                    height: 180,
                    decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    // Using PNG asset
                    child: Image.asset(
                      'assets/images/branded_logo.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // User Provided Structure (adapted)
                  Container(
                    width: 402,
                    padding: const EdgeInsets.only(
                      left: 26,
                      right: 26,
                      bottom: 14,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(),
                    child: Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: double.infinity,
                                height: 30,
                              ),
                              SizedBox(
                                width: 332,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 54,
                                      height: 21,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 11,
                                            top: 3,
                                            child: SizedBox(
                                              width: 33,
                                              height: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Row with spacing 4 manually handled
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(width: 20, height: 14),
                                        const SizedBox(width: 4),
                                        const SizedBox(width: 16, height: 14),
                                        const SizedBox(width: 4),
                                        SizedBox(
                                          width: 25,
                                          height: 12,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 2,
                                                top: 2,
                                                child: Container(
                                                  width: 19,
                                                  height: 8,
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            1,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Positioned(
                          left: 26,
                          top: 40,
                          child: SizedBox(width: 6, height: 6),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 402,
                    height: 40,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 129.71,
                          top: 24.25,
                          child: SizedBox(
                            width: 143.65,
                            height: 6.88,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0.29,
                                  top: -0.25,
                                  child: Container(
                                    width: 144,
                                    height: 6,
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
