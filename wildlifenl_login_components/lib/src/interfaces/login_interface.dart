import 'package:flutter/material.dart';

/// Interface voor login-logica: e-mailvalidatie, code versturen/verifiëren.
/// De app implementeert deze (bijv. via AuthApi) en registreert die via Provider.
abstract class LoginInterface {
  String? validateEmail(String? email);
  Future<bool> sendLoginCode(String email);
  Future<dynamic> verifyCode(String email, String code);
  Future<bool> resendCode(String email);
  void setVerificationVisible(bool visible);
  void setError(bool isError, [String message = '']);
  void addListener(VoidCallback listener);
  void removeListener(VoidCallback listener);
}
