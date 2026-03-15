import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../utils/responsive_helper.dart';

class MaintenanceTabView extends StatefulWidget {
  const MaintenanceTabView({super.key});

  @override
  State<MaintenanceTabView> createState() => _MaintenanceTabViewState();
}

class _MaintenanceTabViewState extends State<MaintenanceTabView> {
  int _selectedTabIndex = 0; // 0: Upcoming, 1: Overdue, 2: Completed

  Widget _buildPaginationControls(HomeController controller, String status) {
    int page = 1;
    bool hasNext = false;
    bool isLoading = false;

    if (status == 'upcoming') {
      page = controller.upcomingPage;
      hasNext = controller.upcomingHasNext.value;
      isLoading = controller.upcomingIsLoading.value;
    } else if (status == 'overdue') {
      page = controller.overduePage;
      hasNext = controller.overdueHasNext.value;
      isLoading = controller.overdueIsLoading.value;
    } else if (status == 'completed') {
      page = controller.completedPage;
      hasNext = controller.completedHasNext.value;
      isLoading = controller.completedIsLoading.value;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: (page > 1 && !isLoading)
                ? () => controller.previousMaintenanceTasksPage(status)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2B63A8),
              disabledBackgroundColor: Colors.grey.shade300,
              elevation: 0,
            ),
            child: isLoading && page > 1
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text('Previous', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 16),
          Text(
            'Page $page',
            style: const TextStyle(
              color: Color(0xFF62748E),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: (hasNext && !isLoading)
                ? () => controller.nextMaintenanceTasksPage(status)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2B63A8),
              disabledBackgroundColor: Colors.grey.shade300,
              elevation: 0,
            ),
            child: isLoading && hasNext
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text('Next', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTabs(),
        Expanded(
          child: Obx(() {
            final homeController = Get.find<HomeController>();
            return ListView(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.paddingMedium,
                vertical: 16,
              ),
              children: _buildTabContent(homeController),
            );
          }),
        ),
      ],
    );
  }

  List<Widget> _buildTabContent(HomeController controller) {
    switch (_selectedTabIndex) {
      case 0:
        if (controller.upcomingTasks.isEmpty &&
            !controller.upcomingIsLoading.value) {
          return [_buildEmptyState('No upcoming tasks')];
        }
        final widgets = controller.upcomingTasks
            .map(
              (task) => _buildMaintenanceCard(
                taskId: task['id']?.toString() ?? '',
                status: 'UPCOMING',
                title:
                    task['service_type'] ??
                    task['task_type'] ??
                    task['title'] ??
                    'Maintenance Task',
                date:
                    task['next_due_date']?.toString() ??
                    task['due_date']?.toString() ??
                    'N/A',
                mileage: task['mileage'] != null
                    ? '${task['mileage']} mi'
                    : task['due_mileage'] != null
                    ? '${task['due_mileage']} mi'
                    : 'N/A',
                notes: task['notes'] ?? 'No notes provided.',
              ),
            )
            .cast<Widget>()
            .toList();

        widgets.add(_buildPaginationControls(controller, 'upcoming'));
        return widgets;
      case 1:
        if (controller.overdueTasks.isEmpty &&
            !controller.overdueIsLoading.value) {
          return [_buildEmptyState('No overdue tasks')];
        }
        final widgets = controller.overdueTasks
            .map(
              (task) => _buildMaintenanceCard(
                taskId: task['id']?.toString() ?? '',
                status: 'OVERDUE',
                title:
                    task['service_type'] ??
                    task['task_type'] ??
                    task['title'] ??
                    'Maintenance Task',
                date:
                    task['next_due_date']?.toString() ??
                    task['due_date']?.toString() ??
                    'N/A',
                mileage: task['mileage'] != null
                    ? '${task['mileage']} mi'
                    : task['due_mileage'] != null
                    ? '${task['due_mileage']} mi'
                    : 'N/A',
                notes: task['notes'] ?? 'No notes provided.',
              ),
            )
            .cast<Widget>()
            .toList();

        widgets.add(_buildPaginationControls(controller, 'overdue'));
        return widgets;
      case 2:
        if (controller.completedTasks.isEmpty &&
            !controller.completedIsLoading.value) {
          return [
            const SizedBox(height: 80),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check_circle_outline,
                        color: Color(0xFF8598B2),
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No completed tasks',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF62748E),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "You're all caught up!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF90A1B9),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                    ),
                  ),
                ],
              ),
            ),
          ]; // Empty Completed State
        }
        final widgets = controller.completedTasks
            .map(
              (task) => _buildMaintenanceCard(
                taskId: task['id']?.toString() ?? '',
                status: 'COMPLETED',
                title:
                    task['service_type'] ??
                    task['task_type'] ??
                    task['title'] ??
                    'Maintenance Task',
                date:
                    task['completion_date']?.toString() ??
                    task['next_due_date']?.toString() ??
                    task['due_date']?.toString() ??
                    'N/A',
                mileage: task['completion_mileage'] != null
                    ? '${task['completion_mileage']} mi'
                    : task['mileage'] != null
                    ? '${task['mileage']} mi'
                    : task['due_mileage'] != null
                    ? '${task['due_mileage']} mi'
                    : 'N/A',
                notes: task['notes'] ?? 'No notes provided.',
              ),
            )
            .cast<Widget>()
            .toList();

        widgets.add(_buildPaginationControls(controller, 'completed'));
        return widgets;
      default:
        return [];
    }
  }

  Widget _buildEmptyState(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(
            color: Color(0xFF62748E),
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    final homeController = Get.find<HomeController>();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 16),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTabItem(
              label: 'Upcoming',
              index: 0,
              badgeCount: homeController.upcomingCount.value > 0
                  ? homeController.upcomingCount.value
                  : null,
            ),
            _buildTabItem(
              label: 'Overdue',
              index: 1,
              badgeCount: homeController.overdueCount.value > 0
                  ? homeController.overdueCount.value
                  : null,
            ),
            _buildTabItem(
              label: 'Completed',
              index: 2,
              badgeCount: homeController.completedCount.value > 0
                  ? homeController.completedCount.value
                  : null,
              isBlueBadge: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required String label,
    required int index,
    int? badgeCount,
    bool isBlueBadge = false,
  }) {
    bool isSelected = _selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xFF2B63A8)
                      : const Color(0xFF90A1B9),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (badgeCount != null) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isBlueBadge
                        ? const Color(0xFFE4F0FF)
                        : const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badgeCount.toString(),
                    style: TextStyle(
                      color: isBlueBadge
                          ? const Color(0xFF2B63A8)
                          : const Color(0xFFD97706),
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            width: 80,
            color: isSelected ? const Color(0xFF2B63A8) : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceCard({
    required String taskId,
    required String status,
    required String title,
    required String date,
    required String mileage,
    required String notes,
  }) {
    return InkWell(
      onTap: () {
        Get.toNamed(
          '/task-details',
          arguments: {
            'id': taskId,
            'status': status,
            'title': title,
            'date': date,
            'mileage': mileage,
            'notes': notes,
          },
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: status == 'OVERDUE'
                    ? Colors.transparent
                    : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: status == 'OVERDUE'
                  ? Image.asset(
                      'assets/images/cautions.png',
                      fit: BoxFit.contain,
                    )
                  : const Icon(
                      Icons.calendar_today_outlined,
                      color: Color(0xFF2B63A8),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF0F172B),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Archivo',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: Color(0xFF62748E),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Due: $date',
                        style: const TextStyle(
                          color: Color(0xFF62748E),
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.speed_outlined,
                        size: 14,
                        color: Color(0xFF62748E),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        status == 'OVERDUE'
                            ? 'Overdue at $mileage'
                            : 'Interval: $mileage',
                        style: const TextStyle(
                          color: Color(0xFF62748E),
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF90A1B9)),
          ],
        ),
      ),
    );
  }
}
