import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/auth_token_provider.dart';
import '../models/login_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginModel> login({
    required String email,
    required String password,
    required String deviceToken,

  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl;
  final AuthTokenProvider tokenProvider;

  AuthRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
    required this.tokenProvider,
  });

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
}