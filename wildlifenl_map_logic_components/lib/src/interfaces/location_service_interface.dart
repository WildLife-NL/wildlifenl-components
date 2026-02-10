import 'package:geolocator/geolocator.dart';

abstract class LocationServiceInterface {
  Future<Position?> determinePosition();
  Future<String> getAddressFromPosition(Position position);
  bool isLocationInNetherlands(double lat, double lon);
}
