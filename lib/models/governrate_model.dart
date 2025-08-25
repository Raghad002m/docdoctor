class GovernrateModel {
  final int id;
  final String name;

  GovernrateModel({
    required this.id,
    required this.name,
  });

  factory GovernrateModel.fromJson(Map<String, dynamic> json) {
    return GovernrateModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}
