import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wildlifenl_login_components/src/interfaces/login_interface.dart';
import 'package:wildlifenl_login_components/src/theme/login_theme.dart';
import 'package:wildlifenl_login_components/src/utils/responsive.dart';
import 'package:wildlifenl_login_components/src/widgets/login_branding.dart';
import 'package:wildlifenl_login_components/src/widgets/login_email_form.dart';
import 'package:wildlifenl_login_components/src/widgets/verification_code_input.dart';

/// Configuratie voor [WildLifeNLLoginScreen]. De app vult o.a. branding en callbacks in.
class WildLifeNLLoginConfig {
  const WildLifeNLLoginConfig({
    required this.logoAssetPath,
    required this.appName,
    required this.onLoginSuccess,
    this.theme = const LoginTheme(),
    this.registrationInfoWidget,
    this.showErrorDialog,
    this.loadingWidget,
  });

  final String logoAssetPath;
  final String appName;
  final void Function(BuildContext context, dynamic user) onLoginSuccess;
  final LoginTheme theme;
  final Widget? registrationInfoWidget;
  final void Function(BuildContext context, List<String> messages)? showErrorDialog;
  final Widget? loadingWidget;
}

/// Volledige loginpagina: branding + e-mailformulier of verificatiecode.
/// Verwacht dat [LoginInterface] via Provider is geregistreerd.
class WildLifeNLLoginScreen extends StatefulWidget {
  const WildLifeNLLoginScreen({
    super.key,
    required this.config,
  });

  final WildLifeNLLoginConfig config;

  @override
  State<WildLifeNLLoginScreen> createState() => _WildLifeNLLoginScreenState();
}

class _WildLifeNLLoginScreenState extends State<WildLifeNLLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  bool showVerification = false;
  bool isError = false;
  String errorMessage = '';
  String? _pendingErrorMessage;
  String? _pendingErrorDetail;

  late final LoginInterface _loginManager;

  @override
  void initState() {
    super.initState();
    _loginManager = context.read<LoginInterface>();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _showError(List<String> messages) {
    if (widget.config.showErrorDialog != null) {
      widget.config.showErrorDialog!(context, messages);
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Fout'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: messages.map((m) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(m),
            )).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleLogin() {
    final validationError = _loginManager.validateEmail(emailController.text);
    if (validationError != null) {
      _showError([validationError]);
      return;
    }

    setState(() {
      isError = false;
      errorMessage = '';
      showVerification = true;
      _pendingErrorMessage = null;
      _pendingErrorDetail = null;
    });

    _loginManager.sendLoginCode(emailController.text).then((ok) {
      if (!ok) _pendingErrorMessage = 'Login mislukt. Probeer het later opnieuw.';
    }).catchError((e) {
      String msg = 'Er is een fout opgetreden. Probeer het later opnieuw.';
      final err = e.toString();
      if (err.contains('timed out') || err.contains('TimeoutException')) {
        msg = 'De server reageert niet. Controleer uw internet of probeer het later opnieuw.';
      } else if (err.contains('Unauthorized') || err.contains('401')) {
        msg = 'Ongeldige inloggegevens. Controleer uw e-mailadres en probeer het opnieuw.';
      } else if (err.contains('SocketException') || err.contains('Connection refused') ||
          err.contains('Connection failed') || err.contains('HandshakeException') ||
          err.contains('CertificateException') || err.contains('Network is unreachable')) {
        msg = 'Kan geen verbinding maken met de server. Controleer uw internet of probeer het later opnieuw.';
      }
      _pendingErrorMessage = msg;
      _pendingErrorDetail = err.length > 180 ? '${err.substring(0, 180)}…' : err;
    }).whenComplete(() {
      if (_pendingErrorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() => showVerification = false);
          _showError([
            _pendingErrorMessage!,
            if (_pendingErrorDetail != null && _pendingErrorDetail!.isNotEmpty) 'Technische info: $_pendingErrorDetail',
          ]);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ru = context.loginResponsive;
    final theme = widget.config.theme;
    final isSideBySide = ru.isSideBySide;
    final showTwoColumn = ru.width >= 900;

    final branding = LoginBranding(
      logoAssetPath: widget.config.logoAssetPath,
      appName: widget.config.appName,
      theme: theme,
    );

    final form = Padding(
      padding: EdgeInsets.all(ru.spacing(20)),
      child: showVerification
          ? VerificationCodeInput(
              email: emailController.text,
              onBack: () => setState(() => showVerification = false),
              onVerificationSuccess: (ctx, user) => widget.config.onLoginSuccess(ctx, user),
              theme: theme,
              loadingWidget: widget.config.loadingWidget,
            )
          : LoginEmailForm(
              emailController: emailController,
              isError: isError,
              errorMessage: errorMessage,
              onLogin: _handleLogin,
              onShowRegistrationInfo: () {
                if (widget.config.registrationInfoWidget != null) {
                  showDialog(
                    context: context,
                    builder: (ctx) => Dialog(child: widget.config.registrationInfoWidget),
                  );
                }
              },
              theme: theme,
            ),
    );

    return Scaffold(
      body: isSideBySide
          ? Row(
              children: [
                Expanded(flex: showTwoColumn ? 3 : 2, child: branding),
                Expanded(
                  flex: showTwoColumn ? 4 : 3,
                  child: SingleChildScrollView(child: form),
                ),
              ],
            )
          : Column(
              children: [
                Expanded(flex: 1, child: branding),
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(child: form),
                ),
              ],
            ),
    );
  }
}
