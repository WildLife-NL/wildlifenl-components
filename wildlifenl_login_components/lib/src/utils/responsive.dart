import 'package:flutter/material.dart';

/// Eenvoudige responsive helper binnen de package (geen dependency op map_ui).
class LoginResponsive {
  LoginResponsive(this.context) : size = MediaQuery.sizeOf(context);

  final BuildContext context;
  final Size size;

  double get width => size.width;
  double get height => size.height;

  double wp(double percent) => width * (percent / 100);
  double hp(double percent) => height * (percent / 100);
  double sp(double percent) => width * (percent / 100);
  double fontSize(double base) => base * (width > 600 ? 1.1 : 1.0);
  double spacing(double base) => base * (width > 600 ? 1.2 : 1.0);

  double get breakpointSmall => 600;
  bool get isSideBySide => width >= breakpointSmall;
}

extension LoginResponsiveContext on BuildContext {
  LoginResponsive get loginResponsive => LoginResponsive(this);
}

