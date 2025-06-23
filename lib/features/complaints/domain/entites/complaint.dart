import 'package:equatable/equatable.dart';

import 'achievement_image.dart';
import 'complaint_image.dart';
import 'complaint_location.dart';
import 'complaint_user.dart';

class ComplaintEntity extends Equatable {
  final int id;
  final int points;
  final String region;
  final String title;
  final String description;
  final String status;
  final DateTime createdAt;
  final ComplaintUser user;
  final String? imageUrl;
  final String category;
  final ComplaintLocation location;
  final List<ComplaintImageEntity> complaintImages;
  final List<AchievementImageEntity> achievementImages;

  const ComplaintEntity({
    required this.id,
    required this.points,
    required this.region,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.user,
    this.imageUrl,
    required this.category,
    required this.location,
    required this.complaintImages,
    required this.achievementImages,
  });

  @override
  List<Object?> get props => [
    id,
    points,
    region,
    title,
    description,
    status,
    createdAt,
    user,
    imageUrl,
    category,
    location,
    complaintImages,
    achievementImages,
  ];
}
