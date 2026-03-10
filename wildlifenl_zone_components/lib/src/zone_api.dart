import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'zone_models.dart';

class ZoneApi {
  final String baseUrl;
  final Future<String?> Function() getToken;

  ZoneApi({
    required this.baseUrl,
    required this.getToken,
  });

  static const Duration _timeout = Duration(seconds: 30);

  Map<String, String> _headers(String? token) {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<Zone>> getMyZones() async {
    final token = await getToken();
    final uri = Uri.parse(baseUrl.endsWith('/') ? '${baseUrl}zones/me/' : '$baseUrl/zones/me/');
    final response = await http.get(uri, headers: _headers(token)).timeout(_timeout);
    if (response.statusCode != HttpStatus.ok) return [];
    try {
      final list = jsonDecode(response.body) as List;
      return list.map((e) => Zone.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<Zone?> addZone(ZoneCreateRequest request) async {
    final token = await getToken();
    final uri = Uri.parse(baseUrl.endsWith('/') ? '${baseUrl}zone/' : '$baseUrl/zone/');
    final response = await http
        .post(uri, headers: _headers(token), body: jsonEncode(request.toJson()))
        .timeout(_timeout);
    if (response.statusCode == HttpStatus.ok) {
      try {
        return Zone.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } catch (_) {}
    }
    return null;
  }

  Future<Zone?> addSpeciesToZone(String zoneId, String speciesId) async {
    final token = await getToken();
    final uri = Uri.parse(baseUrl.endsWith('/') ? '${baseUrl}zone/species/' : '$baseUrl/zone/species/');
    final response = await http
        .post(
          uri,
          headers: _headers(token),
          body: jsonEncode({'zoneID': zoneId, 'speciesID': speciesId}),
        )
        .timeout(_timeout);
    if (response.statusCode == HttpStatus.ok) {
      try {
        return Zone.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } catch (_) {}
    }
    return null;
  }
}
