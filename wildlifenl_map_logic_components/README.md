# wildlifenl_map_logic_components

**WildLifeNL Map Logic Components** – gedeelde kaartlogica voor Wild Rapport en WildManager: camera-bounds, locatie, geocoding, Nederland-manager.

## Gebruik

### Dependency

```yaml
dependencies:
  wildlifenl_map_logic_components:
    path: packages/wildlifenl_map_logic_components   # of git: url: ... ref: main
```

### Interfaces

- **LocationServiceInterface** – `determinePosition()`, `getAddressFromPosition()`, `isLocationInNetherlands()`
- **MapServiceInterface** – `constrainLatLng()`, `getAddressFromLatLng()`, `isLocationInNetherlands()`
- **MapStateInterface** – `constrainMapCamera()`, `animateToLocation()`, plus `defaultCenter`, `standardTileUrl`, `satelliteTileUrl`

### Standaardimplementatie

**NetherlandsMapManager** implementeert alle drie de interfaces (Nederland-grenzen, geolocator, geocoding, camera-animatie). Optioneel een eigen default center meegeven:

```dart
import 'package:wildlifenl_map_logic_components/wildlifenl_map_logic_components.dart';

final manager = NetherlandsMapManager(
  defaultCenter: LatLng(52.09, 5.17),  // optioneel
);
await manager.determinePosition();
manager.animateToLocation(mapController: ctrl, targetLocation: latlng, targetZoom: 14, vsync: this);
```

## Wild Rapport

De app gebruikt een eigen **LocationMapManager** die van `NetherlandsMapManager` extends en mock-locatie toevoegt; de interfaces worden hier hergebruikt via deze package.
