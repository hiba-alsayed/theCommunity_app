import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
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
