import 'package:flutter/material.dart';

class BottomNavItem<T> {
  final T id;
  final IconData icon;
  final String label;

  const BottomNavItem({
    required this.id,
    required this.icon,
    required this.label,
  });
}
