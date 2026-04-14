class AlarmAnimal {
  const AlarmAnimal({
    required this.id,
    required this.name,
    this.species,
    this.locationTimestamp,
  });

  final String id;
  final String name;
  final AlarmSpecies? species;
  final String? locationTimestamp;

  factory AlarmAnimal.fromJson(Map<String, dynamic> json) {
    return AlarmAnimal(
      id: json['ID'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      species: json['species'] != null
          ? AlarmSpecies.fromJson(
              json['species'] as Map<String, dynamic>,
            )
          : null,
      locationTimestamp: json['locationTimestamp'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'ID': id,
        'name': name,
        if (species != null) 'species': species!.toJson(),
        if (locationTimestamp != null) 'locationTimestamp': locationTimestamp,
      };
}

class AlarmSpecies {
  const AlarmSpecies({
    this.id,
    this.name,
  });

  final String? id;
  final String? name;

  factory AlarmSpecies.fromJson(Map<String, dynamic> json) {
    return AlarmSpecies(
      id: json['ID'] as String? ?? json['id'] as String?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'ID': id,
        if (name != null) 'name': name,
      };
}
