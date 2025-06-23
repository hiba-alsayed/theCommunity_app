import '../../domain/entities/location.dart';
import '../../domain/entities/Suggestions.dart';

class LocationModel extends MyLocation {
  LocationModel({
    String? name,
    double? latitude,
    double? longitude,
  }) : super(name: name, latitude: latitude, longitude: longitude);

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'],
      latitude: (json['latitude'] is String)
          ? double.tryParse(json['latitude'])
          : json['latitude']?.toDouble(),
      longitude: (json['longitude'] is String)
          ? double.tryParse(json['longitude'])
          : json['longitude']?.toDouble(),
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