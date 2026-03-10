# wildlifenl_zone_components

Dart-package voor de Zone API: modellen en client om zones toe te voegen (POST /zone/). Onderdeel van de WildLife NL components.

## Gebruik

Voeg de package toe aan je `pubspec.yaml`:

```yaml
dependencies:
  wildlifenl_zone_components:
    path: ../packages/wildlifenl_zone_components
```

Of na pushen naar Git:

```yaml
dependencies:
  wildlifenl_zone_components:
    git:
      url: https://github.com/WildLife-NL/wildlifenl-components.git
      ref: main
      path: wildlifenl_zone_components
```

### Voorbeeld

```dart
import 'package:wildlifenl_zone_components/wildlifenl_zone_components.dart';

final zoneApi = ZoneApi(
  baseUrl: 'https://api.example.com',
  getToken: () async => await mijnTokenGetter(),
);

final request = ZoneCreateRequest(
  name: 'Mijn zone',
  description: 'Beschrijving van minimaal 5 tekens.',
  definition: [
    ZoneDefinitionPoint(latitude: 52.0, longitude: 5.0),
  ],
);

final zone = await zoneApi.addZone(request);
```

## API

- **ZoneApi** – `addZone(ZoneCreateRequest)` → `Future<Zone?>`
- **ZoneCreateRequest** – `name` (≥2 tekens), `description` (≥5 tekens), `definition` (lijst van punten)
- **ZoneDefinitionPoint** – `latitude`, `longitude`
- **Zone** – response-model (id, created, description, name, …)
