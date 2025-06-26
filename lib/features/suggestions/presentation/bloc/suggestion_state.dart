part of 'suggestion_bloc.dart';

sealed class SuggestionState extends Equatable {
  const SuggestionState();
  @override
  List<Object?> get props => [];
}

//جلب كل المقترحات
class LoadingAllSuggestions extends SuggestionState {}
class AllSuggestionsLoaded extends SuggestionState {
  final List<Suggestions> suggestion;

  AllSuggestionsLoaded({required this.suggestion});

  @override
  List<Object?> get props => [Suggestions];
}
class LoadingMoreSuggestions extends SuggestionState {
  final List<SuggestionModel> oldSuggestions;

  LoadingMoreSuggestions({required this.oldSuggestions});

  @override
  List<Object?> get props => [oldSuggestions];
}

//جلب مقترحاتي
class GetMySuggestionsLoading extends SuggestionState{}
class GetMySuggestionsLoaded extends SuggestionState{
  final List<Suggestions> suggestions;

  GetMySuggestionsLoaded( this.suggestions);
  @override
  List<Object?> get props => [suggestions];
}
class GetMySuggestionsError extends SuggestionState{
  final String message;

  const GetMySuggestionsError(this.message);

  @override
  List<Object?> get props => [message];
}

//جلب المقترحات حسب التصنيف
class LoadingSuggestionsByCategory extends SuggestionState {}
class SuggestionsByCategoryLoaded extends SuggestionState {
  final List<Suggestions> suggestions;

  SuggestionsByCategoryLoaded({required this.suggestions});

  @override
  List<Object?> get props => [suggestions];
}

//جلب التصنيفات
class LoadingSuggestionCategories extends SuggestionState {}
class SuggestionCategoriesLoaded extends SuggestionState {
  final List<MyCategory> categories;

  const SuggestionCategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}
class SuggestionCategoryError extends SuggestionState {
  final String message;

  const SuggestionCategoryError(this.message);

  @override
  List<Object?> get props => [message];
}

//جلب المقترحات القريبة
class SuggestionsLoading extends SuggestionState {}
class SuggestionsLoaded extends SuggestionState {
  final List<Suggestions> suggestions;

  SuggestionsLoaded({required this.suggestions});
}
class SuggestionsError extends SuggestionState {
  final String message;

  SuggestionsError({required this.message});
}

//التصويت على مقترح
class VoteOnSuggestionLoading extends SuggestionState {}
class VoteOnSuggestionSuccess extends SuggestionState {
  final Suggestions updatedSuggestion;

  VoteOnSuggestionSuccess({required this.updatedSuggestion});
}
class VoteOnSuggestionFailure extends SuggestionState {
  final String message;

  const VoteOnSuggestionFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

//رفع مقترح
class SubmittingSuggestionState extends SuggestionState {}
class SuggestionSubmittedSuccessState extends SuggestionState {
  final String message;

  SuggestionSubmittedSuccessState({required this.message});

  @override
  List<Object?> get props => [message];
}
class SuggestionSubmittedErrorState extends SuggestionState {
  final String error;

  SuggestionSubmittedErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

//حذف مقترح
class DeleteMySuggestionInitial extends SuggestionState {}
class DeleteMySuggestionLoading extends SuggestionState {}
class DeleteMySuggestionSuccess extends SuggestionState {
  final String message;

  const DeleteMySuggestionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
class DeleteMySuggestionFailure extends SuggestionState {
  final String error;

  const DeleteMySuggestionFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Error state
class SuggestionErrorState extends SuggestionState {
  final String message;

  SuggestionErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

// success state
class MessageState extends SuggestionState {
  final String message;

  MessageState({required this.message});

  @override
  List<Object> get props => [message];
}
