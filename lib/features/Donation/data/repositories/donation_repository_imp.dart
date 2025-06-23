import 'package:dartz/dartz.dart';

import 'package:graduation_project/core/errors/failures.dart';

import 'package:graduation_project/features/Donation/domain/entity/donation_entity.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repository/donation_repository.dart';
import '../datasources/donation_remote_data_source.dart';

class DonationRepositoryImp implements DonationRepository {
  final DonationRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  DonationRepositoryImp({required this.remoteDataSource,required this.networkInfo,});

  @override
  Future<Either<Failure, DonationEntity>> makeDonation(
      int projectId,
      double amount,
      ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteDonation = await remoteDataSource.makeDonation(projectId, amount);
        return Right(remoteDonation);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}