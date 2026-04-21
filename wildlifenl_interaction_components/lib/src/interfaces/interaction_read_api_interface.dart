import '../models/add_interaction_input.dart';

/// Interface voor interactions: ophalen en toevoegen.
abstract class InteractionReadApiInterface {
  /// GET interactions/me/ – lijst van interactions van de ingelogde gebruiker.
  /// Retourneert ruwe JSON-objecten; de app kan die met eigen modellen parsen.
  Future<List<Map<String, dynamic>>> getMyInteractions();

  /// GET interaction/{id} – haal een specifieke interaction op.
  Future<Map<String, dynamic>> getInteractionById(String id);

  /// GET interactions/ met spatiotemporele filter.
  ///
  /// Vereist: [latitude], [longitude], [radius], [start], [end].
  ///
  /// Backward-compat: [momentAfter]/[momentBefore] worden ondersteund en mappen
  /// intern naar [start]/[end] als die niet zijn opgegeven.
  Future<List<Map<String, dynamic>>> queryInteractions({
    required double latitude,
    required double longitude,
    required int radius,
    DateTime? start,
    DateTime? end,
    @Deprecated('Gebruik start') DateTime? momentAfter,
    @Deprecated('Gebruik end') DateTime? momentBefore,
  });

  /// POST interaction/ – submit een nieuwe interaction.
  /// Retourneert het aangemaakte interaction-object (ruwe JSON).
  Future<Map<String, dynamic>> addInteraction(AddInteractionInput input);
}
