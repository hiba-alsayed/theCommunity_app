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
  // @override
  // Future<SignUpModel> signUp({
  //   required String email,
  //   required String password,
  //   required String passwordConfirmation,
  //   required String name,
  //   required int age,
  //   required String phone,
  //   required String gender,
  //   required String bio,
  //   String? deviceToken,
  //   required List<String> skills,
  //   required List<String> volunteerFields,
  //   required double longitude,
  //   required double latitude,
  //   required String area,
  //   String? image,
  // }) async {
  //   final signUpModel = SignUpModel(
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
  //   final response = await client.post(
  //     Uri.parse('$baseUrl/api/client/initiate_registration'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode(signUpModel.toJson()),
  //   );
  //
  //   Map<String, dynamic> jsonData;
  //   try {
  //     // *** THIS IS THE CRUCIAL PART THAT WAS MISSING ***
  //     jsonData = json.decode(response.body);
  //   } on FormatException catch (e) {
  //     print('Error: Backend returned non-JSON response for signUp: ${response.body}');
  //     throw ServerException(message: 'Invalid server response format. Please try again.');
  //   } catch (e) {
  //     print('Unexpected error decoding JSON for signUp: $e');
  //     throw ServerException(message: 'Failed to process server response.');
  //   }
  //   if (response.statusCode == 200 && (jsonData['status'] == true || jsonData['success'] == true)) {
  //      return SignUpModel.fromJson(jsonData['data']);
  //   } else {
  //
  //     throw ServerException(message: jsonData['message'] ?? 'Sign Up failed');
  //   }
  // }

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
    String? image, // This is now the file path
  }) async {
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
    request.fields['skills'] = json.encode(skills);
    request.fields['volunteer_fields'] = json.encode(volunteerFields);
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

    print('--- Flutter SignUp Request Details (Multipart) ---');
    print('Method: ${request.method}');
    print('URL: ${request.url}');
    print('Headers: ${request.headers}');
    print('Fields: ${request.fields}');
    print('Files: ${request.files.map((f) => f.filename ?? f.field).toList()}');
    print('------------------------------------');

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('\n--- Flutter SignUp Response Details ---');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Body (Raw): ${response.body}');
      print('------------------------------------');

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
        // --- THE FIX IS HERE ---
        // Backend returned a String in 'data', not a Map.
        // So, we construct SignUpModel from the original input parameters
        // because the backend confirmed success but didn't return a user object here.
        return SignUpModel(
          email: email,
          password: password, // You might not need to keep this after registration, consider if it's safe/needed
          passwordConfirmation: passwordConfirmation, // Same as above
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
        // --- END OF FIX ---
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

  // @override
  // Future<SignUpModel> confirmRegistration({required String email, required String code}) async{
  //   final response = await client.post(
  //     Uri.parse('$baseUrl/api/client/confirm_registration'),
  //     body: {
  //       'email': email,
  //       'code': code,
  //     },
  //   );
  //   final jsonData = json.decode(response.body);
  //   if (response.statusCode == 200 && jsonData['status'] == true) {
  //     final String? token = jsonData['data']['token'];
  //     if (token != null) {
  //       await tokenProvider.setToken(token);
  //     } else {
  //       throw ServerException(message: 'Registration confirmed but no token received.');
  //     }
  //     return SignUpModel.fromJson(jsonData['data']['user']);
  //   } else {
  //     throw ServerException(message: jsonData['message'] ?? 'Confirm registration failed');
  //   }
  // }
  @override
  Future<SignUpModel> confirmRegistration({required String email, required String code}) async {
    final String fullUrl = '$baseUrl/api/client/confirm_registration';

    // The 'body' is a Map<String, String>, which http.post will encode as 'application/x-www-form-urlencoded' by default.
    // If your backend expects JSON, you MUST use json.encode(body) and set 'Content-Type': 'application/json' header.
    final Map<String, String> requestBody = {
      'email': email,
      'code': code,
    };

    // --- LOGGING SECTION (Request) ---
    print('--- Flutter ConfirmRegistration Request Details ---');
    print('Method: POST');
    print('URL: $fullUrl');
    // If your backend expects JSON, you need to send headers: {'Content-Type': 'application/json'}
    // and body: json.encode(requestBody).
    // For now, assuming default form-urlencoded if no headers specified.
    print('Body: $requestBody'); // This will print the Map, not the encoded string directly
    print('------------------------------------');
    // --- END LOGGING SECTION ---

    http.Response response;
    try {
      response = await client.post(
        Uri.parse(fullUrl),
        // --- IMPORTANT: Check Backend Expectation ---
        // If your backend expects JSON for confirm_registration, UNCOMMENT the headers and body line below:
        // headers: {'Content-Type': 'application/json'},
        // body: json.encode(requestBody), // Use json.encode for JSON body
        //
        // Otherwise, if it expects form-urlencoded (default for Map body), keep it as is:
        body: requestBody, // This will be sent as application/x-www-form-urlencoded
      );
    } on http.ClientException catch (e) {
      print('HTTP Client Error during confirmRegistration: $e');
      throw ServerException(message: 'Network error. Please check your internet connection or the server URL.');
    } catch (e) {
      print('General Error during confirmRegistration (before response): $e');
      throw ServerException(message: 'An unexpected error occurred before receiving server response: $e');
    }

    // --- LOGGING SECTION (Response) ---
    print('\n--- Flutter ConfirmRegistration Response Details ---');
    print('Status Code: ${response.statusCode}');
    print('Headers: ${response.headers}');
    print('Body (Raw): ${response.body}');
    print('------------------------------------');
    // --- END LOGGING SECTION ---

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
      final String? token = jsonData['data']['token'];
      if (token != null) {
        await tokenProvider.setToken(token);
      } else {
        throw ServerException(message: 'Registration confirmed but no token received in data.');
      }
      if (jsonData['data'] is Map<String, dynamic> && jsonData['data'].containsKey('user') && jsonData['data']['user'] is Map<String, dynamic>) {
        return SignUpModel.fromJson(jsonData['data']['user']);
      } else {
        throw ServerException(message: 'Confirmation success but user data not found or malformed.');
      }
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
}}