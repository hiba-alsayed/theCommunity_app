import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../../../auth_token_provider.dart';
import '../../../../core/base_url.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/complaint_category_model.dart';
import '../models/complaints_model.dart';
import '../models/regions_model.dart';

abstract class ComplaintsRemoteDataSource {
  Future<List<ComplaintCategoryModel>> getComplaintsCategories();
  Future<List<ComplaintModel>> getAllComplaints();
  Future<List<ComplaintModel>> getComplaintsByCategory(int categoryId);
  Future<List<ComplaintModel>> getMyComplaints();
  Future<List<ComplaintModel>> getNearbyComplaints(double distance, int categoryId);
  Future<List<RegionModel>>getAllRegions();
  Future<Unit> submitComplaint(
      double latitude,
      double longitude,
      String area,
      String title,
      String description,
      int complaintCategoryId,
      List<File> complaintImages);
}


class ComplaintsRemoteDataSourceImp implements ComplaintsRemoteDataSource {
  final http.Client client;
  final AuthTokenProvider tokenProvider;

  ComplaintsRemoteDataSourceImp({required this.client, required this.tokenProvider});

  @override
  Future<List<ComplaintCategoryModel>> getComplaintsCategories() async {
    final token = await tokenProvider.getToken();
    final response = await client.get(
      Uri.parse("$baseUrl/api/client/complaint/category/all"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
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
      dataList.map((json) => ComplaintCategoryModel.fromJson(json)).toList();

      return categories;
    } else {
      throw ServerException();
    }

  }

  @override
  Future<List<ComplaintModel>> getAllComplaints() async {
    final token = await tokenProvider.getToken();
    final response = await client.post(
      Uri.parse("$baseUrl/api/client/complaint/all"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded['status'] != true ||
          decoded['data'] == null ||
          decoded['data']['complaints'] == null ||
          decoded['data']['complaints'] is! List) {
        throw ServerException();
      }

      final List<dynamic> complaintsList = decoded['data']['complaints'];
      final complaints = complaintsList.map((json) => ComplaintModel.fromJson(json)).toList();

      return complaints;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ComplaintModel>> getComplaintsByCategory(int categoryId) async {
    final token = await tokenProvider.getToken();
    final response = await client.post(
      Uri.parse("$baseUrl/api/client/complaint/all"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode({
        'category_id': categoryId,
      }),
    );
    print("RESPONSE BODY for Category $categoryId: ${response.body}");
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded['data'] is Map &&
          decoded['data']['complaints'] != null &&
          decoded['data']['complaints'] is List) {

        final List<dynamic> complaintsList = decoded['data']['complaints'];
        final complaints =
        complaintsList.map((json) => ComplaintModel.fromJson(json)).toList();

        return complaints;
      } else {
        return [];
      }

    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ComplaintModel>> getMyComplaints() async{
    final token = await tokenProvider.getToken();
    final response = await client.post(
      Uri.parse("$baseUrl/api/client/complaint/all"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode({
        'userComplaints': '1',
      }),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded['data'] is Map &&
          decoded['data']['complaints'] != null &&
          decoded['data']['complaints'] is List) {
        final List<dynamic> complaintsList = decoded['data']['complaints'];
        final complaints =
        complaintsList.map((json) => ComplaintModel.fromJson(json)).toList();
        return complaints;
      } else {
        return [];
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ComplaintModel>> getNearbyComplaints(double distance, int categoryId) async{
    final token = await tokenProvider.getToken();
    final response = await client.post(
      Uri.parse("$baseUrl/api/client/complaint/all"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode({
        'distance': distance,
        'category_id': categoryId,
      }),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded['status'] == true &&
          decoded['data'] is Map &&
          decoded['data']['complaints'] != null &&
          decoded['data']['complaints'] is List) {

        final List<dynamic> complaintsList = decoded['data']['complaints'];
        final complaints =
        complaintsList.map((json) => ComplaintModel.fromJson(json)).toList();

        return complaints;
      } else {
        return [];
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<RegionModel>> getAllRegions() async{
    final token = await tokenProvider.getToken();
    final response = await client.get(
      Uri.parse("$baseUrl/api/client/complaint/allRegions"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded['status'] == true &&
          decoded['data'] != null &&
          decoded['data'] is List) {

        final List<dynamic> dataList = decoded['data'];
        final regions = dataList.map((json) => RegionModel.fromJson(json)).toList();

        return regions;
      } else {
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> submitComplaint(double latitude, double longitude, String area, String title, String description, int complaintCategoryId, List<File> complaintImages) async {
    final token = await tokenProvider.getToken();
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/api/client/complaint/create"),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    request.fields['latitude'] = latitude.toString();
    request.fields['longitude'] = longitude.toString();
    request.fields['area'] = area;
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['complaint_category_id'] = complaintCategoryId.toString();

    for (var imageFile in complaintImages) {
      request.files.add(
        await http.MultipartFile.fromPath(
        'complaintImages[]',
        imageFile.path,
      ),
    );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 201 || response.statusCode == 200) {
    final decoded = json.decode(response.body);
    if(decoded['status'] == true) {
    return unit;
    } else {
    throw ServerException();
    }
    } else {

    throw ServerException();
    }
  }

}