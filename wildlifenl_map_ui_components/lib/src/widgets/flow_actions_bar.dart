import 'package:flutter/material.dart';

import 'package:wildlifenl_map_ui_components/src/constants/colors.dart';

/// Generic "Back/Next" action bar for multi-step flows.
///
/// This widget is intentionally app-agnostic so it can be reused
/// across WildLife NL apps such as WildGids and Wildrapport.
class WildLifeNLFlowActionsBar extends StatelessWidget {
  final VoidCallback? onBackPressed;
  final VoidCallback? onNextPressed;
  final bool showNextButton;
  final bool showBackButton;
  final String backLabel;
  final String nextLabel;
  final double height;
  final bool showShadow;

  const WildLifeNLFlowActionsBar({
    super.key,
    this.onBackPressed,
    this.onNextPressed,
    this.showNextButton = true,
    this.showBackButton = true,
    this.backLabel = 'Vorige',
    this.nextLabel = 'Volgende',
    this.height = 96,
    this.showShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    const double buttonHeight = 56;
    const double totalButtonWidth = 280;

    return SizedBox(
      height: height,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showBackButton)
                  SizedBox(
                    width: showNextButton ? totalButtonWidth * 0.45 : totalButtonWidth,
                    height: buttonHeight,
                    child: _ActionButton(
                      label: backLabel,
                      onPressed: onBackPressed,
                      showShadow: showShadow,
                    ),
                  ),
                if (showBackButton && showNextButton) const SizedBox(width: 12),
                if (showNextButton)
                  SizedBox(
                    width: showBackButton ? totalButtonWidth * 0.45 : totalButtonWidth,
                    height: buttonHeight,
                    child: _ActionButton(
                      label: nextLabel,
                      onPressed: onNextPressed,
                      showShadow: showShadow,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool showShadow;

  const _ActionButton({
    required this.label,
    required this.onPressed,
    required this.showShadow,
  });

  @override
  Widget build(BuildContext context) {
    return _HoverAwareButton(
      onPressed: onPressed,
      builder: (active) => AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: active ? WildLifeNLColors.brown : WildLifeNLColors.lightMintGreen100,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: active
                ? WildLifeNLColors.lightMintGreen100
                : WildLifeNLColors.brown,
            width: 1.5,
          ),
          boxShadow: showShadow
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: active ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class _HoverAwareButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget Function(bool active) builder;

  const _HoverAwareButton({required this.onPressed, required this.builder});

  @override
  State<_HoverAwareButton> createState() => _HoverAwareButtonState();
}

class _HoverAwareButtonState extends State<_HoverAwareButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final active = _hovered || _pressed;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: widget.onPressed,
            child: widget.builder(active),
          ),
        ),
      ),
    );
  }
}
