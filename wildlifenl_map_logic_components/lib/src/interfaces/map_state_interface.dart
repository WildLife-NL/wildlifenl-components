import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Interface voor kaartstate: default center, tile URLs, camera constraints en animatie.
abstract class MapStateInterface {
  /// Default centrum wanneer geen locatie beschikbaar (bijv. Nederland).
  static const LatLng defaultCenter = LatLng(52.088130, 5.170465);

  /// CARTO Light (OpenStreetMap-data) als standaard tegellaag.
  static const String standardTileUrl =
      'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png';

  /// Subdomains voor CARTO tile endpoint.
  static const List<String> standardTileSubdomains = ['a', 'b', 'c', 'd'];

  /// Satellite/imagery tiles.
  static const String satelliteTileUrl =
      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';

  /// Tekst voor naamsvermelding standaardlaag (OpenStreetMap + CARTO). Gebruik
  /// in [RichAttributionWidget] of [SimpleAttributionWidget] in
  /// [FlutterMap.nonRotatedChildren].
  static const String standardAttributionText =
      '\u00A9 OpenStreetMap contributors \u00B7 \u00A9 CartoDB';

  void constrainMapCamera(MapController mapController);

  void animateToLocation({
    required MapController mapController,
    required LatLng targetLocation,
    required double targetZoom,
    required TickerProvider vsync,
    Duration duration = const Duration(milliseconds: 500),
  });
}
