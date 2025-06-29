import 'package:equatable/equatable.dart';
import 'package:graduation_project/features/profile/domain/entity/prof_location_entity.dart';

class ProfileEntity extends Equatable {
  final int id;
  final int userId;
  final String name;
  final String email;
  final ProfLocationEntity location;
  final String imageUrl;
  final String bio;
  final String phone;
  final int age;
  final String gender;
  final List<String> skills;
  final List<String> fields;
  final DateTime createdAt;

  const ProfileEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.location,
    required this.imageUrl,
    required this.bio,
    required this.phone,
    required this.age,
    required this.gender,
    required this.skills,
    required this.fields,
    required this.createdAt,
  });

  List<Object?> get props => [
    id,
    userId,
    name,
    email,
    location,
    imageUrl,
    bio,
    phone,
    age,
    gender,
    skills,
    fields,
    createdAt,
  ];
}