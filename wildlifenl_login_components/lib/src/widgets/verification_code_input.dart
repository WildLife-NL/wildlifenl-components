import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wildlifenl_login_components/src/interfaces/login_interface.dart';
import 'package:wildlifenl_login_components/src/theme/login_theme.dart';
import 'package:wildlifenl_login_components/src/utils/responsive.dart';

class VerificationCodeInput extends StatefulWidget {
  const VerificationCodeInput({
    super.key,
    required this.email,
    required this.onBack,
    required this.onVerificationSuccess,
    this.theme = const LoginTheme(),
    this.loadingWidget,
  });

  final String email;
  final VoidCallback onBack;
  final void Function(BuildContext context, dynamic user) onVerificationSuccess;
  final LoginTheme theme;
  final Widget? loadingWidget;

  @override
  State<VerificationCodeInput> createState() => _VerificationCodeInputState();
}

class _VerificationCodeInputState extends State<VerificationCodeInput> {
  final List<TextEditingController> controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
  late final LoginInterface loginManager;
  bool isLoading = false;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    loginManager = context.read<LoginInterface>();
  }

  Future<void> _verifyCode() async {
    FocusScope.of(context).unfocus();
    final code = controllers.map((c) => c.text).join();

    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      final user = await loginManager.verifyCode(widget.email, code);
      if (!mounted) return;
      widget.onVerificationSuccess(context, user);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        isError = true;
      });
      for (var c in controllers) c.clear();
      focusNodes[0].requestFocus();
    }
  }

  Widget _buildTextField(int index) {
    final ru = context.loginResponsive;
    final boxWidth = ru.width > 600 ? ru.wp(10) : ru.wp(13);
    final fontSize = ru.fontSize(22);

    return Container(
      width: boxWidth,
      height: boxWidth * 1.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ru.sp(1.5)),
        color: isError ? Colors.red.shade50 : Colors.white,
        border: Border.all(
          color: isError ? Colors.red.shade300 : Colors.grey,
          width: ru.sp(0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (KeyEvent event) {
          if (event is! KeyDownEvent) return;
          if (event.logicalKey == LogicalKeyboardKey.backspace &&
              controllers[index].text.isEmpty &&
              index > 0) {
            focusNodes[index - 1].requestFocus();
            controllers[index - 1].clear();
          }
        },
        child: TextField(
          controller: controllers[index],
          focusNode: focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.black),
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) {
            if (isError) setState(() => isError = false);
            if (value.isNotEmpty) {
              if (index < 5) {
                focusNodes[index + 1].requestFocus();
              } else if (index == 5 && controllers.every((c) => c.text.isNotEmpty)) {
                _verifyCode();
              }
            } else if (value.isEmpty && index > 0) {
              focusNodes[index - 1].requestFocus();
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ru = context.loginResponsive;
    final theme = widget.theme;

    if (isLoading) {
      return Center(
        child: widget.loadingWidget ??
            SizedBox(
              width: ru.sp(12),
              height: ru.sp(12),
              child: CircularProgressIndicator(color: theme.primaryColor),
            ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                widget.onBack();
              },
              icon: Icon(Icons.arrow_back_rounded, color: theme.accentColor),
            ),
            Text(
              'Voer de verificatiecode in',
              style: TextStyle(
                fontSize: ru.fontSize(16),
                fontWeight: FontWeight.w500,
                color: theme.accentColor,
              ),
            ),
          ],
        ),
        if (isError) ...[
          Padding(
            padding: EdgeInsets.only(left: ru.wp(5), top: ru.hp(1.2)),
            child: Text(
              'Verkeerde code. Probeer het opnieuw.',
              style: TextStyle(
                color: theme.effectiveErrorColor,
                fontSize: ru.fontSize(14),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
        SizedBox(height: ru.spacing(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (i) => _buildTextField(i)),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _verifyCode,
            style: FilledButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: ru.hp(1.8)),
            ),
            child: Text('Verifiëren', style: TextStyle(fontSize: ru.fontSize(16))),
          ),
        ),
        SizedBox(height: ru.spacing(15)),
        Center(
          child: TextButton(
            onPressed: _resendCode,
            child: Text(
              'Code niet ontvangen? Stuur opnieuw',
              style: TextStyle(color: theme.accentColor, decoration: TextDecoration.underline),
            ),
          ),
        ),
        const Spacer(flex: 2),
      ],
    );
  }

  Future<void> _resendCode() async {
    try {
      await loginManager.resendCode(widget.email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verificatiecode opnieuw verzonden')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kon code niet verzenden. Probeer het later opnieuw.')),
      );
    }
  }

  @override
  void dispose() {
    for (var c in controllers) c.dispose();
    for (var n in focusNodes) n.dispose();
    super.dispose();
  }
}
