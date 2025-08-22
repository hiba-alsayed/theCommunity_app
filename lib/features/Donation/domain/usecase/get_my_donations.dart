import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entity/my_donations_entity.dart';
import '../repository/donation_repository.dart';

class GetMyDonations {
  final DonationRepository repository;

  const GetMyDonations(this.repository);

  Future<Either<Failure, List<DonationItemEntity>>> call() async {
    return await repository.getMyDonations();
  }
}