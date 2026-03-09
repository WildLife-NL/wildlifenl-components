# wildlifenl_visitation_components

API voor **Get Visitation For Living Lab**: GET `/visitation/` – recreatiedruk (visitation) binnen een tijdsspanne voor een Living Lab, als raster van cellen. Geschikt voor een **heatmap-laag** op de kaart (recreationist pressure).

**Scopes:** nature-area-manager, wildlife-manager, herd-manager.

## Dependency

```yaml
dependencies:
  wildlifenl_visitation_components:
    path: ../wildlifenl-components/wildlifenl_visitation_components
```

## Gebruik

- **VisitationReadApiInterface** – `getVisitationForLivingLab(livingLabID, start, end, cellSize)`.
- **HttpVisitationReadApi** – gebruikt `baseUrl` en Bearer token uit SharedPreferences (`bearer_token`).
- **VisitationResponse** – bevat `cells` (lijst van `VisitationCell`: centroid lat/lng + count) en optioneel `livingLab` (id, name, definition).
- **toHeatmapCells(cells, maxCount?)** – zet cellen om naar `HeatmapCell` met genormaliseerde `intensity` (0.0–1.0) voor kleur/opacity in een heatmap.

### Query parameters (API)

| Parameter    | Type   | Vereist | Beschrijving |
|-------------|--------|---------|--------------|
| livingLabID | uuid   | ja      | ID van het Living Lab |
| start       | date-time | ja   | Start van de tijdsspanne |
| end         | date-time | ja   | Einde van de tijdsspanne |
| cellSize    | double | ja      | Grootte van de heatmapcellen in meters (20–10000) |

### Voorbeeld: data ophalen

```dart
import 'package:wildlifenl_visitation_components/wildlifenl_visitation_components.dart';

final api = HttpVisitationReadApi(baseUrl: 'https://api.example.com');

final response = await api.getVisitationForLivingLab(
  livingLabID: 'uuid-van-living-lab',
  start: DateTime(2025, 1, 1),
  end: DateTime(2025, 1, 31),
  cellSize: 500,
);

for (final cell in response.cells) {
  print('${cell.latitude}, ${cell.longitude}: ${cell.count}');
}
```

### Voorbeeld: heatmap-laag op de kaart

Zet cellen om naar intensity (0–1) en teken bijvoorbeeld cirkels met opacity/kleur op basis van intensity (bijv. met flutter_map CircleLayer of een heatmap-plugin):

```dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:wildlifenl_visitation_components/wildlifenl_visitation_components.dart';

final response = await api.getVisitationForLivingLab(...);
final heatmapCells = toHeatmapCells(response.cells);

final circleMarkers = heatmapCells.map((c) => CircleMarker(
  point: LatLng(c.latitude, c.longitude),
  radius: 20,
  color: Colors.blue.withValues(alpha: 0.3 * c.intensity + 0.1),
  borderColor: Colors.blue,
  borderStrokeWidth: 1,
)).toList();

// In FlutterMap children:
CircleLayer(circles: circleMarkers)
```

Je kunt `cellSize` aanpassen (kleiner = fijnere heatmap, meer cellen; groter = grovere weergave).
