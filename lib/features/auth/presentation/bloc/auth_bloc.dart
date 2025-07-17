import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/login_entity.dart';
import '../../domain/entities/signup_entity.dart';
import '../../domain/entities/signup_user_entity.dart';
import '../../domain/usecase/confirm_regestration.dart';
import '../../domain/usecase/confirm_reset_password.dart';
import '../../domain/usecase/log_in.dart';
import '../../domain/usecase/log_out.dart';
import '../../domain/usecase/resend_code.dart';
import '../../domain/usecase/reset_password.dart';
import '../../domain/usecase/sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthInitialState extends AuthState {}
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LogIn logIn;
  final SignUp signUp;
  final ConfirmRegistrationUseCase confirmRegistrationUseCase;
  final ResendCode resendCodeUseCase;
  final ResetPassword resetPasswordUseCase;
  final ConfirmResetPassword confirmResetPasswordUseCase;
  final LogOut logOut;

  AuthBloc({required this.logIn,required this.signUp,required this.confirmRegistrationUseCase,required this.resendCodeUseCase,required this.resetPasswordUseCase,required this.confirmResetPasswordUseCase,required this.logOut }) : super(AuthInitialState()) {
    //login
    on<PerformLogin>((event, emit) async {
      emit(LoginLoading());

      final result = await logIn(
        email: event.email,
        password: event.password,
        deviceToken: event.deviceToken,
      );

      result.fold(
            (failure) => emit(LoginFailure(_mapFailureToMessage(failure))),
            (user) => emit(LoginSuccess(user)),
      );
    });
    //signup
    on<PerformSignUp>((event, emit) async {
      emit(SignUpLoading());

      final result = await signUp(
        email: event.email,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
        name: event.name,
        age: event.age,
        phone: event.phone,
        gender: event.gender,
        bio: event.bio,
        deviceToken: event.deviceToken,
        skills: event.skills,
        volunteerFields: event.volunteerFields,
        longitude: event.longitude,
        latitude: event.latitude,
        area: event.area,
        image: event.image,
      );

      result.fold(
            (failure) => emit(SignUpFailure(_mapFailureToMessage(failure))),
            (user) => emit(SignUpSuccess(user)),
      );
    });
    //confirm
    on<PerformConfirmRegistration>((event, emit) async {
      emit(ConfirmRegistrationLoading());

      final result = await confirmRegistrationUseCase(
        email: event.email,
        code: event.code,
      );

      result.fold(
            (failure) => emit(ConfirmRegistrationFailure(_mapFailureToMessage(failure))),
            (signUpResponseEntity) => emit(ConfirmRegistrationSuccess(signUpResponseEntity)),
      );
    });
    //resend
    on<ResendCodeEvent>((event, emit) async {
      emit(ResendCodeLoading());
      final result = await resendCodeUseCase(
        email: event.email,
      );

      result.fold(
            (failure) => emit(ResendCodeFailure(_mapFailureToMessage(failure))),
            (_) => emit(const ResendCodeSuccess()),
      );
    });
    //reset
    on<ResetPasswordEvent>((event, emit) async {
      emit(const ResetPasswordLoading());

      final result = await resetPasswordUseCase(
        email: event.email,
      );

      result.fold(
            (failure) => emit(ResetPasswordFailure(_mapFailureToMessage(failure))),
            (_) => emit(ResetPasswordSuccess(message: 'A password reset link has been sent to your email.',
              email: event.email,)),
      );
    });
    //confirm reset
    on<ConfirmResetPasswordEvent>((event, emit) async {
      emit(const ConfirmResetPasswordLoading());

      final result = await confirmResetPasswordUseCase(
        email: event.email,
        code: event.code,
        newPassword: event.newPassword,
        newPasswordConfirmation: event.newPasswordConfirmation,
      );

      result.fold(
            (failure) => emit(ConfirmResetPasswordFailure(_mapFailureToMessage(failure))),
            (userEntity) => emit(ConfirmResetPasswordSuccess(user: userEntity)),
      );
    });
    //logout
    on<PerformLogout>((event, emit) async {
      emit(const LogoutLoading());
      final result = await logOut();
      result.fold(
            (failure) => emit(LogoutFailure(_mapFailureToMessage(failure))),
            (_) => emit(const LogoutSuccess()),
      );
    });
  }
  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'خطأ في الخادم. حاول مرة أخرى.';
    } else if (failure is OfflineFailure ) {
      return 'لا يوجد اتصال بالإنترنت';
    } else {
      return 'حدث خطأ غير متوقع. حاول مرة أخرى.';
    }
  }
}


