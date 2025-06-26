part of 'suggestion_bloc.dart';

sealed class SuggestionEvent extends Equatable {
  const SuggestionEvent();
  @override
  List<Object?> get props => [];
}
// جلب كل المقترحات
class GetAllSuggestionsEvent extends SuggestionEvent {}
class RefreshAllSuggestionsEvent extends SuggestionEvent {}
class LoadMoreSuggestionsEvent extends SuggestionEvent {}
//جلب مقترحاتي
class GetMySuggestionsEvent extends SuggestionEvent{}
//جلب التصنيفات
class LoadSuggestionCategoriesEvent extends SuggestionEvent {}
// جلب المقترحات القريبة
class GetNearbySuggestionsEvent extends SuggestionEvent {
  final int categoryId;
  final double distance;

  GetNearbySuggestionsEvent({
    required this.categoryId,
    required this.distance,
  });}
//رفع مقترح
class SubmitSuggestionEvent extends SuggestionEvent {
  final String title;
  final String description;
  final String requiredAmount;
  final String area;
  final double longitude;
  final double latitude;
  final dynamic categoryId;
  final dynamic numberOfParticipants;
  final dynamic imageUrl;

  SubmitSuggestionEvent({
    required this.title,
    required this.description,
    required this.requiredAmount,
    required this.area,
    required this.longitude,
    required this.latitude,
    required this.categoryId,
    required this.numberOfParticipants,
    required this.imageUrl,
  });
  @override
  List<Object?> get props => [
    title,
    description,
    requiredAmount,
    area,
    longitude,
    latitude,
    categoryId,
    numberOfParticipants,
    imageUrl,
  ];
}
//التصويت على مقترح
class voteOnSuggestionEvent extends SuggestionEvent {
  final int suggestionId;
  final int value;
  final Suggestions suggestion;

  voteOnSuggestionEvent({required this.suggestionId, required this.value,required this.suggestion,});

  @override
  List<Object?> get props => [suggestionId, value];
}
//جلب المقترحات حسب التصنيف
class LoadSuggestionsByCategoryEvent extends SuggestionEvent {
  final int categoryId;
  const LoadSuggestionsByCategoryEvent(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}
//حذف مقترح
class DeleteMySuggestionEvent extends SuggestionEvent {
  final int suggestionId;

  const DeleteMySuggestionEvent(this.suggestionId);

  @override
  List<Object?> get props => [suggestionId];
}