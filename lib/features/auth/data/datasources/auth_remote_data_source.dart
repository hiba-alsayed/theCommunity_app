import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../core/auth_token_provider.dart';
import '../../../../core/base_url.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/login_model.dart';
import '../models/signup_model.dart';
import '../models/signup_model_response.dart';

abstract class AuthRemoteDataSource {
  Future<LoginModel> login({
    required String email,
    required String password,
    required String deviceToken,

  });
  Future<SignUpModel> signUp({
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
  });
  Future<SignUpResponseModel> confirmRegistration({ // MODIFIED
    required String email,
    required String code,
  });
  Future<Unit> resendCode({required String email});
  Future<Unit> resetPassword({required String email});
  Future<UserModel> confirmResetPassword({
    required String email,
    required String code,
    required String newPassword,
    required String newPasswordConfirmation,
  });
  Future<Unit> logout();
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

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final AuthTokenProvider tokenProvider;
  AuthRemoteDataSourceImpl({
    required this.client,
    required this.tokenProvider,
  });

  //login
  @override
  Future<LoginModel> login({
    required String email,
    required String password,
    required String deviceToken,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api/client/login'),
      body: {
        'email': email,
        'password': password,
        'device_token':deviceToken,
      },
    );

    final jsonData = json.decode(response.body);

    if (response.statusCode == 200 && jsonData['status'] == true) {
      final loginModel = LoginModel.fromJson(jsonData);
      await tokenProvider.setToken(loginModel.token);
      return loginModel;
    } else {
      throw Exception(jsonData['message'] ?? 'Login failed');
    }
  }

  @override
  Future<SignUpModel> signUp({
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

    final String fullUrl = '$baseUrl/api/client/initiate_registration';

    var request = http.MultipartRequest('POST', Uri.parse(fullUrl));

    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['password_confirmation'] = passwordConfirmation;
    request.fields['name'] = name;
    request.fields['age'] = age.toString();
    request.fields['phone'] = phone;
    request.fields['gender'] = gender;
    request.fields['bio'] = bio;
    if (deviceToken != null) {
      request.fields['device_token'] = deviceToken;
    }
    request.fields['skills'] = json.encode(skillsIds);
    request.fields['volunteer_fields'] = json.encode(volunteerFieldsIds);
    request.fields['longitude'] = longitude.toString();
    request.fields['latitude'] = latitude.toString();
    request.fields['area'] = area;

    if (image != null && image.isNotEmpty) {
      try {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          image,
        ));
      } catch (e) {
        print('Error adding image file to request: $e');
        throw Exception('Failed to attach image file: $e');
      }
    }

    // print('--- Flutter SignUp Request Details (Multipart) ---');
    // print('Method: ${request.method}');
    // print('URL: ${request.url}');
    // print('Headers: ${request.headers}');
    // print('Fields: ${request.fields}');
    // print('Files: ${request.files.map((f) => f.filename ?? f.field).toList()}');

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      // print('\n--- Flutter SignUp Response Details ---');
      // print('Status Code: ${response.statusCode}');
      // print('Headers: ${response.headers}');
      // print('Body (Raw): ${response.body}');

