import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../interfaces/animal_read_api_interface.dart';

const String _tokenKey = 'bearer_token';
const Duration _timeout = Duration(seconds: 30);
const int _minRadiusMeters = 1;
const int _maxRadiusMeters = 10000;

/// Standaardimplementatie: GET animals/ met query params en Bearer token.
class HttpAnimalReadApi implements AnimalReadApiInterface {
  HttpAnimalReadApi({
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

  @override
  Future<List<Map<String, dynamic>>> getAnimalsInSpan({
    required DateTime start,
    required DateTime end,
    required double latitude,
    required double longitude,
    required int radius,
  }) async {
    final r = radius.clamp(_minRadiusMeters, _maxRadiusMeters);
    final params = <String, String>{
      'start': start.toUtc().toIso8601String(),
      'end': end.toUtc().toIso8601String(),
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'radius': r.toString(),
    };
    final query = Uri(queryParameters: params).query;
    final path = 'animals/?$query';
    final res = await _get(path);

    if (res.statusCode == 200) {
      final body = res.body.trim();
      if (body.isEmpty) return [];
      final decoded = jsonDecode(body);
      final List list = decoded is List
          ? decoded
          : (decoded is Map && decoded['items'] is List)
              ? decoded['items'] as List
              : (decoded is Map && decoded['results'] is List)
                  ? decoded['results'] as List
                  : const [];
      return list
          .whereType<Map<String, dynamic>>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    if (res.statusCode == 204 || res.statusCode == 404) return [];
    if (res.statusCode == 401) throw Exception('Unauthorized (401) on GET animals/');
    throw Exception('Animals request failed (${res.statusCode}): ${res.body}');
  }
}
