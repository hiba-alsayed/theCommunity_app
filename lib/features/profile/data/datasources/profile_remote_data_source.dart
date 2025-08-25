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
const Map<String, int> skillNameToId = {
  'تمريض': 1,
  'طبخ': 2,
  'جمع تبرعات': 3,
  'تصوير': 4,
  'مهنية': 5,
};
const Map<String, int> volunteerFieldNameId = {
  'ترميم بيوت': 1,
  'توزيع مساعدات': 2,
  'تنظيم فعالية': 3,
  'إغاثة الكوارث': 4,
  'مساعدات الطريق': 5,
  'تنظيف البيئة': 6,
};
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
        // print('Failed to load profile. Status code: ${response.statusCode}');
        // print('Response body: ${response.body}');
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
        // print('Failed to load profile for user $userId. Status code: ${response.statusCode}');
        // print('Response body: ${response.body}');
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
    final List<int> skillsIds = skills
        .map((skill) => skillNameToId[skill])
        .where((id) => id != null)
        .cast<int>()
        .toList();

    final List<int> volunteerFieldsIds = volunteerFields
        .map((field) => volunteerFieldNameId[field])
        .where((id) => id != null)
        .cast<int>()
        .toList();

    final token = await tokenProvider.getToken();
    final Map<String, dynamic> requestBody = {
      'age': age,
      'phone': phone,
      'gender': gender,
      'bio': bio,
      'device_token': deviceToken,
      'volunteer_fields': json.encode(volunteerFieldsIds),
      'longitude': longitude,
      'latitude': latitude,
      'area': area,
      'skills': json.encode(skillsIds),
    };

    try {
      final response = await client.post(
        Uri.parse("$baseUrl/api/client/profile/update"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['status'] == true) {
          return responseBody['message'] as String;
        } else {
          final errorMessage = responseBody['message'] is Map
              ? (responseBody['message']['details'] ?? responseBody['message']['0'] ?? 'Failed to update profile.')
              : responseBody['message'] ?? 'Failed to update profile.';
          throw ServerException(message: errorMessage);
        }
      } else {
        // print('Failed to update profile. Status code: ${response.statusCode}');
        // print('Response body: ${response.body}');
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['message'] is Map
            ? (errorBody['message']['details'] ?? errorBody['message']['0'] ?? 'Server error: ${response.statusCode}')
            : errorBody['message'] ?? 'Server error: ${response.statusCode}';
        throw ServerException(
          statusCode: response.statusCode,
          message: errorMessage,
        );
      }
    } on Exception catch (e) {
      print('Error in updateClientProfile remote data source: $e');
      throw ServerException(message: e.toString());
    }
  }
}

