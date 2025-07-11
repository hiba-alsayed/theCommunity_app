import 'package:equatable/equatable.dart';
class SignUpEntity extends Equatable {
  final String email;
  final String password;
  final String passwordConfirmation;
  final String name;
  final int age;
  final String phone;
  final String gender;
  final String bio;
  final String? deviceToken;
  final List<String> skills;
  final List<String> volunteerFields;
  final double longitude;
  final double latitude;
  final String area;
  final String? image;

   SignUpEntity({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.name,
    required this.age,
    required this.phone,
    required this.gender,
    required this.bio,
    this.deviceToken,
    required this.skills,
    required this.volunteerFields,
    required this.longitude,
    required this.latitude,
    required this.area,
    this.image,
  });

  @override
  List<Object?> get props => [
    email,
    password,
    passwordConfirmation,
    name,
    age,
    phone,
    gender,
    bio,
    deviceToken,
    skills,
    volunteerFields,
    longitude,
    latitude,
    area,
    image,
  ];
}