      Map<String, dynamic> jsonData;
      try {
        jsonData = json.decode(response.body);
      } on FormatException catch (e) {
        print('Error: Backend returned non-JSON response for signUp: ${response.body}');
        throw Exception('Invalid server response format. Please try again. Raw response: ${response.body}');
      } catch (e) {
        print('Unexpected error decoding JSON for signUp: $e');
        throw Exception('Failed to process server response.');
      }
      if (response.statusCode == 200 && (jsonData['status'] == true || jsonData['success'] == true)) {

        return SignUpModel(
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
      } else {
        print('Sign Up failed with status code ${response.statusCode}. Message: ${jsonData['message']}');
        throw Exception(jsonData['message'] ?? 'Sign Up failed');
      }
    } on http.ClientException catch (e) {
      print('HTTP Client Error during signUp: $e');
      throw Exception('Network error. Please check your internet connection or the server URL.');
    } catch (e) {
      print('General Error during signUp: $e');
      throw Exception('An unexpected error occurred during sign up: $e');
    }
  }


  @override

  Future<SignUpResponseModel> confirmRegistration({required String email, required String code}) async { // MODIFIED
    final String fullUrl = '$baseUrl/api/client/confirm_registration';

    final Map<String, String> requestBody = {
      'email': email,
      'code': code,
    };

    // print('--- Flutter ConfirmRegistration Request Details ---');
    // print('Method: POST');
    // print('URL: $fullUrl');
    // print('Body: $requestBody');

    http.Response response;
    try {
      response = await client.post(
        Uri.parse(fullUrl),
        body: requestBody,

      );
    } on http.ClientException catch (e) {
      print('HTTP Client Error during confirmRegistration: $e');
      throw ServerException(message: 'Network error. Please check your internet connection or the server URL.');
    } catch (e) {
      print('General Error during confirmRegistration (before response): $e');
      throw ServerException(message: 'An unexpected error occurred before receiving server response: $e');
    }


    // print('\n--- Flutter ConfirmRegistration Response Details ---');
    // print('Status Code: ${response.statusCode}');
    // print('Headers: ${response.headers}');
    // print('Body (Raw): ${response.body}');

    Map<String, dynamic> jsonData;
    try {
      jsonData = json.decode(response.body);
    } on FormatException catch (e) {
      print('Error: Backend returned non-JSON response for confirmRegistration: ${response.body}');
      throw ServerException(message: 'Invalid server response format for confirmation. Please try again. Raw response: ${response.body}');
    } catch (e) {
      print('Unexpected error decoding JSON for confirmRegistration: $e');
      throw ServerException(message: 'Failed to process server confirmation response.');
    }
    if (response.statusCode == 200 && jsonData['status'] == true) {
      final SignUpResponseModel signUpResponse = SignUpResponseModel.fromJson(jsonData);
      await tokenProvider.setToken(signUpResponse.token);
      return signUpResponse;
    } else {
      print('Confirm registration failed with status code ${response.statusCode}. Message: ${jsonData['message']}');
      throw ServerException(message: jsonData['message'] ?? 'Confirm registration failed');
    }
  }


  @override
  Future<Unit> resendCode({required String email}) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api/client/resend_code'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );
    if (response.statusCode == 200 && (json.decode(response.body)['status'] == true || json.decode(response.body)['success'] == true)) {

      return unit;
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      final errorMessage = json.decode(response.body)['message'] ?? 'Invalid input for resend code.';
      throw ServerException(message: errorMessage);
    } else {
      throw ServerException(message: 'Failed to resend code: ${response.statusCode}');
    }
}

  @override
  Future<Unit> resetPassword({required String email}) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/api/client/reset_password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      final jsonData = json.decode(response.body);

      if (response.statusCode == 200 && jsonData['status'] == true) {
        return unit;
      } else {
        throw ServerException(message: jsonData['message'] ?? 'Failed to reset password');
      }
    }  on FormatException {
      throw ServerException(message: 'Invalid response format from server.');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
}

  @override
  Future<UserModel> confirmResetPassword({required String email, required String code, required String newPassword, required String newPasswordConfirmation}) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/api/client/confirm_reset_password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'reset_code': code,
          'new_password': newPassword,
          'new_password_confirmation': newPasswordConfirmation,
        }),
      );

      final jsonData = json.decode(response.body);

      if (response.statusCode == 200 && jsonData['status'] == true) {
        return UserModel.fromJson(jsonData['data'] as Map<String, dynamic>);
      } else {
        throw ServerException(message: jsonData['message'] ?? 'Failed to confirm password reset');
      }
    } on FormatException {
      throw ServerException(message: 'Invalid response format from server.');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Unit> logout() async {
    try {
      final String? token = await tokenProvider.getToken();
      if (token == null) {
        return unit;
      }
      final response = await client.post(
        Uri.parse('$baseUrl/api/client/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final jsonData = json.decode(response.body);
      if (response.statusCode == 200 && jsonData['status'] == true) {
        await tokenProvider.clearToken();
        return unit;
      } else if (response.statusCode == 401) {
        await tokenProvider.clearToken();
        throw ServerException(message: jsonData['message'] ?? 'Unauthorized: Token invalid or expired. Please log in again.');
      } else {
        throw ServerException(message: jsonData['message'] ?? 'Logout failed');
      }
    } on FormatException {
      throw ServerException(message: 'Invalid response format from server during logout.');
    } on http.ClientException catch (e) {
      throw ServerException(message: 'Network error during logout: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'An unexpected error occurred during logout: ${e.toString()}');
    }
  }}