import '../models/visitation_cell.dart';

class HeatmapCell {
  const HeatmapCell({
    required this.latitude,
    required this.longitude,
    required this.count,
    required this.intensity,
  });

  final double latitude;
  final double longitude;
  final int count;
  final double intensity;
}

List<HeatmapCell> toHeatmapCells(
  List<VisitationCell> cells, {
  int? maxCount,
}) {
  if (cells.isEmpty) return [];
  final max = maxCount ??
      cells.fold<int>(0, (prev, c) => c.count > prev ? c.count : prev);
  if (max <= 0) {
    return cells
        .map((c) => HeatmapCell(
              latitude: c.latitude,
              longitude: c.longitude,
              count: c.count,
              intensity: 0.0,
            ))
        .toList();
  }
  return cells
      .map((c) => HeatmapCell(
            latitude: c.latitude,
            longitude: c.longitude,
            count: c.count,
            intensity: c.count / max,
          ))
      .toList();
}
