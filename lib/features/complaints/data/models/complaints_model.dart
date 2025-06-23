import 'package:graduation_project/features/complaints/data/models/complaint_user_model.dart';
import 'package:graduation_project/features/complaints/data/models/complaint_location_model.dart';
import 'package:graduation_project/features/complaints/data/models/complaint_image_model.dart';
import '../../domain/entites/complaint.dart';
import 'achivement_image_model.dart';

class ComplaintModel extends ComplaintEntity {
  ComplaintModel({
    required int id,
    required int points,
    required String region,
    required String title,
    required String description,
    required String status,
    required DateTime createdAt,
    required ComplaintUserModel user,
    required String imageUrl,
    required String category,
    required ComplaintLocationModel location,
    required List<ComplaintImageModel> complaintImages,
    required List<AchievementImageModel> achievementImages,
  }) : super(
    id: id,
    points: points,
    region: region,
    title: title,
    description: description,
    status: status,
    createdAt: createdAt,
    user: user,
    imageUrl: imageUrl,
    category: category,
    location: location,
    complaintImages: complaintImages,
    achievementImages: achievementImages,
  );

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'] ?? 0,
      points: json['points'] ?? 0,
      region: json['region'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      user: ComplaintUserModel.fromJson(json['user']),
      imageUrl: json['image_url'] ?? '',
      category: json['category'] ?? '',
      location: json['location'] != null
          ? ComplaintLocationModel.fromJson(json['location'])
          : ComplaintLocationModel(),
      complaintImages: (json['complaint_images'] as List?)
          ?.map((img) => ComplaintImageModel.fromJson(img))
          .toList() ??
          [],
      achievementImages: (json['achievement_images'] as List?)
          ?.map((img) => AchievementImageModel.fromJson(img))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'points': points,
      'region': region,
      'title': title,
      'description': description,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'user': (user as ComplaintUserModel).toJson(),
      'image_url': imageUrl,
      'category': category,
      'location': (location as ComplaintLocationModel).toJson(),
      'complaint_images': complaintImages
          .map((img) => (img as ComplaintImageModel).toJson())
          .toList(),
      'achievement_images': achievementImages
          .map((img) => (img as AchievementImageModel).toJson())
          .toList(),
    };
  }
}
