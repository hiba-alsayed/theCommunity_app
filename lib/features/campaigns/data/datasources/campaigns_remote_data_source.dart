import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../core/auth_token_provider.dart';
import '../../../../core/base_url.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../models/campaigns_model.dart';
import '../models/category_model.dart';

abstract class CampaignRemoteDataSource {
  Future<List<CampaignModel>> getAllCampaigns();
  Future<List<CategoryModel>> getCategories();
  Future<List<CampaignModel>> getAllCampaignsByCategory(int categoryId);
  Future<void> joinCampaign(int campaignId);
  Future<List<CampaignModel>> getMyCampaigns();
  Future<List<CampaignModel>> getNearbyCampaigns(
    int categoryId,
    double distance,
  );
  Future<Either<Failure, Unit>> rateCompletedCampaign(
    int campaignId,
    int rating,
    String comment,
  );
  Future<List<CampaignModel>> getRecommendedCampaigns();
  Future<List<CampaignModel>> getPromotedCampaigns();
}

class CampaignRemoteDataSourceImp implements CampaignRemoteDataSource {
  final http.Client client;
  final AuthTokenProvider tokenProvider;

  CampaignRemoteDataSourceImp({
    required this.client,
    required this.tokenProvider,
  });

  @override
  Future<List<CampaignModel>> getAllCampaigns({
    int page = 1,
    int perPage = 5,
  }) async {
    try {
      final body = {"type": "حملة رسمية", "page": page, "per_page": perPage};

      final response = await client.post(
        Uri.parse("$baseUrl/api/client/project/all"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: json.encode(body),
      );
      // print("Response status: ${response.statusCode}");
      // print("Response body: ${response.body}");
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
              return CampaignModel.fromJson(item);
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
  Future<List<CategoryModel>> getCategories() async {
    final response = await client.get(
      Uri.parse("$baseUrl/api/categories/"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded['status'] != true ||
          decoded['data'] == null ||
          decoded['data'] is! List) {
        throw ServerException();
      }

      final List<dynamic> dataList = decoded['data'];
      final categories =
          dataList.map((json) => CategoryModel.fromJson(json)).toList();

      return categories;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<CampaignModel>> getAllCampaignsByCategory(int categoryId) async {
    try {
      final body = {"type": "حملة رسمية"};

      final response = await client.post(
        Uri.parse("$baseUrl/api/client/project/all/$categoryId"),
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
        final campaigns =
            dataList.map((item) {
              if (item['image_url'] == "null") {
                item['image_url'] = null;
              }
              return CampaignModel.fromJson(item);
            }).toList();
        return campaigns;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> joinCampaign(int campaignId) async {
    final token = await tokenProvider.getToken();
    final response = await client.get(
      Uri.parse("$baseUrl/api/project/join/$campaignId"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }
    final decoded = json.decode(response.body);
    if (decoded['status'] != true) {
      throw ServerException();
    }
  }

  @override
  Future<List<CampaignModel>> getMyCampaigns() async {
    try {
      final token = await tokenProvider.getToken();
      final response = await client.get(
        Uri.parse("$baseUrl/api/project/myJoined"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['data'] == null || decoded['data'] is! List) {
          throw ServerException();
        }

        final List<dynamic> dataList = decoded['data'];
        final myCampaigns =
            dataList.map((item) {
              if (item['image_url'] == "null") {
                item['image_url'] = null;
              }
              return CampaignModel.fromJson(item);
            }).toList();
        return myCampaigns;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<CampaignModel>> getNearbyCampaigns(
      int categoryId,
      double distance,
      ) async {
    try {
      final token = await tokenProvider.getToken();
      final response = await client.post(
        Uri.parse("$baseUrl/api/client/project/nearby"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode({"category_id": categoryId, "distance": distance}),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['data'] == null ||
            decoded['data'] is! List ||
            (decoded['data'] as List).isEmpty) {
          print('API returned no nearby campaigns. Returning empty list.');
          return [];
        }

        final List<dynamic> dataList = decoded['data'];
        final nearbyCampaigns = dataList.map((item) {
          if (item['image_url'] == "null") {
            item['image_url'] = null;
          }
          return CampaignModel.fromJson(item);
        }).toList();

        return nearbyCampaigns;
      } else {
        print('Server responded with status code: ${response.statusCode}. Body: ${response.body}');
        throw ServerException(message: 'Server Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching nearby campaigns: $e');
      if (e is FormatException) {
        throw ServerException(message: 'Invalid response format from server.');
      }
      throw ServerException(message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<Either<Failure, Unit>> rateCompletedCampaign(
    int campaignId,
    int rating,
    String comment,
  ) async {
    try {
      final token = await tokenProvider.getToken();
      final response = await client.post(
        Uri.parse('$baseUrl/api/ratings'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode({
          "project_id": campaignId,
          "rating": rating,
          "comment": comment,
        }),
      );

      final decoded = json.decode(response.body);

      if (decoded['status'] == false &&
          decoded['message'] == "لقد قمت بتقييم هذا المشروع مسبقًا.") {
        return Left(AlreadyRatedFailure());
      }
      if (decoded['status'] == false) {
        return Left(ServerFailure());
      }
      if (response.statusCode != 200) {
        return Left(ServerFailure());
      }

      return Right(unit);
    } catch (_) {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<List<CampaignModel>> getRecommendedCampaigns() async{
      try {
        final token = await tokenProvider.getToken();
        final body = {"type": "حملة رسمية"};

        final response = await client.post(
          Uri.parse("$baseUrl/api/client/project/recommends"),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
          body: json.encode(body),
        );

        if (response.statusCode == 200) {
          final decoded = json.decode(response.body);

          if (decoded['data'] == null || decoded['data'] is! List) {
            throw ServerException();
          }
          final List<dynamic> dataList = decoded['data'];
          final recommendedCampaigns = dataList.map((item) {
            if (item['image_url'] == "null") {
              item['image_url'] = null;
            }
            return CampaignModel.fromJson(item);
          }).toList();

          return recommendedCampaigns;
        } else {
          throw ServerException();
        }
      } catch (e) {
        throw ServerException();
      }
}

  @override
  Future<List<CampaignModel>> getPromotedCampaigns() async{
    final url = Uri.parse("$baseUrl/api/client/project/promoted");

    try {
      final response = await client.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        if (decodedResponse['status'] != true ||
            decodedResponse['data'] == null ||
            decodedResponse['data'] is! List) {
          throw ServerException();
        }

        final List<dynamic> dataList = decodedResponse['data'];
        final promotedCampaigns = dataList.map((item) {
          if (item['image_url'] == "null") {
            item['image_url'] = null;
          }
          return CampaignModel.fromJson(item);
        }).toList();

        return promotedCampaigns;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }}
