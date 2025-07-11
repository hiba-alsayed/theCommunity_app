import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String name;
  final String email;
  final String? deviceToken;
  final int? verificationCode;
  final DateTime? verificationExpiresAt;
  final DateTime updatedAt;
  final DateTime createdAt;
  final int id;

  const UserEntity({
    required this.name,
    required this.email,
    this.deviceToken,
    this.verificationCode,
    this.verificationExpiresAt,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  @override
  List<Object?> get props => [
    name,
    email,
    deviceToken,
    verificationCode,
    verificationExpiresAt,
    updatedAt,
    createdAt,
    id,
  ];
}

class SignUpResponseEntity extends Equatable {
  final UserEntity user;
  final String token;

  const SignUpResponseEntity({
    required this.user,
    required this.token,
  });

  @override
  List<Object?> get props => [user, token];
}