/// API voor het ophalen van dieren binnen een tijd-ruimtebereik.
abstract class AnimalReadApiInterface {
  /// Haalt dieren op binnen het gegeven spatiotemporele bereik.
  /// [start] en [end]: tijdsbereik (date-time).
  /// [latitude], [longitude]: centrum van het gebied.
  /// [radius]: straal in meters (1–10000).
  Future<List<Map<String, dynamic>>> getAnimalsInSpan({
    required DateTime start,
    required DateTime end,
    required double latitude,
    required double longitude,
    required int radius,
  });
}
