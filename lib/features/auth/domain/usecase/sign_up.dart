import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/signup_entity.dart';
import '../repositories/auth_repository.dart';

class SignUp {
  final AuthRepository repository;
  SignUp(this.repository);

  Future<Either<Failure, SignUpEntity>> call({
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
  }) async {
    return await repository.signUp(
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
  }
}