import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/errors/failures.dart';
import 'package:graduation_project/features/campaigns/data/datasources/campaigns_remote_data_source.dart';
import 'package:graduation_project/features/campaigns/domain/entities/campaigns.dart';
import 'package:graduation_project/features/campaigns/domain/entities/category.dart';
import 'package:graduation_project/features/campaigns/domain/repositories/campaign_repository.dart';
import 'package:graduation_project/features/suggestions/presentation/pages/submit_suggestion_page.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/campaigns_local_data_source.dart';

class CampaignRepositoryImp implements CampaignRepository {
  final CampaignRemoteDataSource remoteDataSource;
  final CampaignLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CampaignRepositoryImp({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Campaigns>>> getAllCampaigns() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCampaigns = await remoteDataSource.getAllCampaigns();
        localDataSource.cacheCampaigns(remoteCampaigns);
        return Right(remoteCampaigns);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localCampaigns = await localDataSource.getCachedCampaigns();
        return Right(localCampaigns);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<MyCategory>>> getCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCategories = await remoteDataSource.getCategories();
        return Right(remoteCategories);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Campaigns>>> getAllCampaignsByCategory(int categoryId) async {
    if (await networkInfo.isConnected) {
      try {
        final campaignsByCategory = await remoteDataSource.getAllCampaignsByCategory(categoryId);
        return Right(campaignsByCategory);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> joinCampaign(int campaignId) async{
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.joinCampaign(campaignId);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<Campaigns>>> getMyCampaigns() async{
    if (await networkInfo.isConnected) {
      try {
        final myCampaigns = await remoteDataSource.getMyCampaigns();
        return Right(myCampaigns);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<Campaigns>>> getNearbyCampaigns(int categoryId, double distance) async {
    if (await networkInfo.isConnected) {
      try {
        final nearbyCampaigns = await remoteDataSource.getNearbyCampaigns(categoryId, distance);
        return Right(nearbyCampaigns);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> rateCompletedCampaign(int campaignId, int rating, String comment) async {
    if (await networkInfo.isConnected) {
      try {
        return await remoteDataSource.rateCompletedCampaign(campaignId, rating, comment);
      } on ServerException {
        return Left(ServerFailure());
      } catch (e) {

        print("Repository Error: $e");
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<Campaigns>>> getRecommendedCampaigns() async{
    if (await networkInfo.isConnected) {
      try {
        final remoteRecommendedCampaigns = await remoteDataSource.getRecommendedCampaigns();
        return Right(remoteRecommendedCampaigns);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<Campaigns>>> getPromotedCampaigns() async{
    if (await networkInfo.isConnected) {
      try {
        final remotePromotedCampaigns = await remoteDataSource.getPromotedCampaigns();
        return Right(remotePromotedCampaigns);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
  }