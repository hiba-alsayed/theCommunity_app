import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/errors/exceptions.dart';
import 'package:graduation_project/core/widgets/message_display_widget.dart';
import 'package:graduation_project/features/suggestions/domain/entities/Suggestions.dart';
import '../../../../core/auth_token_provider.dart';
import '../../../../core/base_url.dart';
import '../../../../core/errors/failures.dart';
import '../models/Suggestion_model.dart';
import 'package:http/http.dart' as http;

abstract class SuggestionRemoteDataSource {
  Future<List<SuggestionModel>> getAllSuggestions();
  Future<List<SuggestionModel>> getMySuggestions();
  Future<List<SuggestionModel>> getAllSuggestionsByCategory(int categoryId);
  Future<void> deleteMySuggestion(int suggestionId);
  Future<List<SuggestionModel>> getNearbySuggestions({
    required categoryId,
    required double distance,
  });
  Future<void> submitSuggestion({
    required String title,
    required String description,
    required String requiredAmount,
    required String area,
    required double longitude,
    required double latitude,
    required dynamic categoryId,
    required dynamic numberOfParticipants,
    required dynamic imageUrl,
  });
  Future<Unit> voteOnSuggestion({
    required int suggestionId,
    required int value,
  });
}



class SuggestionRemoteDataSourceImp implements SuggestionRemoteDataSource {
  final http.Client client;
  final AuthTokenProvider tokenProvider;

  SuggestionRemoteDataSourceImp({required this.client, required this.tokenProvider});

  @override
  Future<List<SuggestionModel>> getAllSuggestions({
    int page = 1,
    int perPage = 5,
  }) async {
    try {
      final body = {"type": "مبادرة", "page": page, "per_page": perPage};

      final response = await client.post(
        Uri.parse("$baseUrl/api/client/project/all"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded['data'] == null || decoded['data'] is! List) {
          throw ServerException();
        }
        final List<dynamic> dataList = decoded['data'];
        final suggestions =
            dataList.map((item) {
              if (item['image_url'] == "null") {
                item['image_url'] = null;
              }
              return SuggestionModel.fromJson(item);
            }).toList();
        return suggestions;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> submitSuggestion({
    required String title,
    required String description,
    required String requiredAmount,
    required String area,
    required double longitude,
    required double latitude,
    required dynamic categoryId,
    required dynamic numberOfParticipants,
    required dynamic imageUrl,
  }) async {
    final token = await tokenProvider.getToken();
    final uri = Uri.parse("$baseUrl/api/client/project/create");

    var request =
        http.MultipartRequest('POST', uri)
          ..headers.addAll({
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          })
          ..fields['title'] = title
          ..fields['description'] = description
          ..fields['required_amount'] = requiredAmount
          ..fields['area'] = area
          ..fields['longitude'] = longitude.toString()
          ..fields['latitude'] = latitude.toString()
          ..fields['category_id'] = categoryId.toString()
          ..fields['number_of_participant'] = numberOfParticipants.toString();

    if (imageUrl != null && imageUrl is String && imageUrl.trim().isNotEmpty) {
      try {
        request.files.add(await http.MultipartFile.fromPath('image', imageUrl));
      } catch (e) {
        print("خطأ في تحميل الصورة: $e");
      }
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] != true) {
        print("Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw ServerException();
      }
    } else {
      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw ServerException();
    }
  }

  @override
  Future<List<SuggestionModel>> getAllSuggestionsByCategory(
    int categoryId,
  ) async {
    final body = {"type": "مبادرة"};
    final response = await client.post(
      Uri.parse('$baseUrl/api/client/project/all/$categoryId'),
      headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
      },
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == true) {
        return (jsonResponse['data'] as List)
            .map((item) => SuggestionModel.fromJson(item))
            .toList();
      } else {
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> voteOnSuggestion({
    required int suggestionId,
    required int value,
  }) async {
    final url = Uri.parse('$baseUrl/api/client/project/vote/$suggestionId');
    final token = await tokenProvider.getToken();
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'value': value}),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = jsonDecode(response.body);
      if (decodedJson['status'] == true) {
        return Future.value(unit);
      } else {
        throw DuplicateVoteException('لقد قمت بالتصويت بالفعل!');
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<SuggestionModel>> getNearbySuggestions({
    required categoryId,
    required double distance,
  }) async {
    final url = Uri.parse('$baseUrl/api/client/project/nearby');
    final token = await tokenProvider.getToken();
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'type': 'مبادرة',
        'category_id': categoryId,
        'distance': distance,
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);

      final List<dynamic> suggestionList = jsonBody['data'] ?? [];
      print("Nearby suggestions response: ${response.body}");
      return suggestionList
          .map((item) => SuggestionModel.fromJson(item))
          .toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<SuggestionModel>> getMySuggestions() async {
    final token = await tokenProvider.getToken();
    final response = await client.get(
      Uri.parse('$baseUrl/api/client/project/myProjects'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // print('Response Status: ${response.statusCode}');
    // print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded['data'] == null || decoded['data'] is! List) {
        throw ServerException();
      }
      final List<dynamic> dataList = decoded['data'];
      return dataList
          .map<SuggestionModel>((json) => SuggestionModel.fromJson(json))
          .toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteMySuggestion(int suggestionId) async {
    final url = Uri.parse('$baseUrl/api/client/project/delete/$suggestionId');
    final token = await tokenProvider.getToken();
    final response = await client.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Replace with actual token logic
      },
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    } else {
      throw ServerException();
    }
  }
}
