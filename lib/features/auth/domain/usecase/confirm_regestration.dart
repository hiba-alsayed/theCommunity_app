import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/signup_user_entity.dart';
import '../repositories/auth_repository.dart';

class ConfirmRegistrationUseCase {
  final AuthRepository repository;
  ConfirmRegistrationUseCase(this.repository);

  Future<Either<Failure, SignUpResponseEntity>> call({
    required String email,
    required String code,
  }) async {
    return await repository.confirmRegistration(
      email: email,
      code: code,
    );
  }
}