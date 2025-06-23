import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/errors/failures.dart';
import 'package:graduation_project/features/campaigns/domain/entities/campaigns.dart';

import '../repositories/campaign_repository.dart';

class GetAllCampaigns{
  final CampaignRepository repository;
  GetAllCampaigns(this.repository);
  Future<Either<Failure,List<Campaigns>>>call() async{
    return await repository.getAllCampaigns();
  }
}