import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../interfaces/map_state_interface.dart';

/// Standaard naamsvermelding voor de OpenTopoMap-kaartlaag.
///
/// Gebruik in [FlutterMap.nonRotatedChildren] zodat de attribution rechtsonder
/// (of standaardpositie) op de kaart zichtbaar is, conform de vereisten van
/// OpenTopoMap en OpenStreetMap.
///
/// Voorbeeld:
/// ```dart
/// FlutterMap(
///   ...
///   nonRotatedChildren: [
///     StandardMapAttribution(),
///   ],
/// )
/// ```
class StandardMapAttribution extends StatelessWidget {
  const StandardMapAttribution({super.key});

  @override
  Widget build(BuildContext context) {
    return RichAttributionWidget(
      animationConfig: const ScaleRAWA(),
      alignment: AttributionAlignment.bottomRight,
      attributions: [
        TextSourceAttribution(
          'OpenTopoMap',
          textStyle: const TextStyle(fontSize: 12),
        ),
        TextSourceAttribution(
          'OpenStreetMap contributors',
          textStyle: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

/// Eenvoudige tekst-attribution voor de standaardkaart (zelfde bronvermelding).
///
/// Alternatief voor [StandardMapAttribution] als je een klassieke, altijd
/// zichtbare tekstbox wilt in plaats van de uitgeklapte RichAttributionWidget.
class SimpleStandardMapAttribution extends StatelessWidget {
  const SimpleStandardMapAttribution({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleAttributionWidget(
      source: Text(MapStateInterface.standardAttributionText),
      alignment: Alignment.bottomRight,
    );
  }
}
