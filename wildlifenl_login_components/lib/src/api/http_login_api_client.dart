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

  static const _jsonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  @override
  Future<void> sendLoginCode(String displayNameApp, String email) async {
    // API test-api-wildlifenl.uu.nl verwacht camelCase (displayNameApp), geen snake_case.
    final body = jsonEncode({
      'displayNameApp': displayNameApp,
      'email': email.trim(),
    });
    final response = await http
        .post(_authUri, headers: _jsonHeaders, body: body)
        .timeout(_timeout);

    if (response.statusCode != HttpStatus.ok) {
      if (response.statusCode == 422) {
        debugPrint('Auth 422 response: ${response.body}');
      }
      final msg = _parseErrorResponse(response.statusCode, response.body);
      throw Exception(msg);
    }
  }

  @override
  Future<Map<String, dynamic>> verifyCode(String email, String code) async {
    // Trim voorkomt 422 (API verwacht RFC 5322, geen newline/whitespace in email).
    final body = jsonEncode({
      'email': email.trim(),
      'code': code.trim(),
    });
    final response = await http
        .put(_authUri, headers: _jsonHeaders, body: body)
        .timeout(_timeout);

    Map<String, dynamic>? json;
    try {
      json = response.body.isNotEmpty ? jsonDecode(response.body) as Map<String, dynamic>? : null;
    } catch (_) {}

    if (response.statusCode != HttpStatus.ok) {
      if (response.statusCode == 422) {
        debugPrint('Auth 422 response: ${response.body}');
      }
      final msg = _parseErrorResponse(response.statusCode, response.body, json);
      throw Exception(msg);
    }

    final data = json!;
    final prefs = await SharedPreferences.getInstance();
    // Ondersteun zowel 'token' als 'access_token' (verschillende API-conventies)
    final token = (data['token'] ?? data['access_token'])?.toString().trim();
    await prefs.setString(_tokenKey, token ?? '');

    try {
      // Scopes kunnen top-level of onder data['user'] staan
      var scopesRaw = data['scopes'];
      if (scopesRaw == null && data['user'] is Map) {
        scopesRaw = (data['user'] as Map)['scopes'];
      }
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

  /// Builds a readable error message from API response (e.g. 422 validation errors).
  static String _parseErrorResponse(int statusCode, String body, [Map<String, dynamic>? json]) {
    json ??= (() {
      try {
        return jsonDecode(body) as Map<String, dynamic>?;
      } catch (_) {}
      return null;
    })();
    if (json == null) return body.isNotEmpty ? body : 'HTTP $statusCode';
    // Prefer 'detail' (string or list of validation errors)
    final detail = json['detail'];
    if (detail != null) {
      if (detail is String) return detail;
      if (detail is List) {
        final parts = detail.map((e) {
          if (e is Map && (e['msg'] != null || e['message'] != null)) {
            return (e['msg'] ?? e['message']).toString();
          }
          return e.toString();
        }).toList();
        if (parts.isNotEmpty) return parts.join('; ');
      }
    }
    if (json['message'] != null) return json['message'].toString();
    // Common validation shape: { "field_name": ["error1", "error2"] }
    final errors = json['errors'];
    if (errors is Map) {
      final parts = <String>[];
      for (final entry in errors.entries) {
        final key = entry.key;
        final list = entry.value is List ? entry.value as List : [entry.value];
        for (final v in list) parts.add('$key: $v');
      }
      if (parts.isNotEmpty) return parts.join('; ');
    }
    return body;
  }
}
