part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object?> get props => [];
}
class PerformLogin extends LoginEvent {
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