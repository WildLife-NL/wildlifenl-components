import 'package:flutter/material.dart';

import 'package:wildlifenl_map_ui_components/src/constants/colors.dart';
import 'package:wildlifenl_map_ui_components/src/models/bottom_nav_item.dart';

class WildLifeNLBottomNavBar<T> extends StatelessWidget {
  final T currentTab;
  final ValueChanged<T> onTabSelected;
  final List<BottomNavItem<T>> leftItems;
  final List<BottomNavItem<T>> rightItems;
  final BottomNavItem<T> centerItem;

  const WildLifeNLBottomNavBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
    required this.leftItems,
    required this.rightItems,
    required this.centerItem,
  }) : assert(leftItems.length == 2, 'leftItems must contain exactly 2 items'),
       assert(rightItems.length == 2, 'rightItems must contain exactly 2 items');

  static const double _barHeight = 85.0;
  static const double _centerButtonSize = 60.0;
  static const double _centerButtonOffset = -20.0;
  static const double _bumpRadius = 30.0;
  static const double _bumpShoulder = 13.0;
  static const Color _activeColor = Color(0xFF37A904);
  static const Color _inactiveColor = Color(0xFFB0B0B0);
  static const Color _centerButtonColor = Color(0xFF8FBC8F);
  static const double _iconSize = 24.0;
  static const double _fontSize = 12.0;
  static const double _indicatorHeight = 3.0;
  static const double _indicatorWidth = 40.0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          bottom: 45,
          left: screenWidth / 2 - 35,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: _barHeight,
          child: CustomPaint(
            painter: _NavBarCurvePainter(
              backgroundColor: WildLifeNLColors.lightMintGreen100,
              bumpRadius: _bumpRadius,
              bumpShoulder: _bumpShoulder,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: _buildNavItem(leftItems[0]),
                    ),
                    Expanded(
                      child: _buildNavItem(leftItems[1]),
                    ),
                    const SizedBox(width: 60),
                    Expanded(
                      child: _buildNavItem(rightItems[0]),
                    ),
                    Expanded(
                      child: _buildNavItem(rightItems[1]),
                    ),
                  ],
                ),
                Positioned(
                  top: _centerButtonOffset,
                  left: 0,
                  right: 0,
                  child: Center(child: _buildCenterButton()),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(BottomNavItem<T> item) {
    final isSelected = currentTab == item.id;
    final color = isSelected ? _activeColor : _inactiveColor;

    return GestureDetector(
      onTap: () => onTabSelected(item.id),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: _indicatorHeight,
              width: _indicatorWidth,
              decoration: BoxDecoration(
                color: isSelected ? _activeColor : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 4),
            Icon(item.icon, size: _iconSize, color: color),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                fontSize: _fontSize,
                color: color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton() {
    final isSelected = currentTab == centerItem.id;
    final color = isSelected ? _activeColor : _inactiveColor;

    return GestureDetector(
      onTap: () => onTabSelected(centerItem.id),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: _centerButtonSize,
            height: _centerButtonSize,
            decoration: BoxDecoration(
              color: isSelected ? _activeColor : _centerButtonColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Icon(centerItem.icon, size: 28, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            centerItem.label,
            style: TextStyle(
              fontSize: _fontSize,
              color: color,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBarCurvePainter extends CustomPainter {
  final Color backgroundColor;
  final double bumpRadius;
  final double bumpShoulder;

  const _NavBarCurvePainter({
    required this.backgroundColor,
    required this.bumpRadius,
    required this.bumpShoulder,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final path = Path();
    final centerX = size.width / 2;

    path.moveTo(0, 0);
    path.lineTo(centerX - bumpRadius - bumpShoulder, 0);
    path.cubicTo(
      centerX - bumpRadius - 6,
      0,
      centerX - bumpRadius - 3,
      -bumpRadius + 5,
      centerX,
      -bumpRadius,
    );
    path.cubicTo(
      centerX + bumpRadius + 3,
      -bumpRadius + 5,
      centerX + bumpRadius + 6,
      0,
      centerX + bumpRadius + bumpShoulder,
      0,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _NavBarCurvePainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.bumpRadius != bumpRadius ||
        oldDelegate.bumpShoulder != bumpShoulder;
  }
}
