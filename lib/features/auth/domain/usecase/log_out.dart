import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class LogOut {
  final AuthRepository repository;

  LogOut(this.repository);

  Future<Either<Failure, Unit>> call() async {
    return await repository.logout();
  }
}