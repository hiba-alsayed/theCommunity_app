part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}
//login
class PerformLogin extends AuthEvent {
  final String email;
  final String password;
  final String deviceToken;

  const PerformLogin({
    required this.email,
    required this.password,
    required this.deviceToken,
  });

  @override
  List<Object?> get props => [email, password,deviceToken];
}
//signup
class PerformSignUp extends AuthEvent {
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

  const PerformSignUp({
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
//confirm
class PerformConfirmRegistration extends AuthEvent {
  final String email;
  final String code;

  const PerformConfirmRegistration({
    required this.email,
    required this.code,
  });

  @override
  List<Object?> get props => [email, code];
}
//resend
class ResendCodeEvent extends AuthEvent {
  final String email;

  const ResendCodeEvent({required this.email});

  @override
  List<Object?> get props => [email];
}
