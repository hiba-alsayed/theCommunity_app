import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/suggestions_repository.dart';

class VoteOnSuggestion {
  final SuggestionsRepository repository;

  VoteOnSuggestion(this.repository);

  Future<Either<Failure, Unit>> call({
    required int suggestionId,
    required int value,
  }) {
    return repository.voteOnSuggestion(
      suggestionId: suggestionId,
      value: value,
    );
  }
}
