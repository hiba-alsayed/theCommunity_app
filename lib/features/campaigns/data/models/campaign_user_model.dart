// import 'package:graduation_project/features/campaigns/domain/entities/campaign_user.dart';
//
// class CampaignUserModel extends CampaignUser {
//   const CampaignUserModel({
//     required int userid,
//     required String createdBy,
//     required String role,
//     required dynamic userimage,
//   }) : super(
//     userid: userid,
//     createdBy: createdBy,
//     role: role,
//     userimage: userimage,
//   );
//
//   factory CampaignUserModel.fromJson(Map<String, dynamic> json) {
//     return CampaignUserModel(
//       userid: json['userID'],
//       createdBy: json['created_by'],
//       role: json['role'],
//       // userimage: (json['userImage'] != null && json['userImage'] is List && json['userImage'].isNotEmpty)
//       //     ? json['userImage'][0]
//       //     : null,
//       userimage: json['userImage'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'userID': userid,
//       'created_by': createdBy,
//       'role': role,
//       'userImage': userimage ?? "",
//     };
//   }
// }
import 'package:graduation_project/features/campaigns/domain/entities/campaign_user.dart';
class CampaignUserModel extends CampaignUser {
  const CampaignUserModel({
    required int userid,
    required String createdBy,
    required String role,
    dynamic userimage,
  }) : super(
    userid: userid,
    createdBy: createdBy,
    role: role,
    userimage: userimage,
  );

  factory CampaignUserModel.fromJson(Map<String, dynamic> json) {
    return CampaignUserModel(
      userid: json['userID'] ?? 0,
      createdBy: json['created_by'] ?? '',
      role: json['role'] ?? '',
      userimage: _parseUserImage(json['userImage']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userid,
      'created_by': createdBy,
      'role': role,
      'userImage': userimage ?? '',
    };
  }

  static dynamic _parseUserImage(dynamic image) {
    if (image == null) return null;
    if (image is List && image.isNotEmpty) return image[0];
    return image;
  }

  static CampaignUserModel empty() => const CampaignUserModel(
    userid: 0,
    createdBy: '',
    role: '',
    userimage: null,
  );
}

