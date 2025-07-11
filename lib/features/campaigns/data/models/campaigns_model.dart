// import 'campaign_user_model.dart';
// import 'campaign_location_model.dart';
// import 'rating_model.dart';
// import '../../domain/entities/campaigns.dart';
//
// class CampaignModel extends Campaigns {
//   CampaignModel({
//     int? id,
//     String? title,
//     String? description,
//     String? status,
//     String? executionDate,
//     CampaignUserModel? campaignUser,
//     String? imageUrl,
//     dynamic category,
//     CampaignLocationModel? campaignLocation,
//     double? donationTotal,
//     int? numberOfParticipants,
//     int? joinedParticipants,
//     String? requiredAmount,
//     String? createdAt,
//     String? type,
//     double? avgRating,
//     List<RatingModel>? ratings,
//   }) : super(
//     id: id ?? 0,
//     title: title ?? '',
//     description: description ?? '',
//     status: status ?? '',
//     executionDate: executionDate ?? '',
//     campaignUser: campaignUser! ,
//     imageUrl: imageUrl,
//     category: category,
//     campaignLocation: campaignLocation!,
//     donationTotal: donationTotal ?? 0.0,
//     numberOfParticipants: numberOfParticipants ?? 0,
//     joinedParticipants: joinedParticipants ?? 0,
//     requiredAmount: requiredAmount ?? '0',
//     createdAt: createdAt ?? '',
//     type: type ?? '',
//     avgRating: avgRating,
//     ratings: ratings,
//   );
//
//   factory CampaignModel.fromJson(Map<String, dynamic> json) {
//
//     return CampaignModel(
//       id: json['id'],
//       title: json['title'],
//       description: json['description'],
//       status: json['status'],
//       executionDate: json['execution_date'],
//       campaignUser: CampaignUserModel.fromJson(json['user']),
//       imageUrl: json['image_url'],
//           // == "null" ? null : json['image_url'],
//       category: json['category'],
//       campaignLocation: CampaignLocationModel.fromJson(json['location']),
//       donationTotal: double.tryParse(json['donation_total'].toString()) ?? 0.0,
//       numberOfParticipants: json['number_of_participants'],
//       joinedParticipants: json['joined_participants'],
//       requiredAmount: json['required_amount'],
//       createdAt: json['created_at'],
//       type: json['type'],
//       avgRating: json['avg_rating'] == null ? null : (json['avg_rating'] as num).toDouble(),
//       ratings: json['ratings'] != null
//           ? (json['ratings'] as List).map((e) => RatingModel.fromJson(e)).toList()
//           : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'title': title,
//     'description': description,
//     'status': status,
//     'execution_date': executionDate,
//     'user': (campaignUser as CampaignUserModel).toJson(),
//     'image_url': imageUrl,
//     'category': category,
//     'location': (campaignLocation as CampaignLocationModel).toJson(),
//     'donation_total': donationTotal,
//     'number_of_participants': numberOfParticipants,
//     'joined_participants': joinedParticipants,
//     'required_amount': requiredAmount,
//     'created_at': createdAt,
//     'type': type,
//     'avg_rating': avgRating,
//     'ratings': ratings?.map((e) => (e as RatingModel).toJson()).toList(),
//   };
// }'
import 'package:graduation_project/features/campaigns/data/models/rating_model.dart';
import '../../domain/entities/campaigns.dart';
import 'campaign_location_model.dart';
import 'campaign_user_model.dart';

class CampaignModel extends Campaigns {
  CampaignModel({
    required int id,
    required String title,
    required String description,
    required String status,
    required String executionDate,
    required CampaignUserModel campaignUser,
    String? imageUrl,
    dynamic category,
    required CampaignLocationModel campaignLocation,
    double donationTotal = 0.0,
    int numberOfParticipants = 0,
    int joinedParticipants = 0,
    String requiredAmount = '0',
    String createdAt = '',
    required String type,
    double? avgRating,
    List<RatingModel>? ratings,
  }) : super(
    id: id,
    title: title,
    description: description,
    status: status,
    executionDate: executionDate,
    campaignUser: campaignUser,
    imageUrl: imageUrl,
    category: category,
    campaignLocation: campaignLocation,
    donationTotal: donationTotal,
    numberOfParticipants: numberOfParticipants,
    joinedParticipants: joinedParticipants,
    requiredAmount: requiredAmount,
    createdAt: createdAt,
    type: type,
    avgRating: avgRating,
    ratings: ratings,
  );

  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    return CampaignModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      executionDate: json['execution_date'] ?? '',
      campaignUser: json['user'] != null
          ? CampaignUserModel.fromJson(json['user'])
          : CampaignUserModel.empty(),
      imageUrl: json['image_url'],
      category: json['category'],
      campaignLocation: json['location'] != null
          ? CampaignLocationModel.fromJson(json['location'])
          : CampaignLocationModel.empty(),
      donationTotal: double.tryParse(json['donation_total']?.toString() ?? '') ?? 0.0,
      numberOfParticipants: json['number_of_participants'] ?? 0,
      joinedParticipants: json['joined_participants'] ?? 0,
      requiredAmount: json['required_amount'] ?? '0',
      createdAt: json['created_at'] ?? '',
      type: json['type'] ?? '',
      avgRating: (json['avg_rating'] as num?)?.toDouble(),
      ratings: (json['ratings'] as List<dynamic>?)
          ?.map((e) => RatingModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'status': status,
    'execution_date': executionDate,
    'user': (campaignUser as CampaignUserModel).toJson(),
    'image_url': imageUrl,
    'category': category,
    'location': (campaignLocation as CampaignLocationModel).toJson(),
    'donation_total': donationTotal,
    'number_of_participants': numberOfParticipants,
    'joined_participants': joinedParticipants,
    'required_amount': requiredAmount,
    'created_at': createdAt,
    'type': type,
    'avg_rating': avgRating,
    'ratings':
    ratings?.map((e) => (e as RatingModel).toJson()).toList(),
  };
}

