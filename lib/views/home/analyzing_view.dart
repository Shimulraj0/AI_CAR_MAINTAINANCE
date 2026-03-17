import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/responsive_helper.dart';

class AnalyzingView extends StatefulWidget {
  const AnalyzingView({super.key});

  @override
  State<AnalyzingView> createState() => _AnalyzingViewState();
}

class _AnalyzingViewState extends State<AnalyzingView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B63A8),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Analyzing',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Archivo',
            fontWeight: FontWeight.w600,
          ),
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        leading: const SizedBox(), // Hidden back button during analysis
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(24)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo / Loading concentric circles
              AnimatedConcentricCircles(context),
              SizedBox(height: context.h(32)),
              Text(
                'Analyzing...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF1A1D23),
                  fontSize: context.sp(24),
                  fontFamily: 'Archivo',
                  fontWeight: FontWeight.w600,
                  height: 1.42,
                ),
              ),
              SizedBox(height: context.h(8)),
              Text(
                'Reviewing your vehicle information and\nidentifying potential causes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF45556C),
                  fontSize: context.sp(16),
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              SizedBox(height: context.h(48)),

              // Checklist Items
              _buildChecklistItem(context, 'Reading diagnostic codes'),
              SizedBox(height: context.h(16)),
              _buildChecklistItem(context, 'Analyzing symptoms'),
              SizedBox(height: context.h(16)),
              _buildChecklistItem(context, 'Matching patterns'),
              SizedBox(height: context.h(16)),
              _buildChecklistItem(context, 'Generating report'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChecklistItem(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(left: context.w(32)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: context.w(8),
            height: context.w(8),
            decoration: const BoxDecoration(
              color: Color(0xFF2B63A8),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: context.w(12)),
          Text(
            text,
            style: TextStyle(
              color: const Color(0xFF45556C),
              fontSize: context.sp(14),
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.43,
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedConcentricCircles extends StatefulWidget {
  final BuildContext context;
  const AnimatedConcentricCircles(this.context, {super.key});

  @override
  State<AnimatedConcentricCircles> createState() =>
      _AnimatedConcentricCirclesState();
}

class _AnimatedConcentricCirclesState extends State<AnimatedConcentricCircles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.context.w(80),
      height: widget.context.w(80),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Ring (rotates clockwise)
          AnimatedBuilder(
            animation: _controller,
            builder: (_, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * math.pi,
                child: child,
              );
            },
            child: SizedBox(
              width: widget.context.w(80),
              height: widget.context.w(80),
              child: CircularProgressIndicator(
                value: 0.35, // 35% colored, 65% background
                strokeWidth: 3,
                color: const Color(0xFF2B63A8),
                backgroundColor: const Color(0xFF2B63A8).withValues(alpha: 0.1),
              ),
            ),
          ),
          // Inner Ring (rotates counter-clockwise)
          AnimatedBuilder(
            animation: _controller,
            builder: (_, child) {
              return Transform.rotate(
                angle: -_controller.value * 2 * math.pi, // Inverse rotation
                child: child,
              );
            },
            child: SizedBox(
              width: widget.context.w(56),
              height: widget.context.w(56),
              child: CircularProgressIndicator(
                value: 0.25,
                strokeWidth: 3,
                color: const Color(0xFF2B63A8).withValues(alpha: 0.5),
                backgroundColor: const Color(0xFF2B63A8).withValues(alpha: 0.1),
              ),
            ),
          ),
          // Inner-most dot and small arcs (rotates clockwise faster)
          AnimatedBuilder(
            animation: _controller,
            builder: (_, child) {
              return Transform.rotate(
                angle: _controller.value * 4 * math.pi,
                child: child,
              );
            },
            child: SizedBox(
              width: widget.context.w(24),
              height: widget.context.w(24),
              child: CustomPaint(painter: InnerArcsPainter()),
            ),
          ),
        ],
      ),
    );
  }
}

class InnerArcsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = const Color(0xFF2B63A8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2; // Not rounded by default

    // Draw center dot
    canvas.drawCircle(center, 2, Paint()..color = const Color(0xFF2B63A8));

    // Draw two arcs
    final rect = Rect.fromCircle(center: center, radius: 8);
    // Draw an arc from 0 to 90 degrees
    canvas.drawArc(rect, 0, math.pi / 2, false, paint);
    // Draw an arc from 180 to 270 degrees
    canvas.drawArc(rect, math.pi, math.pi / 2, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
