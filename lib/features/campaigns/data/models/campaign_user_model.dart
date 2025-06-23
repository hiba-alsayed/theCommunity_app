import 'package:graduation_project/features/campaigns/domain/entities/campaign_user.dart';

class CampaignUserModel extends CampaignUser {
  const CampaignUserModel({
    required int userid,
    required String createdBy,
    required String role,
    required dynamic userimage,
  }) : super(
    userid: userid,
    createdBy: createdBy,
    role: role,
    userimage: userimage,
  );

  factory CampaignUserModel.fromJson(Map<String, dynamic> json) {
    return CampaignUserModel(
      userid: json['userID'],
      createdBy: json['created_by'],
      role: json['role'],
      // userimage: (json['userImage'] != null && json['userImage'] is List && json['userImage'].isNotEmpty)
      //     ? json['userImage'][0]
      //     : null,
      userimage: json['userImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userid,
      'created_by': createdBy,
      'role': role,
      'userImage': userimage ?? "",
    };
  }
}
