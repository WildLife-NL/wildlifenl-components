class VisitationCell {
  const VisitationCell({
    required this.latitude,
    required this.longitude,
    required this.count,
  });

  final double latitude;
  final double longitude;
  final int count;

  static VisitationCell? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final centroid = json['centroid'] as Map<String, dynamic>?;
    if (centroid == null) return null;
    final lat = _readDouble(centroid['latitude'] ?? centroid['lat']);
    final lng = _readDouble(centroid['longitude'] ?? centroid['lng'] ?? centroid['lon']);
    final count = json['count'];
    if (lat == null || lng == null || count == null) return null;
    final c = count is int ? count : (count is num ? count.toInt() : null);
    if (c == null || c < 0) return null;
    return VisitationCell(latitude: lat, longitude: lng, count: c);
  }

  static double? _readDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }
}
