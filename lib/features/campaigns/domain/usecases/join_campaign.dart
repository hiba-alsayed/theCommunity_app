import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/campaigns.dart';
import '../repositories/campaign_repository.dart';

class JoinCampaign  {
  final CampaignRepository repository;

  JoinCampaign (this.repository);

  Future<Either<Failure,Unit>> call(int campaignId ) async {
    return await repository.joinCampaign(campaignId);
  }
}