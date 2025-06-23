import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/campaigns.dart';
import '../repositories/campaign_repository.dart';

class GetRecommendedCampaigns {
  final CampaignRepository repository;

  GetRecommendedCampaigns(this.repository);
  Future<Either<Failure, List<Campaigns>>> call() async {
    return await repository.getRecommendedCampaigns();
  }
}