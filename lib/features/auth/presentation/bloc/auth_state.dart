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
  final SignUpResponseEntity signUpResponseEntity;

  const ConfirmRegistrationSuccess(this.signUpResponseEntity);

  @override
  List<Object?> get props => [signUpResponseEntity];
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

//reset
class ResetPasswordLoading extends AuthState {
  const ResetPasswordLoading();
}
class ResetPasswordSuccess extends AuthState {
  final String message;
  final String email;

  const ResetPasswordSuccess( {required this.email,this.message = 'Reset code sent to your email.'});

  @override
  List<Object?> get props => [message,email];
}
class ResetPasswordFailure extends AuthState {
  final String message;

  const ResetPasswordFailure(this.message);

  @override
  List<Object?> get props => [message];
}

//confirm reset
class ConfirmResetPasswordLoading extends AuthState {
  const ConfirmResetPasswordLoading();
}
class ConfirmResetPasswordSuccess extends AuthState {
  final UserEntity user;
  final String message;

  const ConfirmResetPasswordSuccess({required this.user, this.message = 'Password reset successfully'});

  @override
  List<Object?> get props => [user, message];
}
class ConfirmResetPasswordFailure extends AuthState {
  final String message;

  const ConfirmResetPasswordFailure(this.message);

  @override
  List<Object?> get props => [message];
}

//logout
class LogoutLoading extends AuthState {
  const LogoutLoading();
}
class LogoutSuccess extends AuthState {
  const LogoutSuccess();
}
class LogoutFailure extends AuthState {
  final String message;

  const LogoutFailure(this.message);

  @override
  List<Object?> get props => [message];
}