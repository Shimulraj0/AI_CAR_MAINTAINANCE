import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MaintenanceTabView extends StatefulWidget {
  const MaintenanceTabView({super.key});

  @override
  State<MaintenanceTabView> createState() => _MaintenanceTabViewState();
}

class _MaintenanceTabViewState extends State<MaintenanceTabView> {
  int _selectedTabIndex = 0; // 0: Upcoming, 1: Overdue, 2: Completed

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildTabs(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: _buildTabContent(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return [
          _buildMaintenanceCard(
            status: 'UPCOMING',
            title: 'Brake Inspection',
            date: '11/15/2023',
            mileage: '50,000 mi',
            notes: 'No additional notes provided for this task.',
          ),
        ]; // Upcoming
      case 1:
        return [
          _buildMaintenanceCard(
            status: 'OVERDUE',
            title: 'Oil Change',
            date: '10/1/2023',
            mileage: '48,000 mi',
            notes: 'Use 5W-30 synthetic.',
          ),
        ]; // Overdue
      case 2:
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
      default:
        return [];
    }
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFF2B63A8),
      padding: const EdgeInsets.only(left: 24, right: 24, top: 48, bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 40), // Spacer for balance
          const Text(
            'Maintenance',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Archivo',
              fontWeight: FontWeight.w600,
            ),
          ),
          InkWell(
            onTap: () {
              Get.toNamed('/add-maintenance');
            },
            borderRadius: BorderRadius.circular(18),
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFFEDF2F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Color(0xFF2B63A8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabItem(label: 'Upcoming', index: 0),
          _buildTabItem(label: 'Overdue', index: 1, badgeCount: 1),
          _buildTabItem(
            label: 'Completed',
            index: 2,
            badgeCount: 1,
            isBlueBadge: true,
          ),
        ],
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
    required String status,
    required String title,
    required String date,
    required String mileage,
    required String notes,
  }) {
    final subtitle = status == 'OVERDUE'
        ? 'Overdue • $mileage'
        : 'Due at $mileage';
    return InkWell(
      onTap: () {
        Get.toNamed(
          '/task-details',
          arguments: {
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
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
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
                        Icons.access_time_outlined,
                        size: 14,
                        color: Color(0xFF62748E),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        date,
                        style: const TextStyle(
                          color: Color(0xFF62748E),
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF90A1B9),
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
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
