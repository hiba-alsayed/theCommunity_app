
import '../../domain/entities/signup_user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String name,
    required String email,
    String? deviceToken,
    int? verificationCode,
    DateTime? verificationExpiresAt,
    required DateTime updatedAt,
    required DateTime createdAt,
    required int id,
  }) : super(
    name: name,
    email: email,
    deviceToken: deviceToken,
    verificationCode: verificationCode,
    verificationExpiresAt: verificationExpiresAt,
    updatedAt: updatedAt,
    createdAt: createdAt,
    id: id,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String,
      email: json['email'] as String,
      deviceToken: json['device_token'] as String?,
      verificationCode: json['verification_code'] as int?,
      verificationExpiresAt: json['verification_expires_at'] != null
          ? DateTime.parse(json['verification_expires_at'] as String)
          : null,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      id: json['id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'device_token': deviceToken,
      'verification_code': verificationCode,
      'verification_expires_at': verificationExpiresAt?.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'id': id,
    };
  }
}

class SignUpResponseModel extends SignUpResponseEntity {
  const SignUpResponseModel({
    required UserModel user,
    required String token,
  }) : super(
    user: user,
    token: token,
  );

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    return SignUpResponseModel(
      user: UserModel.fromJson(json['data']['user'] as Map<String, dynamic>),
      token: json['data']['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': true,
      'message': 'Registered successfully',
      'data': {
        'user': (user as UserModel).toJson(),
        'token': token,
      },
    };
  }
}