import 'package:graduation_project/features/campaigns/domain/entities/campaign_location.dart';

class CampaignLocationModel extends CampaignLocation {
  CampaignLocationModel({String? name, double? latitude, double? longitude})
    : super(name: name, latitude: latitude, longitude: longitude);

  factory CampaignLocationModel.fromJson(Map<String, dynamic> json) {
    return CampaignLocationModel(
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
