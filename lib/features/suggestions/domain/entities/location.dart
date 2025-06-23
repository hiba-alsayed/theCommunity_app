import 'package:equatable/equatable.dart';

class MyLocation extends Equatable {
  final String? name;
  final double? latitude;
  final double? longitude;

  const MyLocation({
    this.name,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [name, latitude, longitude];
}