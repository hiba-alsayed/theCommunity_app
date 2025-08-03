import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graduation_project/features/campaigns/domain/entities/campaigns.dart';
import 'package:graduation_project/features/campaigns/domain/usecases/get_all_campaigns.dart';
import 'package:graduation_project/features/campaigns/domain/usecases/join_campaign.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/strings/failures.dart';
import '../../data/models/campaigns_model.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/category_use_case.dart';
import '../../domain/usecases/get_all_campaigns_by_category.dart';
import '../../domain/usecases/get_my_campaigns.dart';
import '../../domain/usecases/get_nearby_campaigns.dart';
import '../../domain/usecases/get_promoted_campaigns.dart';
import '../../domain/usecases/get_recommended_campaigns.dart';
import '../../domain/usecases/rate_completed_campaign.dart';

part 'campaign_event.dart';
part 'campaign_state.dart';


class CampaignInitialState extends CampaignState {}
class CampaignBloc extends Bloc<CampaignEvent, CampaignState> {
  final GetAllCampaigns getAllCampaigns;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetAllCampaignsByCategory getAllCampaignsByCategory;
 final JoinCampaign joinCampaign;
  final GetMyCampaigns getMyCampaigns;
  final GetNearbyCampaigns getNearbyCampaigns;
  final RateCompletedCampaign rateCompletedCampaign;
  final GetRecommendedCampaigns getRecommendedCampaigns;
  final GetPromotedCampaigns getPromotedCampaigns;

  CampaignBloc({
    required this.getAllCampaigns,
    required this.getCategoriesUseCase,
    required this.getAllCampaignsByCategory,
    required this.joinCampaign,
    required this.getMyCampaigns,
    required this.getNearbyCampaigns,
    required this.rateCompletedCampaign,
    required this.getRecommendedCampaigns,
    required this.getPromotedCampaigns,
  }) : super(CampaignInitialState()) {

    // جلب كل الحملات
    on<GetAllCampaignsEvent>((event, emit) async {
      emit(LoadingAllCampaigns());
      try {
        final result = await getAllCampaigns();
        result.fold(
              (failure) =>
              emit(CampaignErrorState(message: _mapFailureToMessage(failure))),
              (campaigns) => emit(AllCampaignsLoaded(campaigns: campaigns)),
        );
      } catch (e) {
        print("❌ UNHANDLED ERROR in GetAllCampaignsEvent: $e");
        emit(CampaignErrorState(message: "Failed to process campaign data."));
      }
    });

    //  جلب التصنيفات
    on<GetCategoriesEvent>((event, emit) async {
      emit(LoadingCategories());
      final result = await getCategoriesUseCase();
      result.fold(
            (failure) => emit(CampaignErrorState(message: _mapFailureToMessage(failure))),
            (categories) => emit(CategoriesLoaded(categories: categories)),
      );
    });

    // جلب الحملات حسب التصنيف
    on<GetAllCampaignsByCategoryEvent>((event, emit) async {
      emit(LoadingCampaignsByCategory());
      final result = await getAllCampaignsByCategory(event.categoryId);
      result.fold(
            (failure) => emit(CampaignErrorState(message: _mapFailureToMessage(failure))),
            (campaigns) => emit(CampaignsByCategoryLoaded(campaigns: campaigns)),
      );
    });

    // الانضمام إلى حملة
    on<JoinCampaignEvent>((event, emit) async {
      emit(JoiningCampaign());
      final result = await joinCampaign(event.campaignId);
      result.fold(
            (failure) {
              // print('--- DEBUG: BLOC --- Received Failure of type: ${failure.runtimeType}');
          if (failure is AlreadyJoinedFailure) {
            emit(AlreadyJoinedState(message: 'لقد قمت بالانضمام بالفعل'));
          } else {
            emit(CampaignErrorState(message: _mapFailureToMessage(failure)));
          }
        },
            (message) => emit(CampaignJoinedSuccessfully(message: 'تم الانضمام')),
      );
    });

    // جلب الحملات التي انضم إليها المستخدم
    on<GetMyCampaignsEvent>((event, emit) async {
      emit(MyCampaignsLoading());
      final result = await getMyCampaigns();
      result.fold(
            (failure) => emit(MyCampaignsError(_mapFailureToMessage(failure))),
            (myCampaigns) => emit(MyCampaignsLoaded(myCampaigns)),
      );
    });

    // جلب الحملات القريبة
    on<GetNearbyCampaignsEvent>((event, emit) async {
      emit(LoadingNearbyCampaigns());
      final result = await getNearbyCampaigns(event.categoryId, event.distance);
      result.fold(
            (failure) => emit(NearbyCampaignsError(message: _mapFailureToMessage(failure))),
            (campaigns) => emit(NearbyCampaignsLoaded(nearbyCampaigns: campaigns)),
      );
    });

    //تقييم حملة
    on<RateCompletedCampaignEvent>((event, emit) async {
      emit(RatingCampaignLoading());

      final result = await rateCompletedCampaign(
        event.campaignId,
        event.rating,
        event.comment,
      );

      result.fold(
            (failure) {
          if (failure is AlreadyRatedFailure) {
            emit(RatingCampaignError(message: 'لقد قمت بتقييم هذا المشروع مسبقًا.'));
          } else {
            emit(RatingCampaignError(message: _mapFailureToMessage(failure)));
          }
        },
            (_) => emit(RatingCampaignSuccess(message: 'تم إرسال التقييم بنجاح')),
      );
    });

    // جلب الحملات الموصى بها
    on<GetRecommendedCampaignsEvent>((event, emit) async {
      emit(LoadingRecommendedCampaigns());
      await Future.delayed(const Duration(seconds: 2)); //ضفتا لزبط العرض بالشاشة
      final result = await getRecommendedCampaigns();
      result.fold(
            (failure) => emit(CampaignErrorState(message: _mapFailureToMessage(failure))),
            (campaigns) => emit(RecommendedCampaignsLoaded(recommendedCampaigns: campaigns)),
      );
    });

    // جلب الحملات معاد نشرها
    on<GetPromotedCampaignsEvent>((event, emit) async {
      emit(LoadingPromotedCampaigns());
      final result = await getPromotedCampaigns();
      result.fold(
            (failure) =>
            emit(PromotedCampaignsError(message: _mapFailureToMessage(failure))),
            (campaigns) => emit(PromotedCampaignsLoaded(promotedCampaigns: campaigns)),
      );
    });
  }
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case AlreadyJoinedFailure:
      return AlreadyJoinedMessage;
    case EmptyCacheFailure:
      return EMPTY_CACHE_FAILURE_MESSAGE;
    case OfflineFailure:
      return OFFLINE_FAILURE_MESSAGE;
    case AlreadyRatedFailure:
      return ALREADY_RATED_FAILURE_MESSAGE;

    default:
      return 'حدث خطأ غير متوقع';
  }
}
