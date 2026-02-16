import 'package:flutter/material.dart';

class SplashBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Background base color (Darker Blue)
    // #2C66B8 approximation ~ Color(0xFF2C66B8)
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Paint backgroundPaint = Paint()
      ..color = const Color(0xFF2E6CA4); // Base blue
    canvas.drawRect(rect, backgroundPaint);

    // Top Right Wave (Lighter Blue)
    paint.color = const Color(0xFF4A89C8).withValues(alpha: 0.6);
    paint.style = PaintingStyle.fill;

    final path1 = Path();
    path1.moveTo(size.width * 0.4, 0);
    path1.quadraticBezierTo(
      size.width * 0.7,
      size.height * 0.2,
      size.width,
      size.height * 0.4,
    );
    path1.lineTo(size.width, 0);
    path1.close();
    canvas.drawPath(path1, paint);

    // Bottom Right Wave (Lighter Blue)
    final path2 = Path();
    path2.moveTo(size.width, size.height * 0.6);
    path2.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.8,
      size.width * 0.3,
      size.height,
    );
    path2.lineTo(size.width, size.height);
    path2.close();
    canvas.drawPath(path2, paint);

    // Top Left Wave Shadow/Layer
    paint.color = const Color(0xFF1A4B85).withValues(alpha: 0.3);
    final path3 = Path();
    path3.moveTo(0, size.height * 0.3);
    path3.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.4,
      size.width * 0.6,
      0,
    );
    path3.lineTo(0, 0);
    path3.close();
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
