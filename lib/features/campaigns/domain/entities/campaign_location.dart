import 'package:equatable/equatable.dart';

class CampaignLocation extends Equatable {
  final String? name;
  final double? latitude;
  final double? longitude;

  const CampaignLocation({
    this.name,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [name, latitude, longitude];
}