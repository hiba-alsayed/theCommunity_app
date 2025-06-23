import 'package:equatable/equatable.dart';
import 'package:graduation_project/features/campaigns/domain/entities/rating.dart';

import 'campaign_location.dart';
import 'campaign_user.dart';

class Campaigns extends Equatable {
  final int id;
  final String title;
  final String description;
  final String status;
  final String? executionDate;
  final CampaignUser campaignUser;
  final dynamic imageUrl;
  final dynamic category;
  final CampaignLocation campaignLocation;
  final double donationTotal;
  final int numberOfParticipants;
  final int joinedParticipants;
  final String requiredAmount;
  final String createdAt;
  final String type;
  final double? avgRating;
  final List<Rating>? ratings;

  Campaigns({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.executionDate,
    required this.campaignUser,
    required this.imageUrl,
    required this.category,
    required this.campaignLocation,
    required this.donationTotal,
    required this.numberOfParticipants,
    required this.joinedParticipants,
    required this.requiredAmount,
    required this.createdAt,
    required this.type,
    required this.avgRating,
    this.ratings,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    status,
    executionDate,
    campaignUser,
    imageUrl,
    category,
    campaignLocation,
    donationTotal,
    numberOfParticipants,
    joinedParticipants,
    requiredAmount,
    createdAt,
    type,
    avgRating,
  ];
}
