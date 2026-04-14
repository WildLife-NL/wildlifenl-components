import 'dart:convert';

import 'alarms_api_client_interface.dart';
import 'models/alarm.dart';

class AlarmsApi {
  AlarmsApi(this.client);

  final AlarmsApiClientInterface client;

  Future<List<Alarm>> getMyAlarms() async {
    final res = await client.get('alarms/me/');
    if (res.statusCode != 200) {
      throw Exception('Alarms ophalen mislukt: ${res.statusCode}');
    }
    final decoded = jsonDecode(res.body);
    if (decoded is! List) return [];
    return decoded
        .map((e) => Alarm.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Alarm>> getAllAlarms() async {
    final res = await client.get('alarms/');
    if (res.statusCode == 403) {
      throw Exception('Geen rechten om alle alarmen te bekijken.');
    }
    if (res.statusCode != 200) {
      throw Exception('Alarmen ophalen mislukt: ${res.statusCode}');
    }
    final decoded = jsonDecode(res.body);
    if (decoded is! List) return [];
    return decoded
        .map((e) => Alarm.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
