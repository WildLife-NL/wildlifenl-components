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
    final uri = Uri.parse(baseUrl.endsWith('/') ? '$baseUrlzone/' : '$baseUrl/zone/');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    final response = await http
        .post(
          uri,
          headers: headers,
          body: jsonEncode(request.toJson()),
        )
        .timeout(_timeout);

    if (response.statusCode == HttpStatus.ok) {
      try {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Zone.fromJson(json);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
