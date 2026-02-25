import 'package:latlong2/latlong.dart';

/// Dier uit de API (binnen een tijd-ruimtebereik).
class Animal {
  const Animal({
    required this.id,
    required this.location,
    required this.name,
    this.locationTimestamp,
    this.speciesCommonName,
    this.speciesCategory,
    this.speciesLatinName,
  });

  final String id;
  final LatLng location;
  final String name;
  final DateTime? locationTimestamp;
  final String? speciesCommonName;
  final String? speciesCategory;
  final String? speciesLatinName;

  /// Soortnaam voor weergave/iconen: commonName of fallback naar name.
  String? get displaySpecies => speciesCommonName?.trim().isNotEmpty == true
      ? speciesCommonName
      : (speciesLatinName?.trim().isNotEmpty == true ? speciesLatinName : null);

  static Animal? fromJson(Map<String, dynamic> json) {
    try {
      final id = json['ID'] as String? ?? json['id'] as String?;
      if (id == null) return null;

      final loc = json['location'] as Map<String, dynamic>?;
      if (loc == null) return null;
      final lat = (loc['latitude'] as num?)?.toDouble() ?? (loc['lat'] as num?)?.toDouble();
      final lng = (loc['longitude'] as num?)?.toDouble() ?? (loc['lon'] as num?)?.toDouble() ?? (loc['lng'] as num?)?.toDouble();
      if (lat == null || lng == null) return null;
      final location = LatLng(lat, lng);

      final name = json['name'] as String? ?? '';

      final locationTimestampStr = json['locationTimestamp'] as String? ?? json['location_timestamp'] as String?;
      DateTime? locationTimestamp;
      if (locationTimestampStr != null) {
        locationTimestamp = DateTime.tryParse(locationTimestampStr);
      }

      String? speciesCommonName;
      String? speciesCategory;
      String? speciesLatinName;
      final species = json['species'] as Map<String, dynamic>?;
      if (species != null) {
        speciesCommonName = species['commonName'] as String? ?? species['common_name'] as String?;
        speciesCategory = species['category'] as String? ?? species['speciesCategory'] as String?;
        speciesLatinName = species['name'] as String?;
      }

      return Animal(
        id: id,
        location: location,
        name: name,
        locationTimestamp: locationTimestamp,
        speciesCommonName: speciesCommonName,
        speciesCategory: speciesCategory,
        speciesLatinName: speciesLatinName,
      );
    } catch (_) {
      return null;
    }
  }
}
