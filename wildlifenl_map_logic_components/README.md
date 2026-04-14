# wildlifenl_map_logic_components

**WildLifeNL Map Logic Components** - gedeelde kaartlogica voor Wild Rapport en WildManager: camera-bounds, locatie, geocoding, Nederland-manager.

## Gebruik

### Dependency

```yaml
dependencies:
  wildlifenl_map_logic_components:
    path: packages/wildlifenl_map_logic_components   # of git: url: ... ref: main
```

### Interfaces

- **LocationServiceInterface** - `determinePosition()`, `getAddressFromPosition()`, `isLocationInNetherlands()`
- **MapServiceInterface** - `constrainLatLng()`, `getAddressFromLatLng()`, `isLocationInNetherlands()`
- **MapStateInterface** - `constrainMapCamera()`, `animateToLocation()`, plus `defaultCenter`, `standardTileUrl`, `standardTileSubdomains`, `standardAttributionText`, `satelliteTileUrl`

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

### Standaardkaart (CARTO Voyager) - aanbevolen: gebruik [WildLifeNLMap]

Om **altijd** CARTO Voyager (OpenStreetMap-data) en de juiste bronvermelding te tonen, gebruik de gedeelde widget **WildLifeNLMap**. Die zet zelf de juiste TileLayer + subdomains + attribution; je hoeft geen URL meer te kiezen.

```dart
import 'package:wildlifenl_map_logic_components/wildlifenl_map_logic_components.dart';

// In je scherm (bijv. kaart_overview_screen):
WildLifeNLMap(
  userAgentPackageName: 'nl.wildlife.rapport',  // of jouw app package
  mapController: _mapController,
  options: MapOptions(
    initialCenter: MapStateInterface.defaultCenter,
    initialZoom: 10,
  ),
  extraLayers: [
    MarkerLayer(markers: [...]),  // optioneel
  ],
)
```

Vervang je bestaande `FlutterMap` + `TileLayer` in de app door deze widget; dan verdwijnt de oude OpenStreetMap-tegels en zie je CARTO Voyager met bronvermelding.

Handmatig (als je toch zelf FlutterMap bouwt): gebruik `MapStateInterface.standardTileUrl` + `standardTileSubdomains` en zet `StandardMapAttribution()` in `nonRotatedChildren`.

## Wild Rapport

De app gebruikt een eigen **LocationMapManager** die van `NetherlandsMapManager` extends en mock-locatie toevoegt; de interfaces worden hier hergebruikt via deze package.

