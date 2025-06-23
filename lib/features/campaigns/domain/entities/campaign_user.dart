import 'package:equatable/equatable.dart';

class CampaignUser extends Equatable {
  final int userid;
  final String createdBy;
  final String role;
  final dynamic userimage;
  const CampaignUser({
    required this.userid,
    required this.createdBy,
    required this.role,
    required this.userimage,
  });

  @override
  List<Object?> get props => [userid, createdBy, role, userimage];
}
