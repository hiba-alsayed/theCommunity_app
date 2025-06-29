import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repository/profile.dart';

class UpdateClientProfile {
  final ProfileRepository repository;

  UpdateClientProfile(this.repository);

  Future<Either<Failure, String>> call({
    required int age,
    required String phone,
    required String gender,
    required String bio,
    required String deviceToken,
    required List<String> volunteerFields,
    required String longitude,
    required String latitude,
    required String area,
    required List<String> skills,
  }) {
    return repository.updateClientProfile(
      age: age,
      phone: phone,
      gender: gender,
      bio: bio,
      deviceToken: deviceToken,
      volunteerFields: volunteerFields,
      longitude: longitude,
      latitude: latitude,
      area: area,
      skills: skills,
    );
  }
}