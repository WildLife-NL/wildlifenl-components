import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../interfaces/interaction_read_api_interface.dart';
import '../models/add_interaction_input.dart';

const String _tokenKey = 'bearer_token';
const Duration _timeout = Duration(seconds: 30);

/// Standaardimplementatie: GET interactions/me/, GET interactions/,
/// GET interaction/{id} en POST interaction/ met Bearer token uit SharedPreferences.
class HttpInteractionReadApi implements InteractionReadApiInterface {
  HttpInteractionReadApi({
    required this.baseUrl,
  });

  final String baseUrl;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<http.Response> _get(String path) async {
    final token = await _getToken();
    final uri = Uri.parse(baseUrl).resolve(path);
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    final res = await http.get(uri, headers: headers).timeout(_timeout);
    return res;
  }

  Future<http.Response> _post(String path, Map<String, dynamic> body) async {
    final token = await _getToken();
    final uri = Uri.parse(baseUrl).resolve(path);
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    final res = await http
        .post(uri, headers: headers, body: jsonEncode(body))
        .timeout(_timeout);
    return res;
  }

  @override
  Future<List<Map<String, dynamic>>> getMyInteractions() async {
    final res = await _get('interactions/me/');
    if (res.statusCode != HttpStatus.ok) {
      debugPrint('[HttpInteractionReadApi] getMyInteractions: ${res.statusCode}');
      throw Exception('Failed to get my interactions: ${res.statusCode}');
    }
    final body = res.body.trim();
    if (body.isEmpty) return [];
    final decoded = jsonDecode(body);
    if (decoded is! List) return [];
    return decoded
        .whereType<Map<String, dynamic>>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  @override
  Future<Map<String, dynamic>> getInteractionById(String id) async {
    final res = await _get('interaction/$id');
    if (res.statusCode != HttpStatus.ok) {
      if (res.statusCode == HttpStatus.unauthorized) {
        throw Exception('Unauthorized (401) on interaction/$id');
      }
      if (res.statusCode == HttpStatus.notFound) {
        throw Exception('Interaction not found (404): $id');
      }
      throw Exception('Get interaction failed (${res.statusCode}): ${res.body}');
    }

    final body = res.body.trim();
    if (body.isEmpty) return <String, dynamic>{};
    final decoded = jsonDecode(body);
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
    throw Exception('Unexpected response shape for GET /interaction/{id}');
  }

  @override
  Future<List<Map<String, dynamic>>> queryInteractions({
    required double latitude,
    required double longitude,
    required int radius,
    DateTime? start,
    DateTime? end,
    DateTime? momentAfter,
    DateTime? momentBefore,
  }) async {
    final resolvedStart = start ?? momentAfter;
    final resolvedEnd = end ?? momentBefore;

    if (resolvedStart == null || resolvedEnd == null) {
      throw ArgumentError('queryInteractions requires start and end DateTime');
    }

    final params = <String, String>{
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'radius': radius.toString(),
      'start': resolvedStart.toUtc().toIso8601String(),
      'end': resolvedEnd.toUtc().toIso8601String(),
    };
    final query = Uri(queryParameters: params).query;
    final path = 'interactions/?$query';
    final res = await _get(path);

    if (res.statusCode == HttpStatus.ok) {
      final body = res.body.trim();
      if (body.isEmpty) return [];
      final decoded = jsonDecode(body);
      final List list = decoded is List
          ? decoded
          : (decoded is Map && decoded['items'] is List)
              ? decoded['items'] as List
              : const [];
      return list
          .whereType<Map<String, dynamic>>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    if (res.statusCode == HttpStatus.noContent ||
        res.statusCode == HttpStatus.notFound) {
      return [];
    }
    if (res.statusCode == HttpStatus.unauthorized) {
      throw Exception('Unauthorized (401) on interactions/');
    }
    if (res.statusCode == HttpStatus.unprocessableEntity) {
      throw Exception('Validation failed (422) on interactions/: ${res.body}');
    }
    throw Exception('Query failed (${res.statusCode}): ${res.body}');
  }

  @override
  Future<Map<String, dynamic>> addInteraction(AddInteractionInput input) async {
    final res = await _post('interaction/', input.toJson());

    if (res.statusCode != HttpStatus.ok) {
      if (res.statusCode == HttpStatus.unauthorized) {
        throw Exception('Unauthorized (401) on POST /interaction/');
      }
      throw Exception('Add interaction failed (${res.statusCode}): ${res.body}');
    }

    final body = res.body.trim();
    if (body.isEmpty) return <String, dynamic>{};

    final decoded = jsonDecode(body);
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
    throw Exception('Unexpected response shape for POST /interaction/');
  }
}
