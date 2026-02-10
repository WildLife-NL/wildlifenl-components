import 'package:flutter/material.dart';
import 'package:wildlifenl_map_ui_components/src/constants/colors.dart';

/// WildLifeNL-styled filter dropdown. Geef [value] en [items]; [onChanged] wordt aangeroepen bij selectie.
/// Herbruikbaar voor categorie-, type- of andere filters in lijsten/overzichten.
class WildLifeNLFilterDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hint;
  final bool isExpanded;
  final double? height;

  const WildLifeNLFilterDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint = 'Alle',
    this.isExpanded = true,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: WildLifeNLColors.darkGreen, width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : null,
          isExpanded: isExpanded,
          hint: Text(hint),
          items: items
              .map(
                (e) => DropdownMenuItem(value: e, child: Text(e)),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
