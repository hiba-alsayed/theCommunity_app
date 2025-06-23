import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/suggestions_repository.dart';

class DeleteMySuggestion {
  final SuggestionsRepository repository;

  DeleteMySuggestion(this.repository);

  Future<Either<Failure,Unit>> call(int suggestionId) async {
    return await repository.deleteMySuggestion(suggestionId);
  }
}