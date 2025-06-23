import 'package:dartz/dartz.dart';
import 'package:graduation_project/features/suggestions/domain/repositories/suggestions_repository.dart';
import '../../../../core/errors/failures.dart';
import '../entities/Suggestions.dart';

class GetMySuggestions {
  final SuggestionsRepository repository;
  GetMySuggestions(this.repository);
  Future<Either<Failure, List<Suggestions>>> call() async{
    return await repository.getMySuggestions();
  }
}
