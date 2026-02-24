# wildlifenl_detection_components

API voor **Get Detections By Filter**: GET `/detection/` – detections binnen een spatiotemporele span. Geschikt voor Wild Rapport, WildManager en andere apps die dezelfde backend gebruiken.

**Scopes:** nature-area-manager, wildlife-manager, herd-manager.

## Dependency

```yaml
dependencies:
  wildlifenl_detection_components:
    path: ../wildlifenl-components/wildlifenl_detection_components
```

## Gebruik

- **DetectionReadApiInterface** – `getDetectionsByFilter(start, end, latitude, longitude, radius)`.
- **HttpDetectionReadApi** – gebruikt `baseUrl` en Bearer token uit SharedPreferences (`bearer_token`).

De API retourneert **lijsten van `Map<String, dynamic>`** (ruwe JSON). De app parsed die met eigen modellen (bijv. `Detection.fromJson(map)`).

### Voorbeeld

```dart
import 'package:wildlifenl_detection_components/wildlifenl_detection_components.dart';

final api = HttpDetectionReadApi(baseUrl: 'https://api.example.com');

final list = await api.getDetectionsByFilter(
  start: DateTime(2025, 1, 1),
  end: DateTime(2025, 1, 31),
  latitude: 52.09,
  longitude: 5.12,
  radius: 5000,
);
final detections = list.map((e) => Detection.fromJson(e)).toList();
```

### Query parameters (API)

| Parameter  | Type   | Vereist | Beschrijving |
|-----------|--------|---------|--------------|
| start     | date-time | ja   | Startmoment van de span |
| end       | date-time | ja   | Eindmoment van de span |
| latitude  | double | ja   | Breedtegraad van het centrum (-90 t/m 90) |
| longitude | double | ja   | Lengtegraad van het centrum (-180 t/m 180) |
| radius    | int    | ja   | Straal in meters (1 t/m 10000) |

Authorization: Bearer token in de `Authorization` header.
