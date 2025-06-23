
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/campaigns.dart';
import '../repositories/campaign_repository.dart';

class GetAllCampaignsByCategory {
  final CampaignRepository repository;

  GetAllCampaignsByCategory(this.repository);

  Future<Either<Failure, List<Campaigns>>> call(int categoryId) async {
    return await repository.getAllCampaignsByCategory(categoryId);
  }
}