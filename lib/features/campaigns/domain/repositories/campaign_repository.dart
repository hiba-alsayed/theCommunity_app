import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/errors/failures.dart';
import '../entities/campaigns.dart';
import '../entities/category.dart';

abstract class CampaignRepository {
  Future<Either<Failure, List<Campaigns>>> getAllCampaigns();
  Future<Either<Failure, List<MyCategory>>> getCategories();
  Future<Either<Failure, List<Campaigns>>> getAllCampaignsByCategory(
    int categoryId,
  );
  Future<Either<Failure, Unit>> joinCampaign(int campaignId);
  Future<Either<Failure, List<Campaigns>>> getMyCampaigns();
  Future<Either<Failure, List<Campaigns>>> getNearbyCampaigns(
    int categoryId,
    double distance,
  );
  Future<Either<Failure, Unit>> rateCompletedCampaign(
    int campaignId,
    int rating,
    String comment,
  );
  Future<Either<Failure, List<Campaigns>>> getRecommendedCampaigns();
  Future<Either<Failure, List<Campaigns>>> getPromotedCampaigns();
}
