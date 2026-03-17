import 'package:flutter/material.dart';

class ResponsiveHelper {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }

  // Scaling methods
  static double w(double width) => (width / 375.0) * screenWidth; // Based on 375 width (iPhone X/11/12/13/14)
  static double h(double height) => (height / 812.0) * screenHeight; // Based on 812 height
  static double sp(double fontSize) => (fontSize / 375.0) * screenWidth;
  
  // Text Scaling constraint (prevents huge text if user has accessibility settings on)
  static double get textScaleFactor => _mediaQueryData.textScaler.clamp(minScaleFactor: 0.8, maxScaleFactor: 1.2).scale(1.0);
}

// Extension for easier usage
extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  
  double w(double width) => (width / 375.0) * screenWidth;
  double h(double height) => (height / 812.0) * screenHeight;
  double sp(double fontSize) => (fontSize / 375.0) * screenWidth;
}
