import 'package:graduation_project/features/complaints/domain/entites/complaint_user.dart';

class ComplaintUserModel extends ComplaintUser {
  const ComplaintUserModel({
    required int userid,
    required String createdBy,
    required String role,

  }) : super(
    userid: userid,
    createdBy: createdBy,
    role: role,

  );

  factory ComplaintUserModel.fromJson(Map<String, dynamic> json) {
    return ComplaintUserModel(
      userid: json['userID'],
      createdBy: json['created_by'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userid,
      'created_by': createdBy,
      'role': role,
    };
  }
}
