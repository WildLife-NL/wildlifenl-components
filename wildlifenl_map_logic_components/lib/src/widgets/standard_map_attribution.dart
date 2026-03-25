import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../interfaces/map_state_interface.dart';

/// Standaard naamsvermelding voor de CARTO Light-kaartlaag (OSM-data).
class StandardMapAttribution extends StatelessWidget {
  const StandardMapAttribution({super.key});

  @override
  Widget build(BuildContext context) {
    return RichAttributionWidget(
      animationConfig: const ScaleRAWA(),
      alignment: AttributionAlignment.bottomRight,
      attributions: const [
        TextSourceAttribution(
          'OpenStreetMap contributors',
          textStyle: TextStyle(fontSize: 12),
        ),
        TextSourceAttribution(
          'CARTO',
          textStyle: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

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
