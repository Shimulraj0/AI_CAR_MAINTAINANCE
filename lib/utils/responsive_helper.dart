import 'package:get/get.dart';

class ResponsiveHelper {
  static double get screenWidth => Get.width;
  static double get screenHeight => Get.height;

  static bool get isMobile => screenWidth < 600;
  static bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  static bool get isDesktop => screenWidth >= 1200;

  static double get paddingLarge => isMobile ? 24.0 : 32.0;
  static double get paddingMedium => isMobile ? 16.0 : 24.0;
  static double get paddingSmall => isMobile ? 8.0 : 12.0;

  static double get fontSizeH1 => isMobile ? 24.0 : 32.0;
  static double get fontSizeH2 => isMobile ? 20.0 : 28.0;
  static double get fontSizeBody => isMobile ? 14.0 : 16.0;

  static double responsiveWidth(double percentage) => screenWidth * (percentage / 100);
  static double responsiveHeight(double percentage) => screenHeight * (percentage / 100);
}
