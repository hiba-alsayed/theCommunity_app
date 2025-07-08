import 'dart:async';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/login_entity.dart';
import '../../domain/entities/signup_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl(this.remoteDataSource);

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

  @override
  Future<Either<Failure, SignUpEntity>> signUp({required String email, required String password, required String passwordConfirmation, required String name, required int age, required String phone, required String gender, required String bio, String? deviceToken, required List<String> skills, required List<String> volunteerFields, required double longitude, required double latitude, required String area, String? image}) async{
    try {
      final signUpModel = await remoteDataSource.signUp(
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        name: name,
        age: age,
        phone: phone,
        gender: gender,
        bio: bio,
        deviceToken: deviceToken,
        skills: skills,
        volunteerFields: volunteerFields,
        longitude: longitude,
        latitude: latitude,
        area: area,
        image: image,
      );
      return Right(signUpModel);
    } on ServerException catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, SignUpEntity>> confirmRegistration({
    required String email,
    required String code,
  }) async {
    try {
      final signUpModel = await remoteDataSource.confirmRegistration(
        email: email,
        code: code,
      );
      return Right(signUpModel);
    } on ServerException catch (e) {
      return Left(ServerFailure());
    }
}

  @override
  Future<Either<Failure, Unit>> resendCode({
    required String email,
  }) async {
    try {
      await remoteDataSource.resendCode(email: email);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure());
    }
  }
  }
