//
// import 'dart:convert'; // <<<--- ADD THIS IMPORT
// import '../../domain/entities/signup_entity.dart';
//
// class SignUpModel extends SignUpEntity {
//   SignUpModel({
//     required String email,
//     required String password,
//     required String passwordConfirmation,
//     required String name,
//     required int age,
//     required String phone,
//     required String gender,
//     required String bio,
//     String? deviceToken,
//     required List<String> skills,
//     required List<String> volunteerFields,
//     required double longitude,
//     required double latitude,
//     required String area,
//     String? image,
//   }) : super(
//     email: email,
//     password: password,
//     passwordConfirmation: passwordConfirmation,
//     name: name,
//     age: age,
//     phone: phone,
//     gender: gender,
//     bio: bio,
//     deviceToken: deviceToken,
//     skills: skills,
//     volunteerFields: volunteerFields,
//     longitude: longitude,
//     latitude: latitude,
//     area: area,
//     image: image,
//   );
//
//   // Keep your fromJson factory as is, as it's for creating the model from an entity,
//   // not directly from a backend JSON response.
//   factory SignUpModel.fromJson(SignUpEntity entity) {
//     return SignUpModel(
//       email: entity.email,
//       password: entity.password,
//       passwordConfirmation: entity.passwordConfirmation,
//       name: entity.name,
//       age: entity.age,
//       phone: entity.phone,
//       gender: entity.gender,
//       bio: entity.bio,
//       deviceToken: entity.deviceToken,
//       skills: entity.skills,
//       volunteerFields: entity.volunteerFields,
//       longitude: entity.longitude,
//       latitude: entity.latitude,
//       area: entity.area,
//       image: entity.image,
//     );
//   }
//
//   @override // Good practice to add @override if toJson is overriding a base class method
//   Map<String, dynamic> toJson() {
//     return {
//       'email': email,
//       'password': password,
//       'password_confirmation': passwordConfirmation,
//       'name': name,
//       'age': age,
//       'phone': phone,
//       'gender': gender,
//       'bio': bio,
//       if (deviceToken != null) 'device_token': deviceToken,
//       // <<<--- THE FIX IS HERE --->>>
//       'skills': json.encode(skills), // Convert the List<String> to a JSON string
//       'volunteer_fields': json.encode(volunteerFields), // Convert the List<String> to a JSON string
//       // <<<--------------------->>>
//       'longitude': longitude,
//       'latitude': latitude,
//       'area': area,
//       if (image != null) 'image': image,
//     };
//   }
// }
import 'dart:convert'; // Make sure this is imported if you use json.encode in toJson
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

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      email: json['email'] as String,
      password: '',
      passwordConfirmation: '',

      name: json['name'] as String,
      age: json['age'] as int,
      phone: json['phone'] as String,
      gender: json['gender'] as String,
      bio: json['bio'] as String,
      deviceToken: json['device_token'] as String?, // Can be null

      // For lists, cast them safely
      skills: (json['skills'] is String) // If backend returns skills as JSON string, decode it
          ? List<String>.from(jsonDecode(json['skills']) as List<dynamic>)
          : List<String>.from(json['skills'] as List<dynamic>),

      volunteerFields: (json['volunteer_fields'] is String) // Same for volunteer_fields
          ? List<String>.from(jsonDecode(json['volunteer_fields']) as List<dynamic>)
          : List<String>.from(json['volunteer_fields'] as List<dynamic>),

      longitude: json['longitude'] as double,
      latitude: json['latitude'] as double,
      area: json['area'] as String,
      image: json['image'] as String?, // Can be null
    );
  }

  @override
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
      'skills': json.encode(skills),
      'volunteer_fields': json.encode(volunteerFields),
      'longitude': longitude,
      'latitude': latitude,
      'area': area,
      if (image != null) 'image': image,
    };
  }
}