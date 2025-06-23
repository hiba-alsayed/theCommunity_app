import 'package:equatable/equatable.dart';

class ComplaintUser extends Equatable {
  final int userid;
  final String createdBy;
  final String role;

  const ComplaintUser({
    required this.userid,
    required this.createdBy,
    required this.role,

  });
  @override
  List<Object?> get props => [userid, createdBy, role];
}
