import 'package:graduation_project/features/profile/domain/entity/profile_entity.dart';
import 'package:graduation_project/features/profile/data/models/prof_location_model.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.email,
    required super.location,
    required super.imageUrl,
    required super.bio,
    required super.phone,
    required super.age,
    required super.gender,
    required super.skills,
    required super.fields,
    required super.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      location: ProfLocationModel.fromJson(json['location'] as Map<String, dynamic>),
      imageUrl: json['image_url'] as String ?? '',
      bio: json['bio'] as String,
      phone: json['phone'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      skills: (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      fields: (json['volunteer_fields'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'email': email,
      'location': (location as ProfLocationModel).toJson(),
      'image_url': imageUrl,
      'bio': bio,
      'phone': phone,
      'age': age,
      'gender': gender,
      'skills': skills,
      'volunteer_fields': fields,
      'created_at': createdAt.toIso8601String(),
    };
  }
}