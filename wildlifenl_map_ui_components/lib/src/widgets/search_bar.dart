import 'package:flutter/material.dart';
import 'package:wildlifenl_map_ui_components/src/constants/colors.dart';

/// WildLifeNL-styled zoekbalk met icoon en optionele clear-knop.
/// [controller] en [onChanged] bepalen de inhoud; [hint] is de placeholder.
class WildLifeNLSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hint;
  final VoidCallback? onClear;

  const WildLifeNLSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hint = 'Zoeken',
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: WildLifeNLColors.lightMintGreen,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: WildLifeNLColors.darkGreen, width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.search, color: WildLifeNLColors.darkGreen),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                suffixIcon: (controller.text.isNotEmpty && onClear != null)
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: WildLifeNLColors.darkGreen),
                        onPressed: onClear,
                      )
                    : null,
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
