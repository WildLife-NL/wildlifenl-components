import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../interfaces/visitation_read_api_interface.dart';
import '../models/visitation_response.dart';

const String _tokenKey = 'bearer_token';
const Duration _timeout = Duration(seconds: 30);

class HttpVisitationReadApi implements VisitationReadApiInterface {
  HttpVisitationReadApi({
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
  Future<VisitationResponse> getVisitationForLivingLab({
    required String livingLabID,
    required DateTime start,
    required DateTime end,
    required double cellSize,
  }) async {
    if (cellSize < 20 || cellSize > 10000) {
      throw ArgumentError('cellSize must be between 20 and 10000 (meters)');
    }
    final params = <String, String>{
      'livingLabID': livingLabID,
      'start': start.toUtc().toIso8601String(),
      'end': end.toUtc().toIso8601String(),
      'cellSize': cellSize.toString(),
    };
    final query = Uri(queryParameters: params).query;
    final path = 'visitation/?$query';
    final res = await _get(path);

    if (res.statusCode != HttpStatus.ok) {
      print('[HttpVisitationReadApi] getVisitationForLivingLab: ${res.statusCode}');
      if (res.statusCode == 401) {
        throw Exception('Unauthorized (401) on GET /visitation/');
      }
      throw Exception('Failed to get visitation: ${res.statusCode}');
    }

    final body = res.body.trim();
    if (body.isEmpty) {
      return const VisitationResponse(cells: []);
    }

    final decoded = jsonDecode(body) as Map<String, dynamic>;
    return VisitationResponse.fromJson(decoded);
  }
}
