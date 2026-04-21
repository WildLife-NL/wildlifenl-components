import '../models/add_interaction_input.dart';

/// Interface voor interactions: ophalen en toevoegen.
abstract class InteractionReadApiInterface {
  /// GET interactions/me/ – lijst van interactions van de ingelogde gebruiker.
  /// Retourneert ruwe JSON-objecten; de app kan die met eigen modellen parsen.
  Future<List<Map<String, dynamic>>> getMyInteractions();

  /// GET interactions/query/?area_latitude=...&area_longitude=...&area_radius=... (optioneel moment_after, moment_before).
  /// Retourneert ruwe JSON-objecten voor de app om te parsen.
  Future<List<Map<String, dynamic>>> queryInteractions({
    required double areaLatitude,
    required double areaLongitude,
    required int areaRadiusMeters,
    DateTime? momentAfter,
    DateTime? momentBefore,
  });

  /// POST interaction/ – submit een nieuwe interaction.
  /// Retourneert het aangemaakte interaction-object (ruwe JSON).
  Future<Map<String, dynamic>> addInteraction(AddInteractionInput input);
}
