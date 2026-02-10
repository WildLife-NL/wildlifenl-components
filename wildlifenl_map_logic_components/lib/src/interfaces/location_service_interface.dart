import 'package:geolocator/geolocator.dart';

/// Interface voor locatiebepaling (GPS, permissies, adres).
abstract class LocationServiceInterface {
  Future<Position?> determinePosition();
  Future<String> getAddressFromPosition(Position position);
  bool isLocationInNetherlands(double lat, double lon);
}
