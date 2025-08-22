import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entity/donation_entity.dart';
import '../entity/my_donations_entity.dart';

abstract class DonationRepository {
  Future<Either<Failure, DonationEntity>> makeDonation(
     int projectId,
     double amount,
  );
  Future<Either<Failure, List<DonationItemEntity>>> getMyDonations();
}