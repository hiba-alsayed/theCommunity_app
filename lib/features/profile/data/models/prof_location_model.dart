import 'package:graduation_project/features/profile/domain/entity/prof_location_entity.dart';

class ProfLocationModel extends ProfLocationEntity {
  const ProfLocationModel({
    required super.name,
    required super.latitude,
    required super.longitude,
  });

  factory ProfLocationModel.fromJson(Map<String, dynamic> json) {
    return ProfLocationModel(
      name: json['name'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}