import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:get/get.dart';

class DiagnoseTabView extends StatefulWidget {
  const DiagnoseTabView({super.key});

  @override
  State<DiagnoseTabView> createState() => _DiagnoseTabViewState();
}

class _DiagnoseTabViewState extends State<DiagnoseTabView>
    with SingleTickerProviderStateMixin {
  bool _isAnalyzing = false;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleAnalyze() async {
    if (_isAnalyzing) return;
    setState(() {
      _isAnalyzing = true;
    });
    _animationController.repeat();

    // Simulating processing delay before navigation
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Get.toNamed('/analyzing')?.then((_) {
        // Reset state if user comes back
        if (mounted) {
          setState(() {
            _isAnalyzing = false;
          });
          _animationController.stop();
          _animationController.reset();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vehicle',
            style: TextStyle(
              color: Color(0xFF0F0F0F),
              fontSize: 14,
              fontFamily: 'Archivo',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: '2021 Toyota Camry',
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                items: ['2021 Toyota Camry'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Color(0xFF1A1D23),
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Diagnostic Codes',
            style: TextStyle(
              color: Color(0xFF0F0F0F),
              fontSize: 14,
              fontFamily: 'Archivo',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Enter OBD-II codes (e.g. P0300, P0171)',
            style: TextStyle(
              color: Color(0xFF62748E),
              fontSize: 12,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.08),
                    ),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter code',
                      hintStyle: TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF2F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Add',
                  style: TextStyle(
                    color: Color(0xFF2F5EA8),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            'Symptoms',
            style: TextStyle(
              color: Color(0xFF0F0F0F),
              fontSize: 14,
              fontFamily: 'Archivo',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Describe what you\'re experiencing in plain language',
            style: TextStyle(
              color: Color(0xFF62748E),
              fontSize: 12,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
            ),
            child: const TextField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText:
                    'e.g. Engine misfires at idle, rough vibration, reduced fuel economy...',
                hintStyle: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),

          const SizedBox(height: 48), // Spacer before button

          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: _isAnalyzing ? null : const Color(0xFF2B63A8),
              gradient: _isAnalyzing
                  ? const LinearGradient(
                      colors: [Color(0xFF8BB8E8), Color(0xFFA5C9F0)],
                    )
                  : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton(
              onPressed: _isAnalyzing ? null : _handleAnalyze,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: Colors.transparent,
                disabledForegroundColor: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _animationController.value * 2 * math.pi,
                        child: child,
                      );
                    },
                    child: CustomPaint(
                      size: const Size(20, 20),
                      painter: _ScanIconPainter(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Analyze',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 80), // Bottom nav padding
        ],
      ),
    );
  }
}

class _ScanIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    // Outer broken arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 8.5),
      0.5,
      4.0,
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 8.5),
      5.0,
      1.2,
      false,
      paint,
    );

    // Inner broken arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 4.5),
      2.0,
      3.0,
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 4.5),
      -0.5,
      2.0,
      false,
      paint,
    );

    // Center dot
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(center, 1.5, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
