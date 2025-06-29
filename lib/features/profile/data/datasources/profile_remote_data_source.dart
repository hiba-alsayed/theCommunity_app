import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/auth_token_provider.dart';
import '../../../../core/base_url.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getMyProfile();
  Future<ProfileModel> getProfileByUserId(int userId);
  Future<String> updateClientProfile({
    required int age,
    required String phone,
    required String gender,
    required String bio,
    required String deviceToken,
    required List<String> volunteerFields,
    required String longitude,
    required String latitude,
    required String area,
    required List<String> skills,
  });
}
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource{
  final http.Client client;
  final AuthTokenProvider tokenProvider;

  ProfileRemoteDataSourceImpl({required this.client, required this.tokenProvider});

  @override
  Future<ProfileModel> getMyProfile() async {
    final token = await tokenProvider.getToken();
    try {
      final response = await client.get(
        Uri.parse("$baseUrl/api/client/profile/show"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['status'] == true && responseBody['data'] != null) {
          return ProfileModel.fromJson(responseBody['data'] as Map<String, dynamic>);
        } else {
          throw ServerException();
        }
      } else {
        print('Failed to load profile. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw ServerException();
      }
    } on Exception catch (e) {
      print('Error in getMyProfile remote data source: $e');
      throw ServerException();
    }
  }

  @override
  Future<ProfileModel> getProfileByUserId(int userId) async {
    final token = await tokenProvider.getToken();
    try {
      final response = await client.get(
        Uri.parse("$baseUrl/api/client/profile/show/$userId"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['status'] == true && responseBody['data'] != null) {
          return ProfileModel.fromJson(responseBody['data'] as Map<String, dynamic>);
        } else {
          throw ServerException(message: responseBody['message'] ?? 'Failed to get profile data.');
        }
      } else {
        print('Failed to load profile for user $userId. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw ServerException(statusCode: response.statusCode, message: 'Server error: ${response.statusCode}');
      }
    } on Exception catch (e) {
      print('Error in getProfileByUserId remote data source: $e');
      throw ServerException();
    }
  }

  @override
  Future<String> updateClientProfile({
    required int age,
    required String phone,
    required String gender,
    required String bio,
    required String deviceToken,
    required List<String> volunteerFields,
    required String longitude,
    required String latitude,
    required String area,
    required List<String> skills,
  }) async {
    final token = await tokenProvider.getToken();
    final Map<String, dynamic> requestBody = {
      'age': age,
      'phone': phone,
      'gender': gender,
      'bio': bio,
      'device_token': deviceToken,
      // --- IMPORTANT CHANGE HERE ---
      'volunteer_fields': json.encode(volunteerFields), // Encode list to JSON string
      'longitude': longitude,
      'latitude': latitude,
      'area': area,
      'skills': json.encode(skills), // Encode list to JSON string
      // ----------------------------
    };

    try {
      final response = await client.post(
        Uri.parse("$baseUrl/api/client/profile/update"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(requestBody), // Encode the entire map to a JSON string
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['status'] == true) {
          return responseBody['message'] as String;
        } else {
          throw ServerException(message: responseBody['message'] ?? 'Failed to update profile.');
        }
      }  else {
        print('Failed to update profile. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw ServerException(
          statusCode: response.statusCode,
          message: json.decode(response.body)['message'] ?? 'Server error: ${response.statusCode}',
        );
      }
    } on Exception catch (e) {
      print('Error in updateClientProfile remote data source: $e');
      throw ServerException(message: e.toString());
    }
  }
}