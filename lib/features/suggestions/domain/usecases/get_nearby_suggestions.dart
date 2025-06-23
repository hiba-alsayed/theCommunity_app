import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/errors/failures.dart';
import 'package:graduation_project/features/suggestions/domain/repositories/suggestions_repository.dart';

import '../entities/Suggestions.dart';

class GetNearbySuggestions {
  final SuggestionsRepository repository;

  GetNearbySuggestions( this.repository);
  Future<Either<Failure,List<Suggestions>>>call({
    required int categoryId,
    required double distance,
})async{
    return await repository.getNearbySuggestions(categoryId: categoryId, distance: distance);
  }
}