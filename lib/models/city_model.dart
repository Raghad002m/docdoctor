class CityModel {
  final int id;
  final String name;
  final int governrateId;

  CityModel({
    required this.id,
    required this.name,
    required this.governrateId,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      governrateId: json['governrate_id'] is int
          ? json['governrate_id']
          : int.parse(json['governrate_id'].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'governrate_id': governrateId,
  };
}
