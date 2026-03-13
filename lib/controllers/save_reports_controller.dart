import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/save_report_model.dart';
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../services/api_service.dart';
import '../routes/app_routes.dart';

class SaveReportsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final RxList<SaveReportModel> savedReports = <SaveReportModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadReports();
  }

  Future<void> loadReports() async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? reportsJson = prefs.getString('saved_reports');
      
      if (reportsJson != null) {
        final List<dynamic> decoded = json.decode(reportsJson);
        savedReports.value = decoded
            .map((item) => SaveReportModel.fromMap(item as Map<String, dynamic>))
            .toList();
        
        // Sort by date, newest first
        savedReports.sort((a, b) => b.date.compareTo(a.date));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load reports: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveReportsToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = json.encode(
        savedReports.map((report) => report.toMap()).toList(),
      );
      await prefs.setString('saved_reports', encoded);
    } catch (e) {
      Get.snackbar('Error', 'Failed to save reports list: $e');
    }
  }

  Future<void> pickAndSaveReport() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        isLoading.value = true;
        
        final File originalFile = File(result.files.single.path!);
        final Directory appDocsDir = GetPlatform.isAndroid
            ? (await getExternalStorageDirectory()) ?? await getApplicationDocumentsDirectory()
            : await getApplicationDocumentsDirectory();
            
        if (!await appDocsDir.exists()) {
          await appDocsDir.create(recursive: true);
        }
            
        final String fileName = result.files.single.name;
        final String fileExt = '${DateTime.now().millisecondsSinceEpoch}_$fileName';
        final String pathPart = appDocsDir.path;
        final String newPath = '$pathPart/$fileExt';
        
        final File newFile = await originalFile.copy(newPath);
        
        final newReport = SaveReportModel(
          id: const Uuid().v4(),
          title: fileName,
          subtitle: 'Imported Document', // Could be expanded to ask user for details
          filePath: newFile.path,
          date: DateTime.now(),
        );

        savedReports.add(newReport);
        savedReports.sort((a, b) => b.date.compareTo(a.date));
        
        await _saveReportsToStorage();
        Get.snackbar('Success', 'Report saved successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick and save report: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openReport(SaveReportModel report) async {
    final result = await OpenFile.open(report.filePath);
    if (result.type != ResultType.done) {
      Get.snackbar('Error', 'Could not open file: ${result.message}');
    }
  }

  Future<void> deleteReport(SaveReportModel report) async {
    try {
      final file = File(report.filePath);
      if (await file.exists()) {
        await file.delete();
      }
      savedReports.removeWhere((item) => item.id == report.id);
      await _saveReportsToStorage();
      Get.snackbar('Deleted', 'Report deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete report: $e');
    }
  }

  Future<void> generateAndSaveDiagnosticReport({
    required String diagnosticTitle,
    required String severity,
    required String confidence,
    required String details,
    required List<String> symptoms,
  }) async {
    try {
      isLoading.value = true;
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Diagnostic Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                pw.Divider(),
                pw.SizedBox(height: 20),
                pw.Text('Issue: $diagnosticTitle', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Text('Severity: $severity', style: const pw.TextStyle(fontSize: 14)),
                pw.SizedBox(height: 5),
                pw.Text('Confidence: $confidence', style: const pw.TextStyle(fontSize: 14)),
                pw.SizedBox(height: 20),
                pw.Text('AI Assessment:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Text(details, style: const pw.TextStyle(fontSize: 12)),
                pw.SizedBox(height: 20),
                pw.Text('Reported Symptoms:', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: symptoms.map((s) => pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey200,
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                    ),
                    child: pw.Text(s, style: const pw.TextStyle(fontSize: 10)),
                  )).toList(),
                ),
                pw.SizedBox(height: 30),
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Text('Generated by Auto Intel', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
              ],
            );
          },
        ),
      );

      final Directory appDocsDir = GetPlatform.isAndroid
          ? (await getExternalStorageDirectory()) ?? await getApplicationDocumentsDirectory()
          : await getApplicationDocumentsDirectory();

      if (!await appDocsDir.exists()) {
        await appDocsDir.create(recursive: true);
      }

      final String fileName = 'Diagnostic_Report_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final String fullPath = '${appDocsDir.path}/$fileName';

      final File file = File(fullPath);
      await file.writeAsBytes(await pdf.save());

      final newReport = SaveReportModel(
        id: const Uuid().v4(),
        title: 'Diagnostic Report',
        subtitle: diagnosticTitle,
        filePath: file.path,
        date: DateTime.now(),
      );

      savedReports.add(newReport);
      savedReports.sort((a, b) => b.date.compareTo(a.date));

      await _saveReportsToStorage();
      Get.snackbar('Success', 'Diagnostic Report generated and saved');
      Get.toNamed(Routes.saveReports);
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate diagnostic report: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> exportAndSaveDiagnosticPdf({
    required String sessionId,
    required String diagnosticTitle,
  }) async {
    try {
      isLoading.value = true;
      
      final response = await _apiService.exportDiagnosticPdf(sessionId);
      
      if (response.statusCode == 200) {
        final List<int> bytes = response.bodyBytes;
        
        if (bytes.isEmpty) {
          debugPrint('PDF Export Error: Received empty bytes from server');
          Get.snackbar('Error', 'Received empty PDF data from server');
          return;
        }

        final Directory appDocsDir = GetPlatform.isAndroid
            ? (await getExternalStorageDirectory()) ?? await getApplicationDocumentsDirectory()
            : await getApplicationDocumentsDirectory();

        if (!await appDocsDir.exists()) {
          await appDocsDir.create(recursive: true);
        }

        final String fileName = 'Diagnostic_Report_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final String fullPath = '${appDocsDir.path}/$fileName';

        final File file = File(fullPath);
        await file.writeAsBytes(bytes);

        final newReport = SaveReportModel(
          id: const Uuid().v4(),
          title: 'Diagnostic Report',
          subtitle: diagnosticTitle,
          filePath: file.path,
          date: DateTime.now(),
        );

        savedReports.add(newReport);
        savedReports.sort((a, b) => b.date.compareTo(a.date));

        await _saveReportsToStorage();
        Get.snackbar('Success', 'Diagnostic Report downloaded and saved');
        Get.toNamed(Routes.saveReports);
      } else {
        debugPrint('PDF Export Error Status: ${response.statusCode}');
        debugPrint('PDF Export Error Body: ${response.body}');
        
        String errorDetail = '';
        try {
          final errorBody = response.body;
          if (errorBody.isNotEmpty) {
            final decoded = json.decode(errorBody);
            errorDetail = ': ${decoded['error'] ?? decoded['message'] ?? errorBody}';
          }
        } catch (_) {
          errorDetail = ': ${response.reasonPhrase}';
        }
        
        Get.snackbar('Error', 'Failed to export PDF$errorDetail');
      }
    } catch (e, stack) {
      debugPrint('PDF Export Exception: $e');
      debugPrint('PDF Export StackTrace: $stack');
      Get.snackbar('Error', 'An unexpected error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
