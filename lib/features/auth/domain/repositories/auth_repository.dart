import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/login_entity.dart';
import '../entities/signup_entity.dart';
import '../entities/signup_user_entity.dart';

abstract class AuthRepository{
  Future<Either<Failure, LoginEntity>> login({
    required String email,
    required String password,
    required String deviceToken,
  });
  Future<Either<Failure, SignUpEntity>> signUp({
    required String email,
    required String password,
    required String passwordConfirmation,
    required String name,
    required int age,
    required String phone,
    required String gender,
    required String bio,
    String? deviceToken,
    required List<String> skills,
    required List<String> volunteerFields,
    required double longitude,
    required double latitude,
    required String area,
    String? image,
  });
  Future<Either<Failure, SignUpResponseEntity>> confirmRegistration({
    required String email,
    required String code,
  });
  Future<Either<Failure, Unit>> resendCode({
    required String email,
  });
  Future<Either<Failure, Unit>> resetPassword({
    required String email,
  });
  Future<Either<Failure, UserEntity>> confirmResetPassword({
    required String email,
    required String code,
    required String newPassword,
    required String newPasswordConfirmation,
  });
  Future<Either<Failure, Unit>> logout();
}