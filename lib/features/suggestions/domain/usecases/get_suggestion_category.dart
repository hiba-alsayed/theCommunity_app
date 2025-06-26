import 'package:dartz/dartz.dart';
import 'package:graduation_project/features/suggestions/domain/repositories/suggestions_repository.dart';

import '../../../../core/errors/failures.dart';
import '../../../campaigns/domain/entities/category.dart';

class GetSuggestionCategory{
  final SuggestionsRepository repository;

  GetSuggestionCategory(this.repository);

  Future<Either<Failure, List<MyCategory>>> call() async {
    return await repository.getCategories();
  }
}