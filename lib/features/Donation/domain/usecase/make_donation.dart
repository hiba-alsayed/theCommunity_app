import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repository/donation_repository.dart';
import '../entity/donation_entity.dart';

class MakeDonation {
  final DonationRepository repository;

  MakeDonation(this.repository);

  Future<Either<Failure, DonationEntity>> call({
    required int projectId,
    required double amount,
  }) async {
    return await repository.makeDonation(projectId, amount);
  }
}
