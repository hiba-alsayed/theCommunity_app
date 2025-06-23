// lib/features/auth/data/repositories/login_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/login_entity.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasources/login_remote_data_source.dart';


class LoginRepositoryImpl implements LoginRepository {
  final AuthRemoteDataSource remoteDataSource;

  LoginRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, LoginEntity>> login({
    required String email,
    required String password,
    required String deviceToken,
  }) async {
    try {
      final loginModel = await remoteDataSource.login(
        email: email,
        password: password,
        deviceToken: deviceToken,
      );
      return Right(loginModel);
    } on ServerException catch (e) {
      return Left(ServerFailure());
    }
  }
}
