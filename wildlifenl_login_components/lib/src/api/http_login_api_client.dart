import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wildlifenl_login_components/src/api/login_api_client.dart';

/// Standaard auth-API client: POST/PUT naar [baseUrl]/auth/, slaat token op in SharedPreferences.
class HttpLoginApiClient implements LoginApiClient {
  HttpLoginApiClient({
    required this.baseUrl,
    required this.displayNameApp,
    Duration? timeout,
  }) : _timeout = timeout ?? const Duration(seconds: 30);

  final String baseUrl;
  final String displayNameApp;
  final Duration _timeout;

  static const String _tokenKey = 'bearer_token';
  static const String _scopesKey = 'scopes';

  Uri get _authUri => Uri.parse(baseUrl).resolve('auth/');

  @override
  Future<void> sendLoginCode(String displayNameApp, String email) async {
    final body = jsonEncode({
      'displayNameApp': displayNameApp,
      'email': email.trim(),
    });
    final response = await http
        .post(
          _authUri,
          headers: {'Content-Type': 'application/json'},
          body: body,
        )
        .timeout(_timeout);

    if (response.statusCode != HttpStatus.ok) {
      final msg = _tryParseDetail(response.body) ?? response.body;
      throw Exception(msg);
    }
  }

  @override
  Future<Map<String, dynamic>> verifyCode(String email, String code) async {
    final body = jsonEncode({
      'code': code,
      'email': email,
    });
    final response = await http
        .put(
          _authUri,
          headers: {'Content-Type': 'application/json'},
          body: body,
        )
        .timeout(_timeout);

    Map<String, dynamic>? json;
    try {
      json = response.body.isNotEmpty ? jsonDecode(response.body) as Map<String, dynamic>? : null;
    } catch (_) {}

    if (response.statusCode != HttpStatus.ok) {
      final msg = json != null ? (json['detail'] ?? json.toString()) : response.body;
      throw Exception(msg);
    }

    final data = json!;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, data['token'] as String? ?? '');

    try {
      final scopesRaw = data['scopes'];
      if (scopesRaw is List) {
        final scopes = scopesRaw
            .whereType<String>()
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList(growable: false);
        await prefs.setStringList(_scopesKey, scopes);
      } else {
        await prefs.remove(_scopesKey);
      }
    } catch (e) {
      debugPrint('HttpLoginApiClient: failed to store scopes: $e');
    }

    return data;
  }

  static String? _tryParseDetail(String body) {
    try {
      final m = jsonDecode(body);
      if (m is Map && m['detail'] != null) return m['detail'].toString();
    } catch (_) {}
    return null;
  }
}
