import 'package:flutter/material.dart';
import 'package:wildlifenl_login_components/src/theme/login_theme.dart';
import 'package:wildlifenl_login_components/src/utils/responsive.dart';

class LoginEmailForm extends StatelessWidget {
  const LoginEmailForm({
    super.key,
    required this.emailController,
    required this.isError,
    required this.errorMessage,
    required this.onLogin,
    required this.onShowRegistrationInfo,
    this.theme = const LoginTheme(),
  });

  final TextEditingController emailController;
  final bool isError;
  final String errorMessage;
  final VoidCallback onLogin;
  final VoidCallback onShowRegistrationInfo;
  final LoginTheme theme;

  @override
  Widget build(BuildContext context) {
    final ru = context.loginResponsive;
    return Transform.translate(
      offset: Offset(0, ru.hp(-2.5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Voer uw e-mailadres in',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ru.fontSize(20),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ru.spacing(12)),
          if (isError) ...[
            Padding(
              padding: EdgeInsets.only(left: ru.wp(2), bottom: ru.hp(0.6)),
              child: Text(
                errorMessage,
                style: TextStyle(
                  color: theme.effectiveErrorColor,
                  fontSize: ru.fontSize(12),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: ru.spacing(8)),
          ],
          SizedBox(height: ru.spacing(8)),
          Container(
            decoration: BoxDecoration(
              color: theme.inputBackgroundColor,
              borderRadius: BorderRadius.circular(ru.sp(3.1)),
              border: Border.all(color: theme.accentColor, width: ru.sp(0.19)),
            ),
            child: TextField(
              controller: emailController,
              minLines: 1,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'e-mailadres',
                hintStyle: TextStyle(color: Colors.grey, fontSize: ru.fontSize(14)),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: ru.wp(5), vertical: ru.hp(1.9)),
              ),
            ),
          ),
          SizedBox(height: ru.spacing(24)),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onLogin,
              style: FilledButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: ru.hp(1.8)),
              ),
              child: Text('Aanmelden', style: TextStyle(fontSize: ru.fontSize(16))),
            ),
          ),
          SizedBox(height: ru.spacing(16)),
          Center(
            child: InkWell(
              onTap: onShowRegistrationInfo,
              child: Text(
                'Hoe werkt de registratie?',
                style: TextStyle(
                  color: theme.accentColor,
                  fontSize: ru.fontSize(14),
                  decoration: TextDecoration.underline,
                  decorationColor: theme.accentColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
