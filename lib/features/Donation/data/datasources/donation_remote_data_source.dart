import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../auth_token_provider.dart';
import '../../../../core/base_url.dart';
import '../../../../core/errors/exceptions.dart';
import '../model/donation_model.dart';

abstract class DonationRemoteDataSource {
  Future<DonationModel> makeDonation(
     int projectId,
     double amount,
  );
}
class DonationRemoteDataSourceImp implements DonationRemoteDataSource{
  final http.Client client;
  final AuthTokenProvider tokenProvider;

  DonationRemoteDataSourceImp({required this.client, required this.tokenProvider});

  @override
  Future<DonationModel> makeDonation(
     int projectId,
     double amount,
  ) async {
    final token = await tokenProvider.getToken();
    if (token == null) {
      throw ServerException();
    }

    final response = await client.post(
      Uri.parse('$baseUrl/api/Donation/donate'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },

      body: json.encode({
        'project_id': projectId,
        'amount': amount,
      }),
    );
    final jsonData = json.decode(response.body);
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    if (response.statusCode == 200 && jsonData['status'] == true) {
      return DonationModel.fromJson(jsonData);
    } else if (response.statusCode == 422) {
      throw ValidationException(jsonData['message'] ?? 'Invalid data provided.');
    } else {
      throw ServerException();
    }
  }
}