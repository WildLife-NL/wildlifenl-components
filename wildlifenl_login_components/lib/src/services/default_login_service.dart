import 'package:flutter/material.dart';

import 'package:wildlifenl_login_components/src/api/login_api_client.dart';
import 'package:wildlifenl_login_components/src/interfaces/login_interface.dart';

/// Standaard implementatie van [LoginInterface] die [LoginApiClient] gebruikt.
/// Geschikt voor alle apps die dezelfde WildLife NL auth-backend gebruiken.
class DefaultLoginService implements LoginInterface {
  DefaultLoginService(this._api, {String? displayNameApp})
      : _displayNameApp = displayNameApp ?? 'WildLife NL';

  final LoginApiClient _api;
  final String _displayNameApp;
  final List<VoidCallback> _listeners = [];

  static final _emailRegex = RegExp(
    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
  );

  @override
  String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) return 'Voer een e-mailadres in';
    if (!_emailRegex.hasMatch(email.trim())) return 'Voer een geldig e-mailadres in';
    return null;
  }

  @override
  Future<bool> sendLoginCode(String email) async {
    final err = validateEmail(email);
    if (err != null) throw Exception(err);
    await _api.sendLoginCode(_displayNameApp, email.trim());
    return true;
  }

  @override
  Future<dynamic> verifyCode(String email, String code) async {
    final data = await _api.verifyCode(email, code);
    return data;
  }

  @override
  Future<bool> resendCode(String email) async {
    final err = validateEmail(email);
    if (err != null) throw Exception(err);
    await _api.sendLoginCode(_displayNameApp, email.trim());
    return true;
  }

  @override
  void setVerificationVisible(bool visible) {
    for (final l in _listeners) l();
  }

  @override
  void setError(bool isError, [String message = '']) {
    for (final l in _listeners) l();
  }

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }
}
