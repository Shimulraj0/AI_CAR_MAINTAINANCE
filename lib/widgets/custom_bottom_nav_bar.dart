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

    return Hero(
      tag: 'custom_bottom_nav_bar',
      flightShuttleBuilder:
          (
            flightContext,
            animation,
            flightDirection,
            fromHeroContext,
            toHeroContext,
          ) {
            final Hero toHero = toHeroContext.widget as Hero;
            // The Material widget needs a fixed size during flight to avoid shrinking
            // down to a thin line as constraints change.
            return ClipRect(
              child: OverflowBox(
                maxHeight:
                    120, // Enough to cover the NavigationBar + Floating Action Button
                minHeight: 120,
                alignment: Alignment.bottomCenter,
                child: Material(
                  type: MaterialType.transparency,
                  child: SizedBox(
                    width: screenWidth,
                    height: 120,
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: toHero.child, // Render the exact same nav bar tree
                    ),
                  ),
                ),
              ),
            );
          },
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          child: Center(
            heightFactor: 1.0,
            child: Container(
              width: width,
              height: 64, // Exact hugging height
              // Adjusted padding to keep elements inside 360px balanced
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  20,
                ), // Adding curved corners
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3FACACAC),
                    blurRadius: 10, // Softer shadow
                    offset: Offset(0, -2), // Slight upward offset for the bar
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(child: _buildNavItem(0, _navItems[0])),
                        Expanded(child: _buildNavItem(1, _navItems[1])),
                        const SizedBox(
                          width: 80,
                        ), // Dedicated space for the 72px AI button without invasion
                        Expanded(child: _buildNavItem(2, _navItems[3])),
                        Expanded(child: _buildNavItem(3, _navItems[4])),
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
        width: double.infinity,
        height: double.infinity,
        child: OverflowBox(
          maxHeight: 120, // larger than the item contents to ensure no overflow
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (item.containsKey('svgAsset'))
                FutureBuilder<String>(
                  future: DefaultAssetBundle.of(
                    context,
                  ).loadString(item['svgAsset'] as String),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox(width: 24, height: 24);
                    }

                    String svgString = snapshot.data!;
                    final colorHex = isSelected ? '#2B63A8' : '#8598B2';

                    if (isSelected &&
                        (item['label'] == 'Diagnose' ||
                            item['label'] == 'Profile' ||
                            item['label'] == 'Home')) {
                      // Fill the icon when selected
                      svgString = svgString.replaceAll(
                        'fill="none"',
                        'fill="$colorHex"',
                      );
                      svgString = svgString.replaceAll(
                        'stroke="#8599B3"',
                        'stroke="$colorHex"',
                      );
                    } else {
                      // Default stroke coloring
                      svgString = svgString.replaceAll(
                        'stroke="#8599B3"',
                        'stroke="$colorHex"',
                      );
                      // Maintainaince icon uses fill
                      svgString = svgString.replaceAll(
                        'fill="#8599B3"',
                        'fill="$colorHex"',
                      );
                    }

                    return SvgPicture.string(svgString, width: 24, height: 24);
                  },
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
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  item['label'] as String,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFF2B63A8)
                        : const Color(0xFF8598B2),
                    fontSize: 12,
                    fontFamily: 'Archivo',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFab() {
    return GestureDetector(
      onTap: widget.onFabTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFF2B63A8),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                'assets/images/chatbob.png',
                width: 28,
                height: 28,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
