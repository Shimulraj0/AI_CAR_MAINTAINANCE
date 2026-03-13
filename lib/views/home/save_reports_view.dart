import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/save_reports_controller.dart';
import '../../routes/app_routes.dart';
class SaveReportsView extends StatelessWidget {
  const SaveReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    // Controller is initialized via AppPages binding
    final SaveReportsController saveReportsController = Get.find<SaveReportsController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Save Reports',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => saveReportsController.pickAndSaveReport(),
          ),
        ],
      ),
      body: Obx(() {
        if (saveReportsController.isLoading.value && saveReportsController.savedReports.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (saveReportsController.savedReports.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.description_outlined, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No saved reports yet',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => saveReportsController.pickAndSaveReport(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Document'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B63A8),
                    foregroundColor: Colors.white,
                  ),
                )
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          itemCount: saveReportsController.savedReports.length,
          itemBuilder: (context, index) {
            final report = saveReportsController.savedReports[index];
            final String dateFormat = "${report.date.year}-${report.date.month.toString().padLeft(2, '0')}-${report.date.day.toString().padLeft(2, '0')}";
            
            // Alternate colors for standard look
            final isOdd = index % 2 != 0;
            final iconBgColor = isOdd ? const Color(0xFFFEF2F2) : const Color(0xFFFFF7ED);
            final iconColor = isOdd ? const Color(0xFFE7000B) : const Color(0xFFFF6900);
            final String subtitleText = '${report.subtitle} • $dateFormat';

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Dismissible(
                key: Key(report.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => saveReportsController.deleteReport(report),
                child: GestureDetector(
                  onTap: () => saveReportsController.openReport(report),
                  child: _buildReportCard(
                    title: report.title,
                    subtitle: subtitleText,
                    iconBgColor: iconBgColor,
                    iconColor: iconColor,
                  ),
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3, // Assuming 3 is Profile
        onTap: (index) {
          homeController.changeTabIndex(index);
          Get.offAllNamed(Routes.home);
        },
        onFabTap: () {
          Get.offAllNamed(Routes.home);
          Get.toNamed(Routes.aiChat);
        },
      ),
    );
  }

  Widget _buildReportCard({
    required String title,
    required String subtitle,
    required Color iconBgColor,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.description_outlined,
                      color: iconColor,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF0F172B),
                          fontSize: 16,
                          fontFamily: 'Archivo',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF62748E),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Color(0xFF8598B2), size: 24),
        ],
      ),
    );
  }
}
