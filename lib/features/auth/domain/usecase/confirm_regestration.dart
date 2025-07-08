import 'package:dartz/dartz.dart';
import 'package:graduation_project/features/auth/domain/entities/signup_entity.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class ConfirmRegistrationUseCase {
  final AuthRepository repository;

  ConfirmRegistrationUseCase(this.repository);

  Future<Either<Failure, SignUpEntity>> call({
    required String email,
    required String code,
  }) async {
    return await repository.confirmRegistration(
      email: email,
      code: code,
    );
  }
}