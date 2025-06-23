import '../../domain/entites/regions_entity.dart';


class RegionModel extends RegionEntity {
  const RegionModel({required int id, required String name})
      : super(id: id, name: name);

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: json['region_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'region_id': id,
      'name': name,
    };
  }
}