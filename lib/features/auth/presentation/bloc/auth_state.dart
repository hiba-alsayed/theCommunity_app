part of 'auth_bloc.dart';
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}
//login
class LoginInitial extends AuthState {
  const LoginInitial();
}
class LoginLoading extends AuthState {
  const LoginLoading();
}
class LoginSuccess extends AuthState {
  final LoginEntity user;

  const LoginSuccess(this.user);

  @override
  List<Object?> get props => [user];
}
class LoginFailure extends AuthState {
  final String message;

  const LoginFailure(this.message);

  @override
  List<Object?> get props => [message];
}

//signup
class SignUpInitial extends AuthState {
  const SignUpInitial();
}
class SignUpLoading extends AuthState {
  const SignUpLoading();
}
class SignUpSuccess extends AuthState {
  final SignUpEntity user;

  const SignUpSuccess(this.user);

  @override
  List<Object?> get props => [user];
}
class SignUpFailure extends AuthState {
  final String message;

  const SignUpFailure(this.message);

  @override
  List<Object?> get props => [message];
}

//confirm
class ConfirmRegistrationLoading extends AuthState {
  const ConfirmRegistrationLoading();
}
class ConfirmRegistrationSuccess extends AuthState {
  final SignUpEntity user;

  const ConfirmRegistrationSuccess(this.user);

  @override
  List<Object?> get props => [user];
}
class ConfirmRegistrationFailure extends AuthState {
  final String message;

  const ConfirmRegistrationFailure(this.message);

  @override
  List<Object?> get props => [message];
}

//resend
class ResendCodeLoading extends AuthState {
  const ResendCodeLoading();
}
class ResendCodeSuccess extends AuthState {
  const ResendCodeSuccess();
}
class ResendCodeFailure extends AuthState {
  final String message;

  const ResendCodeFailure(this.message);

  @override
  List<Object?> get props => [message];
}