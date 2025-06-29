import 'package:dartz/dartz.dart';
import 'package:graduation_project/features/profile/domain/entity/profile_entity.dart';
import '../../../../core/errors/failures.dart';
import '../repository/profile.dart';

class GetProfileByUserId {
  final ProfileRepository repository;

  GetProfileByUserId(this.repository);

  Future<Either<Failure, ProfileEntity>> call(int userId) async {
    return await repository.getProfileByUserId(userId);
  }
}