import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/errors/failures.dart';
import 'package:graduation_project/features/campaigns/domain/entities/campaigns.dart';
import 'package:graduation_project/features/campaigns/domain/repositories/campaign_repository.dart';

class GetCampaignDetails {
  final CampaignRepository repository;

  GetCampaignDetails(this.repository);

  Future<Either<Failure, Campaigns>> call(int projectId) async {
    return await repository.getCampaignDetails(projectId);
  }
}