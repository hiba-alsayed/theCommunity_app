import 'package:dartz/dartz.dart';
import 'package:graduation_project/features/suggestions/domain/repositories/suggestions_repository.dart';
import '../../../../core/errors/failures.dart';
import '../entities/Suggestions.dart';

class SubmitSuggestion {
  final SuggestionsRepository repository;

  SubmitSuggestion(this.repository);

  Future<Either<Failure, Unit>> call({
    required String title,
    required String description,
    required String requiredAmount,
    required String area,
    required double longitude,
    required double latitude,
    required dynamic categoryId,
    required dynamic numberOfParticipants,
    required dynamic imageUrl,
  }) {
    return repository.submitSuggestion(
      title: title,
      description: description,
      requiredAmount: requiredAmount,
      area: area,
      longitude: longitude,
      latitude: latitude,
      categoryId: categoryId,
      numberOfParticipants: numberOfParticipants,
      imageUrl: imageUrl,
    );
  }
}
