// import 'package:graduation_project/features/campaigns/domain/entities/campaign_location.dart';
//
// class CampaignLocationModel extends CampaignLocation {
//   CampaignLocationModel({String? name, double? latitude, double? longitude})
//     : super(name: name, latitude: latitude, longitude: longitude);
//
//   factory CampaignLocationModel.fromJson(Map<String, dynamic> json) {
//     return CampaignLocationModel(
//       name: json['name'],
//       latitude:
//           (json['latitude'] is String)
//               ? double.tryParse(json['latitude'])
//               : json['latitude']?.toDouble(),
//       longitude:
//           (json['longitude'] is String)
//               ? double.tryParse(json['longitude'])
//               : json['longitude']?.toDouble(),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {'name': name, 'latitude': latitude, 'longitude': longitude};
//   }
// }
import 'package:graduation_project/features/campaigns/domain/entities/campaign_location.dart';
class CampaignLocationModel extends CampaignLocation {
  const CampaignLocationModel({
    required String name,
    required double latitude,
    required double longitude,
  }) : super(
    name: name,
    latitude: latitude,
    longitude: longitude,
  );

  factory CampaignLocationModel.fromJson(Map<String, dynamic> json) {
    return CampaignLocationModel(
      name: json['name'] ?? '',
      latitude: _parseCoordinate(json['latitude']),
      longitude: _parseCoordinate(json['longitude']),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'latitude': latitude,
    'longitude': longitude,
  };

  static double _parseCoordinate(dynamic value) {
    if (value == null) return 0.0;
    if (value is String) return double.tryParse(value) ?? 0.0;
    if (value is num) return value.toDouble();
    return 0.0;
  }

  static CampaignLocationModel empty() => const CampaignLocationModel(
    name: '',
    latitude: 0.0,
    longitude: 0.0,
  );
}

