import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onFabTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onFabTap,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  // Navigation Items Layout
  final List<Map<String, dynamic>> _navItems = [
    {'svgAsset': 'assets/images/home-2.svg', 'label': 'Home'},
    {'svgAsset': 'assets/images/Diagnose.svg', 'label': 'Diagnose'},
    {'spacer': true}, // Central FAB slot
    {'svgAsset': 'assets/images/maintainance.svg', 'label': 'Maintenance'},
    {'svgAsset': 'assets/images/user.svg', 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    // Screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final width = screenWidth > 360 ? 360.0 : screenWidth;

    return SafeArea(
      child: Center(
        heightFactor: 1.0,
        child: Container(
          width: width,
          height: 64, // Exact hugging height
          // Adjusted padding to keep elements inside 360px balanced
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x3FACACAC),
                blurRadius: 4,
                offset: Offset(0, 0),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                height: 64,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildNavItem(0, _navItems[0]),
                    _buildNavItem(1, _navItems[1]),
                    const SizedBox(
                      width: 70,
                    ), // Placeholder space for the floating AI button
                    _buildNavItem(2, _navItems[3]),
                    _buildNavItem(3, _navItems[4]),
                  ],
                ),
              ),
              Positioned(
                bottom: 24, // Sits above the 64px bar natively
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildFab(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int itemIndex, Map<String, dynamic> item) {
    final isSelected = widget.currentIndex == itemIndex;

    return InkWell(
      onTap: () => widget.onTap(itemIndex),
      customBorder: const CircleBorder(),
      child: SizedBox(
        width: 60,
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (item.containsKey('svgAsset'))
              SvgPicture.asset(
                item['svgAsset'] as String,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  isSelected
                      ? const Color(0xFF2B63A8)
                      : const Color(0xFF8598B2),
                  BlendMode.srcIn,
                ),
              )
            else
              Icon(
                item['icon'] as IconData,
                size: 24,
                color: isSelected
                    ? const Color(0xFF2B63A8)
                    : const Color(0xFF8598B2),
              ),
            const SizedBox(height: 4),
            Text(
              item['label'] as String,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF2B63A8)
                    : const Color(0xFF8598B2),
                fontSize: 12,
                fontFamily: 'Archivo',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFab() {
    return GestureDetector(
      onTap: widget.onFabTap,
      child: Image.asset(
        'assets/images/Popup.png',
        width: 120,
        height: 120,
        fit: BoxFit.contain,
      ),
    );
  }
}
