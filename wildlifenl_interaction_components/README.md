# wildlifenl_interaction_components

API voor interactions: ophalen van "mijn interactions" (GET `interactions/me/`), filterquery (GET `interactions/`), ophalen op ID (GET `interaction/{id}`) en toevoegen (POST `interaction/`). Geschikt voor Wild Rapport, WildManager en andere apps die dezelfde backend gebruiken.

## Gebruik

### Dependency (Git of path)

```yaml
dependencies:
  wildlifenl_interaction_components:
    git:
      url: https://github.com/WildLife-NL/wildlifenl-components.git
      ref: Wildlife-rapport-Components
      path: wildlifenl_interaction_components
```

### Interface + standaardimplementatie

- **InteractionReadApiInterface** – `getMyInteractions()`, `getInteractionById(...)`, `queryInteractions(...)`, `addInteraction(...)`.
- **HttpInteractionReadApi** – gebruikt `baseUrl` en Bearer token uit SharedPreferences (`bearer_token`).

De API retourneert lijsten van `Map<String, dynamic>` (ruwe JSON) voor GETs. De app kan die zelf parsen met eigen modellen.

### Voorbeeld

```dart
import 'package:wildlifenl_interaction_components/wildlifenl_interaction_components.dart';

final api = HttpInteractionReadApi(baseUrl: 'https://api.example.com');

// Mijn interactions
final list = await api.getMyInteractions();

// Interaction op ID
final one = await api.getInteractionById('3892eb50-4697-4c72-aadc-32b766bce3c0');

// Query op gebied (GET /interactions/ met start/end/latitude/longitude/radius)
final queryList = await api.queryInteractions(
  latitude: 52.0,
  longitude: 5.0,
  radius: 5000,
  start: DateTime.now().subtract(const Duration(days: 30)),
  end: DateTime.now(),
);

// Nieuwe interaction toevoegen (POST /interaction/)
final created = await api.addInteraction(
  AddInteractionInput(
    description: 'Vos gezien bij wegberm',
    location: const InteractionGeoPointInput(latitude: 52.1, longitude: 5.1),
    place: const InteractionGeoPointInput(latitude: 52.1, longitude: 5.1),
    moment: DateTime.now(),
    typeID: 1,
    reportOfSighting: const InteractionReportOfSightingInput(
      speciesID: 'species-uuid',
      involvedAnimals: null,
    ),
  ),
);
```

### Typed schema-models (optioneel)

Voor het nieuwe Interaction API-schema kun je typed records gebruiken:

- `InteractionRecord`
- `InteractionGeoPoint`
- `InteractionTypeInfo`
- `InteractionUserInfo`
- `InteractionSpeciesInfo`
- `InteractionQuestionnaireInfo`
- `parseInteractionRecords(...)`

```dart
final raw = await api.getMyInteractions();
final interactions = parseInteractionRecords(raw);
final createdRecord = InteractionRecord.fromJson(created);
```
