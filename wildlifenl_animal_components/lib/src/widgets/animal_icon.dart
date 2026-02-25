import 'package:flutter/material.dart';
import 'package:wildlifenl_assets/wildlifenl_assets.dart';

const String _assetsPackage = 'wildlifenl_assets';

/// Icoon voor een dier op basis van soortnaam (commonName).
/// Gebruikt de assets uit wildlifenl_assets; bij ontbreken icoon of soort wordt [fallback] getoond.
class AnimalIcon extends StatelessWidget {
  const AnimalIcon({
    super.key,
    this.speciesCommonName,
    required this.size,
    this.fallback,
  });

  final String? speciesCommonName;
  final double size;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    final name = speciesCommonName?.trim();
    if (name == null || name.isEmpty) {
      return SizedBox(
        width: size,
        height: size,
        child: fallback ?? Icon(Icons.pets, size: size, color: Colors.white),
      );
    }
    final fullPath = getAnimalIconPath(name);
    if (fullPath == null) {
      return SizedBox(
        width: size,
        height: size,
        child: fallback ?? Icon(Icons.pets, size: size, color: Colors.white),
      );
    }
    final relativePath = fullPath.replaceFirst('packages/$_assetsPackage/', '');
    return Image.asset(
      relativePath,
      package: _assetsPackage,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => SizedBox(
        width: size,
        height: size,
        child: fallback ?? Icon(Icons.pets, size: size, color: Colors.white),
      ),
    );
  }
}
