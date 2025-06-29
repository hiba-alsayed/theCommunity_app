import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entity/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getMyProfile();
  Future<Either<Failure, ProfileEntity>> getProfileByUserId(int userId);
  Future<Either<Failure, String>> updateClientProfile({
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
  });
}