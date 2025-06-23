import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/campaign_repository.dart';

class RateCompletedCampaign {
  final CampaignRepository repository;
  RateCompletedCampaign(this.repository);
  Future<Either<Failure, Unit>> call(int campaignId, int rating, String comment,) async {
    return await repository.rateCompletedCampaign(campaignId, rating, comment);
  }
}
