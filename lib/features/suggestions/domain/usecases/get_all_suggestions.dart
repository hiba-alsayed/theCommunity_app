import 'package:dartz/dartz.dart';
import 'package:graduation_project/features/suggestions/domain/entities/Suggestions.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/suggestions_repository.dart';

class GetAllSuggestions {
  final SuggestionsRepository repository;
  GetAllSuggestions(this.repository);
  Future<Either<Failure, List<Suggestions>>> call() async {
    return await repository.getAllSuggestions();
  }
}
