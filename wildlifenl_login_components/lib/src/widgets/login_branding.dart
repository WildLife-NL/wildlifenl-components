import 'package:flutter/material.dart';
import 'package:wildlifenl_login_components/src/theme/login_theme.dart';
import 'package:wildlifenl_login_components/src/utils/responsive.dart';

class LoginBranding extends StatelessWidget {
  const LoginBranding({
    super.key,
    required this.logoAssetPath,
    required this.appName,
    this.theme = const LoginTheme(),
  });

  final String logoAssetPath;
  final String appName;
  final LoginTheme theme;

  @override
  Widget build(BuildContext context) {
    final ru = context.loginResponsive;
    return Container(
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.zero,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: SingleChildScrollView(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Image.asset(
                      logoAssetPath,
                      width: ru.width > 900 ? ru.wp(9) : ru.wp(14),
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported, color: Colors.white70, size: ru.sp(8)),
                    ),
                  ),
                  SizedBox(width: ru.spacing(8)),
                  Flexible(
                    child: Text(
                      appName,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: ru.fontSize(ru.width > 600 ? 26 : 22),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(bottom: ru.hp(-2.5), right: ru.wp(-2.5), child: const SizedBox.shrink()),
        ],
      ),
    );
  }
}
