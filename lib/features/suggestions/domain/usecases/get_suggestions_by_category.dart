import 'package:dartz/dartz.dart';
import 'package:graduation_project/features/suggestions/domain/entities/Suggestions.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/suggestions_repository.dart';

class GetSuggestionsByCategory {
  final SuggestionsRepository repository;

  GetSuggestionsByCategory(this.repository);

  Future<Either<Failure, List<Suggestions>>> call(int categoryId) async {
    return await repository.getAllSuggestionsByCategory(categoryId);
  }
}