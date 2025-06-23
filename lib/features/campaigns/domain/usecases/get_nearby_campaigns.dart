import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/campaigns.dart';
import '../repositories/campaign_repository.dart';

class GetNearbyCampaigns {
  final CampaignRepository repository;

  GetNearbyCampaigns(this.repository);

  Future<Either<Failure, List<Campaigns>>> call(int categoryId, double distance) async {
    return await repository.getNearbyCampaigns(categoryId, distance);
  }
}
