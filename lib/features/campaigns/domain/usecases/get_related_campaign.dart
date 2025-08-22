import 'package:dartz/dartz.dart';
import 'package:graduation_project/features/campaigns/domain/entities/campaigns.dart';
import 'package:graduation_project/features/campaigns/domain/repositories/campaign_repository.dart';

import '../../../../core/errors/failures.dart';

class GetRelatedCampaigns {
  final CampaignRepository repository;

  GetRelatedCampaigns(this.repository);

  Future<Either<Failure, List<Campaigns>>> call(int projectId) async {
    return await repository.getRelatedCampaigns(projectId);
  }
}