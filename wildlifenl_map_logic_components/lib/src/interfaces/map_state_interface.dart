import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Interface voor kaartstate: default center, tile URLs, camera constraints en animatie.
abstract class MapStateInterface {
  /// Default centrum wanneer geen locatie beschikbaar (bijv. Nederland).
  static const LatLng defaultCenter = LatLng(52.088130, 5.170465);

  /// OpenStreetMap standaard tiles.
  static const String standardTileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  /// Satellite/imagery tiles.
  static const String satelliteTileUrl =
      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';

  void constrainMapCamera(MapController mapController);

  void animateToLocation({
    required MapController mapController,
    required LatLng targetLocation,
    required double targetZoom,
    required TickerProvider vsync,
    Duration duration = const Duration(milliseconds: 500),
  });
}
