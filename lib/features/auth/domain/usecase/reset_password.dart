import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class ResetPassword {
  final AuthRepository repository;

  ResetPassword(this.repository);

  Future<Either<Failure, Unit>> call({
    required String email,
  }) async {
    return await repository.resetPassword(
      email: email,
    );
  }
}