import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class DiagnosticResultView extends StatelessWidget {
  const DiagnosticResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Diagnostic Result',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Archivo',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2B63A8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Info
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6900),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Text(
                      'MODERATE SEVERITY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Confidence: 94%',
                    style: TextStyle(
                      color: Color(0xFF62748E),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'O2 Sensor Circuit Slow Response (Bank 1 Sensor 1)',
                style: TextStyle(
                  color: Color(0xFF0F172B),
                  fontSize: 24,
                  fontFamily: 'Archivo',
                  fontWeight: FontWeight.w700,
                  height: 1.33,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'P0133 • Powertrain System',
                style: TextStyle(
                  color: Color(0xFF62748E),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 24),

              // AI Assessment Card
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Color(0xFF2B63A8),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'AI Assessment',
                          style: TextStyle(
                            color: Color(0xFF0F172B),
                            fontSize: 16,
                            fontFamily: 'Archivo',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "The oxygen sensor is reacting too slowly to the changes in the air/fuel mixture. This usually indicates the sensor is aging and becoming 'lazy', or there's an exhaust leak near the sensor.",
                      style: TextStyle(
                        color: Color(0xFF45556C),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'REPORTED SYMPTOMS',
                      style: TextStyle(
                        color: Color(0xFF0F172B),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.30,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildSymptomChip('Check Engine Light'),
                        _buildSymptomChip('Reduced Fuel Economy'),
                        _buildSymptomChip('Rough Idle'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Possible Causes Header
              const Opacity(
                opacity: 0.80,
                child: Text(
                  'Possible Causes',
                  style: TextStyle(
                    color: Color(0xFF0F172B),
                    fontSize: 16,
                    fontFamily: 'Archivo',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Cause 1: Faulty O2 Sensor (High Prob)
              _buildCauseCard(
                title: 'Faulty O2 Sensor',
                probLabel: 'High Prob.',
                probColor: const Color(0xFFE7000B),
                probBgColor: const Color(0xFFFEF2F2),
                meaning:
                    'The oxygen sensor is not responding quickly enough to changes in the air/fuel mixture. This often happens as the sensor ages.',
                whyMatch:
                    'Your symptoms (check engine light + reduced fuel economy) are commonly caused by slow O2 sensor response.',
                action:
                    "Inspect the O2 sensor for any signs of damage or wear. Replace if it's aged or faulty.",
              ),
              const SizedBox(height: 16),

              // Cause 2: Exhaust Leak (Medium Prob)
              _buildCauseCard(
                title: 'Exhaust Leak',
                probLabel: 'Medium Prob.',
                probColor: const Color(0xFFF54900),
                probBgColor: const Color(0xFFFFF7ED),
                meaning:
                    'There may be a leak in the exhaust system near the oxygen sensor. This can allow extra air to enter the system, causing inaccurate sensor readings and triggering the check engine light.',
                whyMatch:
                    '• An exhaust leak can cause irregular air/fuel ratio readings.\n• This may result in reduced fuel economy and rough engine performance.\n• Your reported symptoms are commonly associated with exhaust system leaks.',
                action:
                    '• Inspect the exhaust manifold and nearby pipes for cracks or loose connections.\n• Check for unusual exhaust noise or smell.\n• Repair or replace damaged exhaust components if necessary.',
              ),
              const SizedBox(height: 16),

              // Cause 3: Wiring Issue (Low Prob)
              _buildCauseCard(
                title: 'Wiring Issue',
                probLabel: 'Low Prob.',
                probColor: const Color(0xFFD08700),
                probBgColor: const Color(0xFFFEFCE8),
                meaning:
                    'There could be a problem with the wiring or connector linked to the O2 sensor. Damaged or loose wiring can interrupt signal transmission between the sensor and the engine control module (ECM).',
                whyMatch:
                    '• Faulty wiring can delay or distort sensor readings.\n• This may occasionally trigger diagnostic code P0133.\n• Although less common, electrical issues can mimic sensor failure symptoms.',
                action:
                    '• Inspect the O2 sensor wiring harness for damage or corrosion.\n• Ensure connectors are securely attached.\n• Repair or replace any damaged wires if found.',
              ),

              const SizedBox(height: 24),

              // Recommended Next Steps
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFF1F5F9,
                  ), // lightly tinted blue/gray per design
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFDBEAFE)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recommended Next Steps',
                      style: TextStyle(
                        color: Color(0xFF2B63A8),
                        fontSize: 16,
                        fontFamily: 'Archivo',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStepRow('1', 'Inspect the exhaust system for leaks'),
                    const SizedBox(height: 12),
                    _buildStepRow('2', 'Check O2 sensor wiring harness'),
                    const SizedBox(height: 12),
                    _buildStepRow('3', 'Replace Upstream O2 Sensor'),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Bottom Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Get.toNamed(Routes.saveReports);
                      },
                      icon: const Icon(Icons.file_download_outlined, size: 20),
                      label: const Text(
                        'Save Report',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        foregroundColor: const Color(0xFF314158),
                        side: const BorderSide(
                          color: Color(0xFFE2E8F0),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.chat_bubble_outline, size: 20),
                      label: const Text(
                        'Chat AI',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFF2B63A8),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.calendar_today_outlined, size: 20),
                  label: const Text(
                    'Schedule Service',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF1D293D),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSymptomChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF45556C),
          fontSize: 12,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildCauseCard({
    required String title,
    required String probLabel,
    required Color probColor,
    required Color probBgColor,
    required String meaning,
    required String whyMatch,
    required String action,
  }) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF0A0A0A),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: probBgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      probLabel,
                      style: TextStyle(
                        color: probColor,
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.keyboard_arrow_up, color: Colors.grey),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildCauseSection(
            Icons.info_outline,
            'What This Means',
            meaning,
            const Color(0xFF2B63A8),
          ),
          const SizedBox(height: 12),
          _buildCauseSection(
            Icons.check_circle_outline,
            'Why This Matches Your Issue',
            whyMatch,
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildCauseSection(
            Icons.build_circle_outlined,
            'Recommended Action',
            action,
            const Color(0xFF2B63A8),
          ),
        ],
      ),
    );
  }

  Widget _buildCauseSection(
    IconData icon,
    String title,
    String text,
    Color iconColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF0A0A0A),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 26.0),
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF62748E),
              fontSize: 13,
              fontFamily: 'Inter',
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepRow(String number, String text) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFDBEAFE)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            number,
            style: const TextStyle(
              color: Color(0xFF2B63A8),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF0A0A0A),
              fontSize: 14,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }
}
