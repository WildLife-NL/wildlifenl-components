class InteractionGeoPoint {
  const InteractionGeoPoint({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  static InteractionGeoPoint? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final lat = _toDouble(json['latitude']);
    final lng = _toDouble(json['longitude']);
    if (lat == null || lng == null) return null;
    return InteractionGeoPoint(latitude: lat, longitude: lng);
  }
}

class InteractionTypeInfo {
  const InteractionTypeInfo({
    required this.id,
    required this.name,
    required this.description,
  });

  final int id;
  final String name;
  final String description;

  static InteractionTypeInfo? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final id = _toInt(json['ID'] ?? json['id']);
    final name = _toString(json['name']);
    final description = _toString(json['description']);
    if (id == null || name == null || description == null) return null;
    return InteractionTypeInfo(id: id, name: name, description: description);
  }
}

class InteractionUserInfo {
  const InteractionUserInfo({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  static InteractionUserInfo? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final id = _toString(json['ID'] ?? json['id']);
    final name = _toString(json['name']);
    if (id == null || name == null) return null;
    return InteractionUserInfo(id: id, name: name);
  }
}

class InteractionSpeciesInfo {
  const InteractionSpeciesInfo({
    required this.id,
    required this.commonName,
    required this.latinName,
    this.category,
    this.description,
    this.advice,
    this.behaviour,
    this.roleInNature,
  });

  final String id;
  final String commonName;
  final String latinName;
  final String? category;
  final String? description;
  final String? advice;
  final String? behaviour;
  final String? roleInNature;

  static InteractionSpeciesInfo? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final id = _toString(json['ID'] ?? json['id']);
    final commonName = _toString(json['commonName']);
    final latinName = _toString(json['name']);
    if (id == null || commonName == null || latinName == null) return null;
    return InteractionSpeciesInfo(
      id: id,
      commonName: commonName,
      latinName: latinName,
      category: _toString(json['category']),
      description: _toString(json['description']),
      advice: _toString(json['advice']),
      behaviour: _toString(json['behaviour']),
      roleInNature: _toString(json['roleInNature']),
    );
  }
}

class InteractionQuestionnaireInfo {
  const InteractionQuestionnaireInfo({
    required this.id,
    required this.name,
    this.identifier,
    this.questions,
  });

  final String id;
  final String name;
  final String? identifier;
  final List<dynamic>? questions;

  static InteractionQuestionnaireInfo? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final id = _toString(json['ID'] ?? json['id']);
    final name = _toString(json['name']);
    if (id == null || name == null) return null;
    return InteractionQuestionnaireInfo(
      id: id,
      name: name,
      identifier: _toString(json['identifier']),
      questions: json['questions'] is List ? json['questions'] as List : null,
    );
  }
}

class InteractionRecord {
  const InteractionRecord({
    required this.id,
    required this.description,
    required this.location,
    required this.place,
    required this.moment,
    required this.timestamp,
    required this.type,
    required this.user,
    this.schema,
    this.questionnaire,
    this.reportOfSighting,
    this.reportOfDamage,
    this.reportOfCollision,
    this.species,
    this.raw,
  });

  final String id;
  final String description;
  final InteractionGeoPoint location;
  final InteractionGeoPoint place;
  final DateTime moment;
  final DateTime timestamp;
  final InteractionTypeInfo type;
  final InteractionUserInfo user;
  final String? schema;
  final InteractionQuestionnaireInfo? questionnaire;
  final Map<String, dynamic>? reportOfSighting;
  final Map<String, dynamic>? reportOfDamage;
  final Map<String, dynamic>? reportOfCollision;
  final InteractionSpeciesInfo? species;
  final Map<String, dynamic>? raw;

  static InteractionRecord? fromJson(Map<String, dynamic> json) {
    final id = _toString(json['ID'] ?? json['id']);
    final description = _toString(json['description']);
    final location = InteractionGeoPoint.fromJson(_toMap(json['location']));
    final place = InteractionGeoPoint.fromJson(_toMap(json['place']));
    final moment = _toDateTime(json['moment']);
    final timestamp = _toDateTime(json['timestamp']);
    final type = InteractionTypeInfo.fromJson(_toMap(json['type']));
    final user = InteractionUserInfo.fromJson(_toMap(json['user']));

    if (id == null ||
        description == null ||
        location == null ||
        place == null ||
        moment == null ||
        timestamp == null ||
        type == null ||
        user == null) {
      return null;
    }

    final sighting = _toMap(json['reportOfSighting']);
    final damage = _toMap(json['reportOfDamage']);
    final collision = _toMap(json['reportOfCollision']);

    InteractionSpeciesInfo? species;
    if (sighting != null) {
      species = InteractionSpeciesInfo.fromJson(_toMap(sighting['species']));
    }

    return InteractionRecord(
      id: id,
      description: description,
      location: location,
      place: place,
      moment: moment,
      timestamp: timestamp,
      type: type,
      user: user,
      schema: _toString(json[r'$schema']),
      questionnaire:
          InteractionQuestionnaireInfo.fromJson(_toMap(json['questionnaire'])),
      reportOfSighting: sighting,
      reportOfDamage: damage,
      reportOfCollision: collision,
      species: species,
      raw: Map<String, dynamic>.from(json),
    );
  }
}

List<InteractionRecord> parseInteractionRecords(List<Map<String, dynamic>> raw) {
  final out = <InteractionRecord>[];
  for (final item in raw) {
    final parsed = InteractionRecord.fromJson(item);
    if (parsed != null) out.add(parsed);
  }
  return out;
}

Map<String, dynamic>? _toMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}

String? _toString(dynamic value) {
  if (value == null) return null;
  final s = value.toString().trim();
  return s.isEmpty ? null : s;
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

DateTime? _toDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  return null;
}
