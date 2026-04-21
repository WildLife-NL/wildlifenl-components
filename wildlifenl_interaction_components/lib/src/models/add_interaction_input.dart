class InteractionGeoPointInput {
  const InteractionGeoPointInput({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}

class InteractionReportOfSightingInput {
  const InteractionReportOfSightingInput({
    required this.speciesID,
    this.involvedAnimals,
  });

  final String speciesID;
  final List<Map<String, dynamic>>? involvedAnimals;

  Map<String, dynamic> toJson() => {
        'speciesID': speciesID,
        'involvedAnimals': involvedAnimals,
      };
}

class InteractionReportOfDamageInput {
  const InteractionReportOfDamageInput({
    required this.belonging,
    required this.estimatedLoss,
    required this.preventiveMeasures,
    required this.preventiveMeasuresDescription,
  });

  final String belonging;
  final String estimatedLoss;
  final bool preventiveMeasures;
  final String preventiveMeasuresDescription;

  Map<String, dynamic> toJson() => {
        'belonging': belonging,
        'estimatedLoss': estimatedLoss,
        'preventiveMeasures': preventiveMeasures,
        'preventiveMeasuresDescription': preventiveMeasuresDescription,
      };
}

class InteractionReportOfCollisionInput {
  const InteractionReportOfCollisionInput({
    required this.estimatedDamage,
    required this.severity,
    this.involvedAnimals,
  });

  final int estimatedDamage;
  final String severity;
  final List<Map<String, dynamic>>? involvedAnimals;

  Map<String, dynamic> toJson() => {
        'estimatedDamage': estimatedDamage,
        'severity': severity,
        'involvedAnimals': involvedAnimals,
      };
}

class AddInteractionInput {
  const AddInteractionInput({
    required this.description,
    required this.location,
    required this.moment,
    required this.place,
    required this.typeID,
    this.reportOfSighting,
    this.reportOfDamage,
    this.reportOfCollision,
  });

  final String description;
  final InteractionGeoPointInput location;
  final DateTime moment;
  final InteractionGeoPointInput place;
  final int typeID;
  final InteractionReportOfSightingInput? reportOfSighting;
  final InteractionReportOfDamageInput? reportOfDamage;
  final InteractionReportOfCollisionInput? reportOfCollision;

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'location': location.toJson(),
      'moment': moment.toUtc().toIso8601String(),
      'place': place.toJson(),
      'typeID': typeID,
      if (reportOfSighting != null) 'reportOfSighting': reportOfSighting!.toJson(),
      if (reportOfDamage != null) 'reportOfDamage': reportOfDamage!.toJson(),
      if (reportOfCollision != null) 'reportOfCollision': reportOfCollision!.toJson(),
    };
  }
}
