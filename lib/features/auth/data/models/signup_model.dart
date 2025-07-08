import '../../domain/entities/signup_entity.dart';
class SignUpModel extends SignUpEntity {
   SignUpModel({
    required String email,
    required String password,
    required String passwordConfirmation,
    required String name,
    required int age,
    required String phone,
    required String gender,
    required String bio,
    String? deviceToken,
    required List<String> skills,
    required List<String> volunteerFields,
    required double longitude,
    required double latitude,
    required String area,
    String? image,
  }) : super(
    email: email,
    password: password,
    passwordConfirmation: passwordConfirmation,
    name: name,
    age: age,
    phone: phone,
    gender: gender,
    bio: bio,
    deviceToken: deviceToken,
    skills: skills,
    volunteerFields: volunteerFields,
    longitude: longitude,
    latitude: latitude,
    area: area,
    image: image,
  );

  factory SignUpModel.fromJson(SignUpEntity entity) {
    return SignUpModel(
      email: entity.email,
      password: entity.password,
      passwordConfirmation: entity.passwordConfirmation,
      name: entity.name,
      age: entity.age,
      phone: entity.phone,
      gender: entity.gender,
      bio: entity.bio,
      deviceToken: entity.deviceToken,
      skills: entity.skills,
      volunteerFields: entity.volunteerFields,
      longitude: entity.longitude,
      latitude: entity.latitude,
      area: entity.area,
      image: entity.image,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'name': name,
      'age': age,
      'phone': phone,
      'gender': gender,
      'bio': bio,
      if (deviceToken != null) 'device_token': deviceToken,
      'skills': skills,
      'volunteer_fields': volunteerFields,
      'longitude': longitude,
      'latitude': latitude,
      'area': area,
      if (image != null) 'image': image,
    };
  }
}