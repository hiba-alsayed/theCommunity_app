import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/errors/failures.dart';
import 'package:graduation_project/features/campaigns/domain/entities/campaigns.dart';
import 'package:graduation_project/features/campaigns/domain/repositories/campaign_repository.dart';

class GetMyCampaigns {
  final CampaignRepository repository;

  GetMyCampaigns(this.repository);

  Future<Either<Failure, List<Campaigns>>> call() async {
    return await repository.getMyCampaigns();
  }
}
