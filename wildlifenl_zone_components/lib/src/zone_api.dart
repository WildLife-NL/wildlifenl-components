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

  Future<Zone?> addZone(ZoneCreateRequest request) async {
    final token = await getToken();
    final uri = Uri.parse(baseUrl.endsWith('/') ? '${baseUrl}zone/' : '$baseUrl/zone/');
    final headers = _headers(token);
    final response = await http
        .post(uri, headers: headers, body: jsonEncode(request.toJson()))
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
    final headers = _headers(token);
    final response = await http
        .post(
          uri,
          headers: headers,
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

  Map<String, String> _headers(String? token) {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }
}
