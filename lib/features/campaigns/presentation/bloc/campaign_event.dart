part of 'campaign_bloc.dart';

sealed class CampaignEvent extends Equatable {
  const CampaignEvent();
    @override
    List<Object?> get props => [];
  }

//جلب كل الحملات
class GetAllCampaignsEvent extends CampaignEvent{}
class LoadMoreCampaignsEvent extends CampaignEvent {}

// جلب التصنيفات
class GetCategoriesEvent extends CampaignEvent {}

// جلب الحملات حسب التصنيف
class GetAllCampaignsByCategoryEvent extends CampaignEvent {
  final int categoryId;

  const GetAllCampaignsByCategoryEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

// الانضمام إلى حملة
class JoinCampaignEvent extends CampaignEvent {
  final int campaignId;

  const JoinCampaignEvent(this.campaignId);

  @override
  List<Object?> get props => [campaignId];
}

//جلب حملاتي
class GetMyCampaignsEvent extends CampaignEvent {}

// جلب الحملات القريبة
class GetNearbyCampaignsEvent extends CampaignEvent {
  final int categoryId;
  final double distance;

  const GetNearbyCampaignsEvent({required this.categoryId, required this.distance});

  @override
  List<Object?> get props => [categoryId, distance];
}

// تقييم حملة مكتملة
class RateCompletedCampaignEvent extends CampaignEvent {
  final int campaignId;
  final int rating;
  final String comment;

  const RateCompletedCampaignEvent({
    required this.campaignId,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object?> get props => [campaignId, rating, comment];
}

// جلب الحملات الموصى بها
class GetRecommendedCampaignsEvent extends CampaignEvent {}

// جلب الحملات معاد نشرها
class GetPromotedCampaignsEvent extends CampaignEvent {}

// جلب الحملات ذات الصلة
class GetRelatedCampaignsEvent extends CampaignEvent {
  final int projectId;

  const GetRelatedCampaignsEvent(this.projectId);

  @override
  List<Object?> get props => [projectId];
}