import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int userid;
  final String createdBy;
  final String role;
  final dynamic userimage;
  const User({
    required this.userid,
    required this.createdBy,
    required this.role,
    required this.userimage,
  });

  @override
  List<Object?> get props => [userid, createdBy, role, userimage];
}
