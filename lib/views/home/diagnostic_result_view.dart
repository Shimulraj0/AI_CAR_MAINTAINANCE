import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../../controllers/diagnostic_result_controller.dart';
import '../../controllers/save_reports_controller.dart';
import '../../services/api_service.dart';

class DiagnosticResultView extends GetView<DiagnosticResultController> {
  const DiagnosticResultView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is registered if not already (safeguard)
    if (!Get.isRegistered<DiagnosticResultController>()) {
      Get.put(DiagnosticResultController());
    }

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
      body: Obx(() {
        if (controller.isLoading.value && controller.result.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFF2B63A8)),
                SizedBox(height: 16),
                Text(
                  'Collecting diagnostic data...',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.result.isEmpty) {
          return const Center(child: Text('No diagnostic data found'));
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...controller.resultsList.asMap().entries.map((resultEntry) {
                  final resultIndex = resultEntry.key;
                  final result = resultEntry.value;
                  final isMultiPart = controller.resultsList.length > 1;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isMultiPart) ...[
                        Container(
                          margin: const EdgeInsets.only(top: 8, bottom: 16),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2B63A8).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF2B63A8).withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            'PART ${resultIndex + 1} OF ${controller.resultsList.length}',
                            style: const TextStyle(
                              color: Color(0xFF2B63A8),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
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
                            child: Text(
                              result['safety_rating'] ??
                              result['severity_label'] ??
                              result['severity']?.toString().toUpperCase() ??
                              'MODERATE SEVERITY',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Confidence: ${result['confidence_level'] ?? result['confidence'] ?? '94'}%',
                              style: const TextStyle(
                                color: Color(0xFF62748E),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        result['title'] ?? 'Diagnostic Result',
                        style: const TextStyle(
                          color: Color(
                            0xFF1E293B,
                          ), // Matches design's dark blue/slate
                          fontSize: 24,
                          fontFamily: 'Archivo',
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${result['diagnostic_codes'] is List && (result['diagnostic_codes'] as List).isNotEmpty ? (result['diagnostic_codes'] as List).join(', ') : (result['primary_code'] ?? result['code'] ?? result['diagnostic_code'] ?? 'P0133')} • ${result['system'] ?? result['vehicle_system'] ?? 'Vehicle System'}',
                        style: const TextStyle(
                          color: Color(0xFF62748E),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Vehicle Assessment Card
                      _buildAssessmentCard(
                        assessment: result['summary'] ??
                            result['ai_assessment'] ??
                            result['assessment'] ??
                            result['analysis'] ??
                            "No detailed assessment available.",
                        symptoms: _ensureList(
                            result['symptoms'] ?? result['reported_symptoms']),
                      ),

                      const SizedBox(height: 28),

                      // Possible Causes Header
                      const Text(
                        'Possible Causes',
                        style: TextStyle(
                          color: Color(0xFF1E293B),
                          fontSize: 16,
                          fontFamily: 'Archivo',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Dynamic Possible Causes
                      ...(_ensureList(result['likely_causes'] ??
                                  result['possible_causes'] ??
                                  result['causes'] ??
                                  result['potential_causes']))
                          .asMap()
                          .entries
                          .map((entry) {
                            final causeIndex = entry.key;
                            final cause = entry.value as Map<String, dynamic>;
                            final int globalIndex =
                                (resultIndex * 100 + causeIndex).toInt();

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildCauseCard(
                                index: globalIndex,
                                title:
                                    cause['title'] ??
                                    cause['name'] ??
                                    'Generic Cause',
                                probLabel:
                                    '${cause['probability'] ?? cause['likelihood'] ?? 'Possible'} Prob.',
                                probColor: causeIndex == 0
                                    ? const Color(0xFFEF4444)
                                    : causeIndex == 1
                                    ? const Color(0xFFF97316)
                                    : const Color(0xFFEAB308),
                                probBgColor: causeIndex == 0
                                    ? const Color(0xFFFEF2F2)
                                    : causeIndex == 1
                                    ? const Color(0xFFFFF7ED)
                                    : const Color(0xFFFEFCE8),
                                meaning: cause['what_it_means'] ??
                                    cause['description'] ??
                                    cause['meaning'] ??
                                    '',
                                whyMatch: cause['why_it_matches'] ??
                                    cause['how_it_matches'] ??
                                    cause['reasoning'] ??
                                    cause['match_reason'] ??
                                    '',
                                action: cause['recommended_action'] ??
                                    cause['action'] ??
                                    cause['fix'] ??
                                    '',
                              ),
                            );
                          }),

                      const SizedBox(height: 12),

                      // Recommended Next Steps
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFEFF6FF,
                          ), // Soft light blue from design
                          borderRadius: BorderRadius.circular(12),
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
                            ...(_ensureList(result['recommended_next_steps'] ??
                                        result['next_steps'] ??
                                        result['recommendations']))
                                .asMap()
                                .entries
                                .map((entry) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _buildStepRow(
                                      (entry.key + 1).toString(),
                                      entry.value.toString(),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),

                      if (resultIndex < controller.resultsList.length - 1)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Divider(
                            thickness: 2,
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                    ],
                  );
                }),

                const SizedBox(height: 32),

                // Bottom Buttons
                Row(
                  children: [
                    Expanded(
                      child: Obx(() {
                        final saveReportsController =
                            Get.isRegistered<SaveReportsController>()
                            ? Get.find<SaveReportsController>()
                            : Get.put(SaveReportsController());

                        return OutlinedButton.icon(
                          onPressed: saveReportsController.isLoading.value
                              ? null
                              : () {
                                  final result = controller.result;
                                  final apiService = Get.find<ApiService>();
                                  final sessionId =
                                      apiService.recursiveSearch(result, 'session_id') ??
                                      apiService.recursiveSearch(result, 'id') ??
                                      apiService.recursiveSearch(result, 'uuid');

                                  debugPrint('Extracted Session ID for Export: $sessionId');

                                  if (sessionId != null) {
                                    saveReportsController
                                        .exportAndSaveDiagnosticPdf(
                                          sessionId: sessionId.toString(),
                                          diagnosticTitle:
                                              result['title'] ??
                                              'Diagnostic Result',
                                        );
                                  } else {
                                    saveReportsController
                                        .generateAndSaveDiagnosticReport(
                                          diagnosticTitle:
                                              result['title'] ??
                                              'Diagnostic Result',
                                           severity: result['safety_rating'] ??
                                               result['severity_label'] ??
                                               result['severity']?.toString().toUpperCase() ??
                                               'MODERATE SEVERITY',
                                           confidence:
                                               '${result['confidence_level'] ?? result['confidence'] ?? '94'}%',
                                           details: result['summary'] ??
                                               result['ai_assessment'] ??
                                               '',
                                           symptoms: _ensureList(
                                                   result['symptoms'] ??
                                                       result['reported_symptoms'])
                                               .map((e) => e.toString())
                                               .toList(),
                                        );
                                  }
                                },
                          icon: saveReportsController.isLoading.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(
                                  Icons.file_download_outlined,
                                  size: 20,
                                ),
                          label: Flexible(
                            child: Text(
                              saveReportsController.isLoading.value
                                  ? 'Saving...'
                                  : 'Save Report',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
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
                        );
                      }),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.toNamed(Routes.aiChat);
                        },
                        icon: const Icon(Icons.chat_bubble_outline, size: 20),
                        label: const Flexible(
                          child: Text(
                            'Live Chat Support',
                            style: TextStyle(fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
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
                    onPressed: () {
                      Get.toNamed(Routes.addMaintenance);
                    },
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
        );
      }),
    );
  }

  Widget _buildAssessmentCard({
    required String assessment,
    required List symptoms,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Color(0xFF2B63A8),
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Vehicle Assessment',
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 16,
                  fontFamily: 'Archivo',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            assessment,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14,
              fontFamily: 'Inter',
              height: 1.6,
            ),
          ),
          if (symptoms.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text(
              'REPORTED SYMPTOMS',
              style: TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 10,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: symptoms
                  .map((s) => _buildSymptomChip(s.toString()))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSymptomChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF475569),
          fontSize: 12,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildCauseCard({
    required int index,
    required String title,
    required String probLabel,
    required Color probColor,
    required Color probBgColor,
    required String meaning,
    required String whyMatch,
    required String action,
  }) {
    return Obx(() {
      final isExpanded = controller.isExpanded(index);
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => controller.toggleExpansion(index),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFF1E293B),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            probLabel,
                            style: TextStyle(
                              color: probColor,
                              fontSize: 11,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: const Color(0xFF64748B),
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    _buildCauseSection(
                      Icons.info_outline,
                      'What This Means',
                      meaning,
                      const Color(0xFF2B63A8),
                    ),
                    const SizedBox(height: 16),
                    _buildCauseSection(
                      Icons.check_circle_outline,
                      'Why This Matches Your Issue',
                      whyMatch,
                      const Color(0xFF10B981),
                    ),
                    const SizedBox(height: 16),
                    _buildCauseSection(
                      Icons.build_circle_outlined,
                      'Recommended Action',
                      action,
                      const Color(0xFF2B63A8),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    });
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
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 26),
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 13,
              fontFamily: 'Inter',
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepRow(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: const TextStyle(
              color: Color(0xFF2B63A8),
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  List _ensureList(dynamic value) {
    if (value == null) return [];
    if (value is List) return value;
    return [value];
  }
}
