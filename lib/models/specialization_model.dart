class SpecializationModel {
  final int id;
  final String name;
  final String? description;

  SpecializationModel({
    required this.id,
    required this.name,
    this.description,
  });

  factory SpecializationModel.fromJson(Map<String, dynamic> json) {
    return SpecializationModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
  };
}
