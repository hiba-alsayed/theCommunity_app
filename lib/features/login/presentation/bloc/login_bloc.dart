import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/login_entity.dart';
import '../../domain/usecase/log_in.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginInitialState extends LoginState {}
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LogIn logIn;

  LoginBloc(this.logIn) : super(LoginInitialState()) {
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


