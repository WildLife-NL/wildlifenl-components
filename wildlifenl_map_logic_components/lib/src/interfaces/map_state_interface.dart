import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Interface voor kaartstate: default center, tile URLs, camera constraints en animatie.
abstract class MapStateInterface {
  /// Default centrum wanneer geen locatie beschikbaar (bijv. Nederland).
  static const LatLng defaultCenter = LatLng(52.088130, 5.170465);

  /// OpenTopoMap (OpenStreetMap-data) als standaard tegellaag.
  /// Geen API-key; max native zoom ~17.
  /// (Vervangt Carto Voyager: die toonde "API KEY REQUIRED" zonder key.)
  static const String standardTileUrl =
      'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png';

  /// Subdomains voor OpenTopoMap tile endpoint.
  static const List<String> standardTileSubdomains = ['a', 'b', 'c'];

  /// Satellite/imagery tiles.
  static const String satelliteTileUrl =
      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';

  /// Tekst voor naamsvermelding standaardlaag (OpenStreetMap + OpenTopoMap).
  /// Gebruik in [RichAttributionWidget] of [SimpleAttributionWidget] in
  /// `FlutterMap.children`.
  static const String standardAttributionText =
      '\u00A9 OpenTopoMap \u00B7 \u00A9 OpenStreetMap contributors';

  void constrainMapCamera(MapController mapController);

  void animateToLocation({
    required MapController mapController,
    required LatLng targetLocation,
    required double targetZoom,
    required TickerProvider vsync,
    Duration duration = const Duration(milliseconds: 500),
  });
}
