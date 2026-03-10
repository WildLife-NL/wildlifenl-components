import 'alarm_animal.dart';
import 'alarm_conveyance.dart';
import 'alarm_zone.dart';

class Alarm {
  const Alarm({
    required this.id,
    required this.timestamp,
    required this.zone,
    this.animal,
    this.conveyances = const [],
    this.detection,
    this.interaction,
  });

  final String id;
  final String timestamp;
  final AlarmZone zone;
  final AlarmAnimal? animal;
  final List<AlarmConveyance> conveyances;
  final Map<String, dynamic>? detection;
  final Map<String, dynamic>? interaction;

  factory Alarm.fromJson(Map<String, dynamic> json) {
    final conveyancesRaw = json['conveyances'];
    final List<AlarmConveyance> list;
    if (conveyancesRaw is List) {
      list = conveyancesRaw
          .map((e) => AlarmConveyance.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      list = const [];
    }
    return Alarm(
      id: json['ID'] as String? ?? json['id'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
      zone: AlarmZone.fromJson(
        json['zone'] as Map<String, dynamic>? ?? {},
      ),
      animal: json['animal'] != null
          ? AlarmAnimal.fromJson(json['animal'] as Map<String, dynamic>)
          : null,
      conveyances: list,
      detection: json['detection'] as Map<String, dynamic>?,
      interaction: json['interaction'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
        'ID': id,
        'timestamp': timestamp,
        'zone': zone.toJson(),
        if (animal != null) 'animal': animal!.toJson(),
        'conveyances': conveyances.map((e) => e.toJson()).toList(),
        if (detection != null) 'detection': detection,
        if (interaction != null) 'interaction': interaction,
      };

  String? get firstMessageText {
    if (conveyances.isEmpty) return null;
    final m = conveyances.first.message;
    return m.body ?? m.title;
  }
}
