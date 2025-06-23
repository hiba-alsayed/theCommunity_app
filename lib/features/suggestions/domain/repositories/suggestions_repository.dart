import 'package:graduation_project/features/suggestions/domain/entities/Suggestions.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class SuggestionsRepository {
  Future<Either<Failure, List<Suggestions>>> getAllSuggestions();
  Future<Either<Failure,List<Suggestions>>>getMySuggestions();
  Future<Either<Failure, List<Suggestions>>> getAllSuggestionsByCategory(
    int categoryId,
  );
  Future<Either<Failure, Unit>> submitSuggestion({
    required String title,
    required String description,
    required String requiredAmount,
    required String area,
    required double longitude,
    required double latitude,
    required dynamic categoryId,
    required dynamic numberOfParticipants,
    required dynamic imageUrl,
  });
  Future<Either<Failure, Unit>> voteOnSuggestion({
    required int suggestionId,
    required int value,
  });
  Future<Either<Failure, List<Suggestions>>> getNearbySuggestions({
    required int categoryId,
    required double distance,
  });
  Future<Either<Failure, Unit>> deleteMySuggestion(int suggestionId);
}

