
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/login_entity.dart';
import '../repositories/auth_repository.dart';

class LogIn {
  final AuthRepository repository;
  LogIn(this.repository);

  Future<Either<Failure, LoginEntity>> call({
    required String email,
    required String password,
    required String deviceToken,
  }) async {
    return await repository.login(
      email: email,
      password: password,
      deviceToken:deviceToken
    );
  }
}
