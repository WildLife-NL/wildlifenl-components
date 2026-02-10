import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../interfaces/map_state_interface.dart';
import 'standard_map_attribution.dart';

/// Gedeelde kaartwidget met **OpenTopoMap** als standaard tegellaag en
/// verplichte bronvermelding (© OpenTopoMap · © OpenStreetMap contributors).
///
/// Gebruik deze widget in Wild Rapport / WildManager in plaats van een
/// handmatige [FlutterMap] + [TileLayer], zodat altijd OpenTopoMap wordt
/// getoond en de attribution correct staat.
///
/// Voorbeeld:
/// ```dart
/// WildLifeNLMap(
///   userAgentPackageName: 'nl.wildlife.rapport',
///   mapController: _mapController,
///   options: MapOptions(
///     initialCenter: MapStateInterface.defaultCenter,
///     initialZoom: 10,
///   ),
///   extraLayers: [
///     MarkerLayer(markers: [...]),
///   ],
/// )
/// ```
class WildLifeNLMap extends StatelessWidget {
  const WildLifeNLMap({
    super.key,
    required this.userAgentPackageName,
    this.mapController,
    MapOptions? options,
    this.extraLayers = const [],
  }) : options = options ?? const MapOptions();

  /// Package name van de app (voor User-Agent van tile-requests). Verplicht
  /// vanwege tile-serverbeleid.
  final String userAgentPackageName;

  /// Optionele controller voor programmatisch bewegen/zoomen.
  final MapController? mapController;

  /// Kaartopties (center, zoom, constraints, callbacks).
  final MapOptions options;

  /// Extra lagen bovenop de OpenTopoMap-tegellaag (markers, polylines, etc.).
  final List<Widget> extraLayers;

  @override
  Widget build(BuildContext context) {
    final layers = <Widget>[
      TileLayer(
        urlTemplate: MapStateInterface.standardTileUrl,
        subdomains: MapStateInterface.standardTileSubdomains,
        userAgentPackageName: userAgentPackageName,
      ),
      ...extraLayers,
    ];

    return FlutterMap(
      mapController: mapController,
      options: options,
      children: layers,
      nonRotatedChildren: const [
        StandardMapAttribution(),
      ],
    );
  }
}
