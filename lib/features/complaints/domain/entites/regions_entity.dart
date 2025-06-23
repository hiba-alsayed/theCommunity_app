import 'package:equatable/equatable.dart';

class RegionEntity extends Equatable {
  final int id;
  final String name;

  const RegionEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}