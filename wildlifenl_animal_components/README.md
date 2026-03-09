# wildlifenl_animal_components

Component voor het ophalen van **dieren binnen een tijd-ruimtebereik** (spatiotemporal span) en weergave met dier-iconen.

- **Scopes:** nature-area-manager, wildlife-manager, herd-manager
- **API:** `GET animals/?start=...&end=...&latitude=...&longitude=...&radius=...` met Bearer token

## Gebruik

```dart
import 'package:wildlifenl_animal_components/wildlifenl_animal_components.dart';

// API
final api = HttpAnimalReadApi(baseUrl: baseUrl);
final raw = await api.getAnimalsInSpan(
  start: start,
  end: end,
  latitude: center.latitude,
  longitude: center.longitude,
  radius: radiusMeters,
);

// Model
final animal = Animal.fromJson(map);

// Icoon (gebruikt wildlifenl_assets)
AnimalIcon(
  speciesCommonName: animal.displaySpecies,
  size: 24,
  fallback: Icon(Icons.pets, size: 24),
)
```

## GitHub

Plaats deze map in de repo **WildLife-NL/wildlifenl-components** onder de branch **Wildlife-rapport-Components** (bijv. als `wildlifenl_animal_components`). In je app:

```yaml
wildlifenl_animal_components:
  git:
    url: https://github.com/WildLife-NL/wildlifenl-components.git
    ref: Wildlife-rapport-Components
    path: wildlifenl_animal_components
```
