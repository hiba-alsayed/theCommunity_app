import 'package:equatable/equatable.dart';

class ComplaintLocation extends Equatable {
  final String? name;
  final double? latitude;
  final double? longitude;

  const ComplaintLocation({
    this.name,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [name, latitude, longitude];
}