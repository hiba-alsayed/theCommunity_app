import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/login_entity.dart';

abstract class LoginRepository{
  Future<Either<Failure, LoginEntity>> login({
    required String email,
    required String password,
    required String deviceToken,
  });
}