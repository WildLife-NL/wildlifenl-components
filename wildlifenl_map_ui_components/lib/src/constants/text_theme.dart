import 'package:flutter/material.dart';
import 'package:wildlifenl_map_ui_components/src/constants/colors.dart';

/// WildLifeNL text styles. Uses WildLifeNLColors.
class WildLifeNLTextTheme {
  WildLifeNLTextTheme._();

  static TextTheme get textTheme => TextTheme(
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: WildLifeNLColors.brown,
          fontFamily: 'Overpass',
        ),
        titleMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: WildLifeNLColors.brown,
          fontFamily: 'Roboto',
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          color: WildLifeNLColors.brown,
          fontFamily: 'Roboto',
        ),
      );
}
