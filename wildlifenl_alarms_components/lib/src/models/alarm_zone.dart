class AlarmZone {
  const AlarmZone({
    required this.id,
    this.name,
  });

  final String id;
  final String? name;

  factory AlarmZone.fromJson(Map<String, dynamic> json) {
    return AlarmZone(
      id: json['ID'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'ID': id,
        if (name != null) 'name': name,
      };
}
