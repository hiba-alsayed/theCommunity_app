import 'package:dartz/dartz.dart';
import 'package:graduation_project/features/campaigns/domain/entities/category.dart';

import '../../../../core/errors/failures.dart';
import '../../../suggestions/presentation/pages/submit_suggestion_page.dart';
import '../repositories/campaign_repository.dart';

class GetCategoriesUseCase {
  final CampaignRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<Either<Failure, List<MyCategory>>> call() async {
    return await repository.getCategories();
  }
}