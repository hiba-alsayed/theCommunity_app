
import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String role;
  final String token;

  const LoginEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.token,
  });

  @override
  List<Object?> get props => [id, name, email, role, token];
}