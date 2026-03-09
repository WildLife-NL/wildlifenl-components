import 'visitation_cell.dart';

class LivingLabInfo {
  const LivingLabInfo({
    required this.id,
    required this.name,
    this.definition,
  });

  final String id;
  final String name;
  final List<dynamic>? definition;

  static LivingLabInfo? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final id = json['ID'] ?? json['id'] ?? json['livingLabID'];
    final name = json['name'];
    if (id == null || name == null) return null;
    final def = json['definition'];
    return LivingLabInfo(
      id: id.toString(),
      name: name.toString(),
      definition: def is List ? def : null,
    );
  }
}

class VisitationResponse {
  const VisitationResponse({
    required this.cells,
    this.livingLab,
  });

  final List<VisitationCell> cells;
  final LivingLabInfo? livingLab;

  static VisitationResponse fromJson(Map<String, dynamic> json) {
    final cellsRaw = json['cells'];
    final list = cellsRaw is List ? cellsRaw : <dynamic>[];
    final cells = <VisitationCell>[];
    for (final e in list) {
      final cell = VisitationCell.fromJson(e is Map ? Map<String, dynamic>.from(e) : null);
      if (cell != null) cells.add(cell);
    }
    final lab = json['livingLab'];
    return VisitationResponse(
      cells: cells,
      livingLab: LivingLabInfo.fromJson(lab is Map ? Map<String, dynamic>.from(lab) : null),
    );
  }
}
