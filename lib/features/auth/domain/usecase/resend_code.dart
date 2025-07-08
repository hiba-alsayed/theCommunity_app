import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class ResendCode{
  final AuthRepository repository;
  ResendCode(this.repository);

  Future<Either<Failure, Unit>> call({required email}) async {
    return await repository.resendCode(
      email:email,
    );
  }
}
