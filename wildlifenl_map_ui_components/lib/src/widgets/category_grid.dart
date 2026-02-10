import 'package:flutter/material.dart';
import 'package:wildlifenl_map_ui_components/src/constants/colors.dart';
import 'package:wildlifenl_map_ui_components/src/models/category_grid_item.dart';
import 'package:wildlifenl_map_ui_components/src/widgets/circle_icon_container.dart';
import 'package:wildlifenl_map_ui_components/src/widgets/back_button.dart';

/// WildLifeNL grid van selecteerbare categorieën (icoon + tekst).
/// [items]: lijst met text + optioneel iconPath (asset).
/// [onItemSelected]: wordt aangeroepen met de gekozen item.text.
/// [onBackPressed]: optioneel; als gezet wordt onderaan een Terug-knop getoond.
class WildLifeNLCategoryGrid extends StatelessWidget {
  final List<CategoryGridItem> items;
  final ValueChanged<String> onItemSelected;
  final VoidCallback? onBackPressed;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;

  const WildLifeNLCategoryGrid({
    super.key,
    required this.items,
    required this.onItemSelected,
    this.onBackPressed,
    this.crossAxisCount = 3,
    this.mainAxisSpacing = 16,
    this.crossAxisSpacing = 8,
    this.childAspectRatio = 0.75,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 16),
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          childAspectRatio: childAspectRatio,
          children: items
              .map(
                (item) => LayoutBuilder(
                  builder: (context, constraints) {
                    final circleSize = constraints.maxWidth * 1.0;
                    return GestureDetector(
                      onTap: () => onItemSelected(item.text),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleIconContainer(
                            size: circleSize,
                            backgroundColor: WildLifeNLColors.brown,
                            imagePath: item.iconPath,
                            iconColor: Colors.white,
                            iconSize: circleSize * 0.8,
                          ),
                          const SizedBox(height: 8),
                          Flexible(
                            child: Text(
                              item.text,
                              style: const TextStyle(
                                color: WildLifeNLColors.brown,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
              .toList(),
        ),
        if (onBackPressed != null) WildLifeNLBackButton(onPressed: onBackPressed!),
      ],
    );
  }
}
