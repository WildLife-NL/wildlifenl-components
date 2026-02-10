import 'package:flutter/material.dart';
import 'package:wildlifenl_map_ui_components/src/constants/colors.dart';

/// Circular container for an icon or image. WildLifeNL style.
class CircleIconContainer extends StatelessWidget {
  final double? size;
  final Color? backgroundColor;
  final IconData? icon;
  final String? imagePath;
  final Color? iconColor;
  final double? iconSize;
  final bool showShadow;

  const CircleIconContainer({
    super.key,
    this.size = 38.0,
    this.backgroundColor,
    this.icon,
    this.imagePath,
    this.iconColor,
    this.iconSize,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? WildLifeNLColors.offWhite,
        shape: BoxShape.circle,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(child: _buildContent()),
    );
  }

  Widget? _buildContent() {
    if (icon != null) {
      return Icon(
        icon,
        color: iconColor ?? WildLifeNLColors.brown,
        size: iconSize ?? (size! * 0.5),
      );
    }
    if (imagePath != null) {
      return Image.asset(
        imagePath!,
        width: iconSize ?? (size! * 0.5),
        height: iconSize ?? (size! * 0.5),
        fit: BoxFit.contain,
      );
    }
    return null;
  }
}
