import 'dart:async';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/login_entity.dart';
import '../../domain/entities/signup_entity.dart';
import '../../domain/entities/signup_user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl(this.remoteDataSource);

  // @override
  // Future<Either<Failure, LoginEntity>> login({
  //   required String email,
  //   required String password,
  //   required String deviceToken,
  // }) async {
  //   try {
  //     final loginModel = await remoteDataSource.login(
  //       email: email,
  //       password: password,
  //       deviceToken: deviceToken,
  //     );
  //     return Right(loginModel);
  //   } on ServerException catch (e) {
  //     return Left(WrongPasswordFailure(message:e.message.toString()));
  //   }
  // }
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
      final errorMessage = e.message?.toString() ?? '';
      if (errorMessage.contains('Invalid credentials')){
        return Left(WrongPasswordFailure(message: e.message.toString()));
      }  else {
        return Left(ServerFailure(message: 'خطأ في الخادم. حاول مرة أخرى.'));
      }
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
  Future<Either<Failure, SignUpResponseEntity>> confirmRegistration({
    required String email,
    required String code,
  }) async {
    try {
      final SignUpResponseModel  = await remoteDataSource.confirmRegistration(
        email: email,
        code: code,
      );
      return Right(SignUpResponseModel);
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

  @override
  Future<Either<Failure, Unit>> resetPassword({required String email}) async {
    try {
      await remoteDataSource.resetPassword(email: email);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> confirmResetPassword({required String email, required String code, required String newPassword, required String newPasswordConfirmation}) async {
    try {
      final userModel = await remoteDataSource.confirmResetPassword(
        email: email,
        code: code,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async{
    try {
      await remoteDataSource.logout();
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}

