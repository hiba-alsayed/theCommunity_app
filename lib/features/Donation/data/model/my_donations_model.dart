import '../../domain/entity/my_donations_entity.dart';
//1
class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required String title,
    required String description,
  }) : super(title: title, description: description);

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }
}
//2
class DonationItemModel extends DonationItemEntity {
  const DonationItemModel({
    required int id,
    required int projectId,
    required DateTime donatedAt,
    required String amount,
    required String status,
    required ProjectModel project,
  }) : super(
    id: id,
    projectId: projectId,
    donatedAt: donatedAt,
    amount: amount,
    status: status,
    project: project,
  );

  factory DonationItemModel.fromJson(Map<String, dynamic> json) {
    return DonationItemModel(
      id: json['id'],
      projectId: json['projectID'],
      donatedAt: DateTime.parse(json['donated_at']),
      amount: json['amount'],
      status: json['status'],
      project: ProjectModel.fromJson(json['project']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectID': projectId,
      'donated_at': donatedAt.toIso8601String(),
      'amount': amount,
      'status': status,
      'project': (project as ProjectModel).toJson(),
    };
  }
}
//3
class MyDonationsModel extends MyDonationsEntity {
  const MyDonationsModel({
    required bool status,
    required String message,
    required List<DonationItemEntity> donations,
  }) : super(
    status: status,
    message: message,
    donations: donations,
  );

  factory MyDonationsModel.fromJson(Map<String, dynamic> json) {
    return MyDonationsModel(
      status: json['status'],
      message: json['message'],
      donations: (json['data'] as List<dynamic>)
          .map((item) => DonationItemModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': donations.map((item) => (item as DonationItemModel).toJson()).toList(),
    };
  }
}