import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/signup_user_entity.dart';
import '../repositories/auth_repository.dart';

class ConfirmResetPassword {
  final AuthRepository repository;

  ConfirmResetPassword(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String code,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    return await repository.confirmResetPassword(
      email: email,
      code: code,
      newPassword: newPassword,
      newPasswordConfirmation: newPasswordConfirmation,
    );
  }
}