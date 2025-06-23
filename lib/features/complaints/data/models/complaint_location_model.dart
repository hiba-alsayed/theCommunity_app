import '../../domain/entites/complaint_location.dart';

class ComplaintLocationModel extends ComplaintLocation {
  ComplaintLocationModel({String? name, double? latitude, double? longitude})
    : super(name: name, latitude: latitude, longitude: longitude);

  factory ComplaintLocationModel.fromJson(Map<String, dynamic> json) {
    return ComplaintLocationModel(
      name: json['name'],
      latitude:
          (json['latitude'] is String)
              ? double.tryParse(json['latitude'])
              : json['latitude']?.toDouble(),
      longitude:
          (json['longitude'] is String)
              ? double.tryParse(json['longitude'])
              : json['longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'latitude': latitude, 'longitude': longitude};
  }
}
