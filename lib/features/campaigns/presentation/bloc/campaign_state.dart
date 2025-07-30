part of 'campaign_bloc.dart';

sealed class CampaignState extends Equatable {
  const CampaignState();
  @override
  List<Object> get props => [];
}

// جلب كل الحملات
class LoadingAllCampaigns extends CampaignState {}
class AllCampaignsLoaded extends CampaignState {
  final List<Campaigns> campaigns;

  AllCampaignsLoaded({required this.campaigns});

  @override
  List<Object> get props => [campaigns];
}
class LoadingMoreCampaigns extends CampaignState {
  final List<CampaignModel> oldCampaigns;

  LoadingMoreCampaigns({required this.oldCampaigns});

  @override
  List<Object> get props => [oldCampaigns];
}

// جلب التصنيفات
class LoadingCategories extends CampaignState {}
class CategoriesLoaded extends CampaignState {
  final List<MyCategory> categories;

  CategoriesLoaded({required this.categories});

  @override
  List<Object> get props => [categories];
}

// جلب الحملات حسب التصنيف
class LoadingCampaignsByCategory extends CampaignState {}
class CampaignsByCategoryLoaded extends CampaignState {
  final List<Campaigns> campaigns;

  CampaignsByCategoryLoaded({required this.campaigns});

  @override
  List<Object> get props => [campaigns];
}

//الانضمام إلى حملة
class JoiningCampaign extends CampaignState {}
class CampaignJoinedSuccessfully extends CampaignState {
  final String message;

  CampaignJoinedSuccessfully({required this.message});

  @override
  List<Object> get props => [message];
}
class AlreadyJoinedState extends CampaignState {
  final String message;
  AlreadyJoinedState({required this.message});
}

//جلب الحملات
class MyCampaignsLoading extends CampaignState {}
class MyCampaignsLoaded extends CampaignState {
  final List<Campaigns> myCampaigns;

  const MyCampaignsLoaded(this.myCampaigns);
  @override
  List<Object> get props => [myCampaigns];
}
class MyCampaignsError extends CampaignState {
  final String message;
  const MyCampaignsError(this.message);
 @override
  List<Object> get props => [message];
}

// جلب الحملات الموصى بها
class LoadingRecommendedCampaigns extends CampaignState {}
class RecommendedCampaignsLoaded extends CampaignState {
  final List<Campaigns> recommendedCampaigns;

  const RecommendedCampaignsLoaded({required this.recommendedCampaigns});

  @override
  List<Object> get props => [recommendedCampaigns];
}

// جلب الحملات القريبة
class LoadingNearbyCampaigns extends CampaignState {}
class NearbyCampaignsLoaded extends CampaignState {
  final List<Campaigns> nearbyCampaigns;

  NearbyCampaignsLoaded({required this.nearbyCampaigns});

  @override
  List<Object> get props => [nearbyCampaigns];
}
class NearbyCampaignsError extends CampaignState {
  final String message;

  NearbyCampaignsError({required this.message});

  @override
  List<Object> get props => [message];
}

// تقييم حملة مكتملة
class RatingCampaignLoading extends CampaignState {}
class RatingCampaignSuccess extends CampaignState {
  final String message;

  RatingCampaignSuccess({required this.message});

  @override
  List<Object> get props => [message];
}
class RatingCampaignError extends CampaignState {
  final String message;

  RatingCampaignError({required this.message});

  @override
  List<Object> get props => [message];
}

// جلب الحملات معاد نشرها
class LoadingPromotedCampaigns extends CampaignState {}
class PromotedCampaignsLoaded extends CampaignState {
  final List<Campaigns> promotedCampaigns;

  const PromotedCampaignsLoaded({required this.promotedCampaigns});

  @override
  List<Object> get props => [promotedCampaigns];
}
class PromotedCampaignsError extends CampaignState {
  final String message;

  const PromotedCampaignsError({required this.message});

  @override
  List<Object> get props => [message];
}

// حالة الخطأ
class CampaignErrorState extends CampaignState {
  final String message;

  CampaignErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

// حالة نجاح مع رسالة
class MessageState extends CampaignState {
  final String message;

  MessageState({required this.message});

  @override
  List<Object> get props => [message];
}
