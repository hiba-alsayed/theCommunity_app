import 'package:equatable/equatable.dart';
//1
class ProjectEntity extends Equatable {
  final String title;
  final String description;

  const ProjectEntity({
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [title, description];
}
//2
class DonationItemEntity extends Equatable {
  final int id;
  final int projectId;
  final DateTime donatedAt;
  final String amount;
  final String status;
  final ProjectEntity project;

  const DonationItemEntity({
    required this.id,
    required this.projectId,
    required this.donatedAt,
    required this.amount,
    required this.status,
    required this.project,
  });

  @override
  List<Object?> get props => [id, projectId, donatedAt, amount, status, project];
}
//3
class MyDonationsEntity extends Equatable {
  final bool status;
  final String message;
  final List<DonationItemEntity> donations;

  const MyDonationsEntity({
    required this.status,
    required this.message,
    required this.donations,
  });

  @override
  List<Object?> get props => [status, message, donations];
}