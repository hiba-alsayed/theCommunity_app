import '../../domain/entities/login_entity.dart';

class LoginModel extends LoginEntity {
  const LoginModel({
    required int id,
    required String name,
    required String email,
    required String role,
    required String token,
  }) : super(
    id: id,
    name: name,
    email: email,
    role: role,
    token: token,
  );

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    final user = json['data']['user'];
    final role = json['data']['role'];
    final token = json['data']['token'];

    return LoginModel(
      id: user['id'],
      name: user['name'],
      email: user['email'],
      role: role,
      token: token,
    );
  }
}