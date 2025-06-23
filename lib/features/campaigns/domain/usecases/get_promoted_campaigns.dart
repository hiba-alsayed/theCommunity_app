import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/campaigns.dart';
import '../repositories/campaign_repository.dart';

class GetPromotedCampaigns {
  final CampaignRepository repository;
  GetPromotedCampaigns(this.repository);
  Future<Either<Failure, List<Campaigns>>> call() async {
    return await repository.getPromotedCampaigns();
  }
}