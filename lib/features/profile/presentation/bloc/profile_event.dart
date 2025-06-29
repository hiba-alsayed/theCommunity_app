part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}
//عرض بروفايلي
class GetMyProfileEvent extends ProfileEvent {}
// عرض بروفايل مستخدم آخر بواسطة ID
class GetProfileByUserIdEvent extends ProfileEvent {
  final int userId;
  const GetProfileByUserIdEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}
// تحديث البروفايل
class UpdateClientProfileEvent extends ProfileEvent {
  final int age;
  final String phone;
  final String gender;
  final String bio;
  final String deviceToken;
  final List<String> volunteerFields;
  final String longitude;
  final String latitude;
  final String area;
  final List<String> skills;

  const UpdateClientProfileEvent({
    required this.age,
    required this.phone,
    required this.gender,
    required this.bio,
    required this.deviceToken,
    required this.volunteerFields,
    required this.longitude,
    required this.latitude,
    required this.area,
    required this.skills,
  });

  @override
  List<Object?> get props => [
    age,
    phone,
    gender,
    bio,
    deviceToken,
    volunteerFields,
    longitude,
    latitude,
    area,
    skills,
  ];
}