import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entity/profile_entity.dart';
import '../repository/profile.dart';

class GetMyProfile {
  final ProfileRepository repository;
   GetMyProfile(this.repository);

  Future<Either<Failure, ProfileEntity>> call() async {
    return await repository.getMyProfile();
  }
}