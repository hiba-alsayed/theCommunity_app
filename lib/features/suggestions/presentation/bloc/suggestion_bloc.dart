import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:graduation_project/features/campaigns/domain/entities/category.dart';
import 'package:graduation_project/features/suggestions/domain/entities/Suggestions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/strings/failures.dart';
import '../../../../core/strings/messages.dart';
import '../../../campaigns/domain/usecases/category_use_case.dart';
import '../../data/models/Suggestion_model.dart';
import '../../domain/entities/Suggestions.dart';
import '../../domain/usecases/delete_my_suggestion.dart';
import '../../domain/usecases/get_all_suggestions.dart';
import '../../domain/usecases/get_my_suggestions.dart';
import '../../domain/usecases/get_nearby_suggestions.dart';
import '../../domain/usecases/get_suggestion_category.dart';
import '../../domain/usecases/get_suggestions_by_category.dart';
import '../../domain/usecases/submit_suggestion.dart';
import '../../domain/usecases/vote_on_suggestion.dart';

part 'suggestion_event.dart';
part 'suggestion_state.dart';

class SuggestionInitialState extends SuggestionState {}

class SuggestionBloc extends Bloc<SuggestionEvent, SuggestionState> {
  final GetAllSuggestions getAllSuggestions;
  final GetMySuggestions getMySuggestions;
  final SubmitSuggestion submitSuggestion;
  final VoteOnSuggestion voteOnSuggestion;
  final GetSuggestionsByCategory getSuggestionsByCategory;
  final GetNearbySuggestions getNearbySuggestions;
  final DeleteMySuggestion deleteMySuggestion;
  final GetSuggestionCategory getSuggestionCategories;

  int currentPage = 1;
  bool hasReachedMax = false;

  SuggestionBloc({
    required this.getAllSuggestions,
    required this.getMySuggestions,
    required this.submitSuggestion,
    required this.voteOnSuggestion,
    required this.getSuggestionsByCategory,
    required this.getNearbySuggestions,
    required this.deleteMySuggestion,
    required this.getSuggestionCategories,
  }) : super(SuggestionInitialState()) {

    //جلب كل المقترحات
    on<GetAllSuggestionsEvent>((event, emit) async {
      emit(LoadingAllSuggestions());
      final result = await getAllSuggestions();
      result.fold(
        (failure) =>
            emit(SuggestionErrorState(message: _mapFailureToMessage(failure))),
        (suggestions) => emit(AllSuggestionsLoaded(suggestion: suggestions)),
      );
    });
    on<RefreshAllSuggestionsEvent>((event, emit) async {
      final result = await getAllSuggestions();
      result.fold(
        (failure) =>
            emit(SuggestionErrorState(message: _mapFailureToMessage(failure))),
        (suggestions) => emit(AllSuggestionsLoaded(suggestion: suggestions)),
      );
    });

    //جلب التصنيفات
    on<LoadSuggestionCategoriesEvent>((event, emit) async {
      emit(LoadingSuggestionCategories());
      final result = await getSuggestionCategories();

      result.fold(
            (failure) => emit(SuggestionCategoryError("فشل في تحميل التصنيفات")),
            (categories) => emit(SuggestionCategoriesLoaded(categories)),
      );
    });
    //رفع مقترح
    on<SubmitSuggestionEvent>((event, emit) async {
      emit(SubmittingSuggestionState());
      final result = await submitSuggestion(
        title: event.title,
        description: event.description,
        requiredAmount: event.requiredAmount,
        area: event.area,
        longitude: event.longitude,
        latitude: event.latitude,
        categoryId: event.categoryId,
        numberOfParticipants: event.numberOfParticipants,
        imageUrl: event.imageUrl,
      );
      result.fold(
        (failure) => emit(
          SuggestionSubmittedErrorState(error: _mapFailureToMessage(failure)),
        ),
        (message) =>
            emit(SuggestionSubmittedSuccessState(message: ADD_SUCCESS_MESSAGE)),
      );
    });

    // التصويت على مقترح
    on<voteOnSuggestionEvent>((event, emit) async {
      emit(VoteOnSuggestionLoading());

      final result = await voteOnSuggestion(
        suggestionId: event.suggestionId,
        value: event.value,
      );

      result.fold(
        (failure) {
          if (failure is DuplicateVoteFailure) {
            emit(VoteOnSuggestionFailure(message: failure.message));
          } else {
            emit(VoteOnSuggestionFailure(message: 'لقد قمت بالتصويت بالفعل'));
          }
        },
        (_) {
          if (event.value == 1) {
            event.suggestion.likes += 1;
          } else {
            event.suggestion.dislikes += 1;
          }
          emit(VoteOnSuggestionSuccess(updatedSuggestion: event.suggestion));
        },
      );
    });

    //جلب المقترحات حسب التصنيف
    on<LoadSuggestionsByCategoryEvent>((event, emit) async {
      emit(LoadingSuggestionsByCategory());
      final result = await getSuggestionsByCategory(event.categoryId);
      result.fold(
        (failure) =>
            emit(SuggestionErrorState(message: _mapFailureToMessage(failure))),
        (suggestions) =>
            emit(SuggestionsByCategoryLoaded(suggestions: suggestions)),
      );
    });

    //جلب المقترحات القريبة
    on<GetNearbySuggestionsEvent>((event, emit) async {
      emit(SuggestionsLoading());
      final Either<Failure, List<Suggestions>> failureOrSuggestions =
      await getNearbySuggestions(
        categoryId: event.categoryId,
        distance: event.distance,
      );
      failureOrSuggestions.fold(
            (failure) => emit(SuggestionsError(message: _mapFailureToMessage(failure))),
            (suggestions) => emit(SuggestionsLoaded(suggestions: suggestions)),
      );
    });

    //جلب مقترحاتي
    on<GetMySuggestionsEvent>((event, emit) async {
      emit(GetMySuggestionsLoading());
      final result = await getMySuggestions();
      result.fold(
            (failure) => emit(GetMySuggestionsError(_mapFailureToMessage(failure))),
            (suggestions) => emit(GetMySuggestionsLoaded(suggestions)),
      );
    });
    //حذف مقترح
    on<DeleteMySuggestionEvent>((event, emit) async {
      emit(DeleteMySuggestionLoading());
      final result = await deleteMySuggestion(event.suggestionId);
      result.fold(
            (failure) => emit(DeleteMySuggestionFailure(_mapFailureToMessage(failure))),
            (_) => emit(const DeleteMySuggestionSuccess("Suggestion deleted successfully.")),
      );
    });
  }
  }


  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case EmptyCacheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return 'حدث خطأ غير متوقع';
    }
  }

