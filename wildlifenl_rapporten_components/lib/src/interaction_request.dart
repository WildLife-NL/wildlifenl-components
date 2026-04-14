class LocationDto {
  final double latitude;
  final double longitude;

  const LocationDto({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}

class InvolvedAnimalDto {
  final String condition;
  final String lifeStage;
  final String sex;

  const InvolvedAnimalDto({
    required this.condition,
    required this.lifeStage,
    required this.sex,
  });

  Map<String, dynamic> toJson() => {
        'condition': condition,
        'lifeStage': lifeStage,
        'sex': sex,
      };
}

class ReportOfSightingDto {
  final List<InvolvedAnimalDto> involvedAnimals;

  const ReportOfSightingDto({required this.involvedAnimals});

  Map<String, dynamic> toJson() => {
        'involvedAnimals': involvedAnimals.map((e) => e.toJson()).toList(),
      };
}

class ReportOfDamageDto {
  final String belonging;
  final int estimatedDamage;
  final int estimatedLoss;
  final String impactType;
  final int impactValue;

  const ReportOfDamageDto({
    required this.belonging,
    required this.estimatedDamage,
    required this.estimatedLoss,
    required this.impactType,
    required this.impactValue,
  });

  Map<String, dynamic> toJson() => {
        'belonging': belonging,
        'estimatedDamage': estimatedDamage,
        'estimatedLoss': estimatedLoss,
        'impactType': impactType,
        'impactValue': impactValue,
      };
}

class ReportOfCollisionDto {
  final int estimatedDamage;
  final String intensity;
  final List<InvolvedAnimalDto> involvedAnimals;
  final String urgency;

  const ReportOfCollisionDto({
    required this.estimatedDamage,
    required this.intensity,
    required this.involvedAnimals,
    required this.urgency,
  });

  Map<String, dynamic> toJson() => {
        'estimatedDamage': estimatedDamage,
        'intensity': intensity,
        'involvedAnimals': involvedAnimals.map((e) => e.toJson()).toList(),
        'urgency': urgency,
      };
}

class InteractionRequestBody {
  final String description;
  final LocationDto location;
  final String moment;
  final LocationDto place;
  final String speciesID;
  final int typeID;

  final ReportOfSightingDto? reportOfSighting;
  final ReportOfDamageDto? reportOfDamage;
  final ReportOfCollisionDto? reportOfCollision;

  const InteractionRequestBody({
    required this.description,
    required this.location,
    required this.moment,
    required this.place,
    required this.speciesID,
    required this.typeID,
    this.reportOfSighting,
    this.reportOfDamage,
    this.reportOfCollision,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'description': description,
      'location': location.toJson(),
      'moment': moment,
      'place': place.toJson(),
      'speciesID': speciesID,
      'typeID': typeID,
    };
    if (reportOfSighting != null) map['reportOfSighting'] = reportOfSighting!.toJson();
    if (reportOfDamage != null) map['reportOfDamage'] = reportOfDamage!.toJson();
    if (reportOfCollision != null) map['reportOfCollision'] = reportOfCollision!.toJson();
    return map;
  }
}
