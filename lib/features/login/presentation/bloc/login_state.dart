part of 'login_bloc.dart';



sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}
class LoginInitial extends LoginState {
  const LoginInitial();
}
class LoginLoading extends LoginState {
  const LoginLoading();
}
class LoginSuccess extends LoginState {
  final LoginEntity user;

  const LoginSuccess(this.user);

  @override
  List<Object?> get props => [user];
}
class LoginFailure extends LoginState {
  final String message;

  const LoginFailure(this.message);

  @override
  List<Object?> get props => [message];
}


