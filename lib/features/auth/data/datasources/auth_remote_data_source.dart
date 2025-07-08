import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../core/auth_token_provider.dart';
import '../../../../core/base_url.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/login_model.dart';
import '../models/signup_model.dart';

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
  Future<SignUpModel> confirmRegistration({
    required String email,
    required String code,
  });
  Future<Unit> resendCode({required String email});
}

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
      // ✅ Save token dynamically
      await tokenProvider.setToken(loginModel.token);
      return loginModel;
    } else {
      throw Exception(jsonData['message'] ?? 'Login failed');
    }
  }

  //signup
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
    final signUpModel = SignUpModel(
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

    final response = await client.post(
      Uri.parse('$baseUrl/api/client/initiate_registration'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(signUpModel.toJson()),
    );

    Map<String, dynamic> jsonData;
    try {
      // *** THIS IS THE CRUCIAL PART THAT WAS MISSING ***
      jsonData = json.decode(response.body);
    } on FormatException catch (e) {
      print('Error: Backend returned non-JSON response for signUp: ${response.body}');
      throw ServerException(message: 'Invalid server response format. Please try again.');
    } catch (e) {
      print('Unexpected error decoding JSON for signUp: $e');
      throw ServerException(message: 'Failed to process server response.');
    }
    if (response.statusCode == 200 && (jsonData['status'] == true || jsonData['success'] == true)) {
       return SignUpModel.fromJson(jsonData['data']);
    } else {

      throw ServerException(message: jsonData['message'] ?? 'Sign Up failed');
    }
  }


  @override
  Future<SignUpModel> confirmRegistration({required String email, required String code}) async{
    final response = await client.post(
      Uri.parse('$baseUrl/api/client/confirm_registration'),
      body: {
        'email': email,
        'code': code,
      },
    );
    final jsonData = json.decode(response.body);
    if (response.statusCode == 200 && jsonData['status'] == true) {
      final String? token = jsonData['data']['token'];
      if (token != null) {
        await tokenProvider.setToken(token);
      } else {
        throw ServerException(message: 'Registration confirmed but no token received.');
      }
      return SignUpModel.fromJson(jsonData['data']['user']);
    } else {
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
}}