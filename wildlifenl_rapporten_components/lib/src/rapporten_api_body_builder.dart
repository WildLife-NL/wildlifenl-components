import 'interaction_request.dart';

class RapportenApiBodyBuilder {
  RapportenApiBodyBuilder._();

  static Map<String, dynamic> buildSightingBody({
    required String description,
    required double locationLatitude,
    required double locationLongitude,
    required double placeLatitude,
    required double placeLongitude,
    required DateTime moment,
    required String speciesID,
    required List<InvolvedAnimalDto> involvedAnimals,
  }) {
    final body = InteractionRequestBody(
      description: description,
      location: LocationDto(latitude: locationLatitude, longitude: locationLongitude),
      moment: _toIso8601Utc(moment),
      place: LocationDto(latitude: placeLatitude, longitude: placeLongitude),
      speciesID: speciesID,
      typeID: 1,
      reportOfSighting: ReportOfSightingDto(involvedAnimals: involvedAnimals),
    );
    return body.toJson();
  }

  static Map<String, dynamic> buildDamageBody({
    required String description,
    required double locationLatitude,
    required double locationLongitude,
    required double placeLatitude,
    required double placeLongitude,
    required DateTime moment,
    required String speciesID,
    required String belonging,
    required int estimatedDamage,
    required int estimatedLoss,
    required String impactType,
    required int impactValue,
  }) {
    final body = InteractionRequestBody(
      description: description,
      location: LocationDto(latitude: locationLatitude, longitude: locationLongitude),
      moment: _toIso8601Utc(moment),
      place: LocationDto(latitude: placeLatitude, longitude: placeLongitude),
      speciesID: speciesID,
      typeID: 2,
      reportOfDamage: ReportOfDamageDto(
        belonging: belonging,
        estimatedDamage: estimatedDamage,
        estimatedLoss: estimatedLoss,
        impactType: impactType,
        impactValue: impactValue,
      ),
    );
    return body.toJson();
  }

  static Map<String, dynamic> buildCollisionBody({
    required String description,
    required double locationLatitude,
    required double locationLongitude,
    required double placeLatitude,
    required double placeLongitude,
    required DateTime moment,
    required String speciesID,
    required int estimatedDamage,
    required String intensity,
    required String urgency,
    required List<InvolvedAnimalDto> involvedAnimals,
  }) {
    final body = InteractionRequestBody(
      description: description,
      location: LocationDto(latitude: locationLatitude, longitude: locationLongitude),
      moment: _toIso8601Utc(moment),
      place: LocationDto(latitude: placeLatitude, longitude: placeLongitude),
      speciesID: speciesID,
      typeID: 3,
      reportOfCollision: ReportOfCollisionDto(
        estimatedDamage: estimatedDamage,
        intensity: intensity,
        urgency: urgency,
        involvedAnimals: involvedAnimals,
      ),
    );
    return body.toJson();
  }

  static String _toIso8601Utc(DateTime dateTime) {
    return dateTime.toUtc().toIso8601String();
  }
}
