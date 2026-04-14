class ZoneDefinitionPoint {
  final double latitude;
  final double longitude;

  ZoneDefinitionPoint({required this.latitude, required this.longitude});

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };

  factory ZoneDefinitionPoint.fromJson(Map<String, dynamic> json) =>
      ZoneDefinitionPoint(
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
      );
}

class ZoneCreateRequest {
  final String name;
  final String description;
  final List<ZoneDefinitionPoint> definition;

  ZoneCreateRequest({
    required this.name,
    required this.description,
    required this.definition,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'definition': definition.map((e) => e.toJson()).toList(),
      };
}

class Zone {
  final String id;
  final String created;
  final String? deactivated;
  final List<ZoneDefinitionPoint>? definition;
  final String description;
  final String name;

  Zone({
    required this.id,
    required this.created,
    this.deactivated,
    this.definition,
    required this.description,
    required this.name,
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    List<ZoneDefinitionPoint>? def;
    if (json['definition'] != null) {
      final list = json['definition'] as List;
      def = list
          .map((e) => ZoneDefinitionPoint.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return Zone(
      id: json['ID'] as String,
      created: json['created'] as String,
      deactivated: json['deactivated'] as String?,
      definition: def,
      description: json['description'] as String,
      name: json['name'] as String,
    );
  }
}
