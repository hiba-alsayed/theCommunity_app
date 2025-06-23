import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../auth_token_provider.dart';
import '../../../../core/base_url.dart';
import '../../../../core/errors/exceptions.dart';
import '../model/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final http.Client client;
  final AuthTokenProvider tokenProvider;

  NotificationRemoteDataSourceImpl({
    required this.client,
    required this.tokenProvider,
  });

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final url = Uri.parse('$baseUrl/api/notifications');
    final token = await tokenProvider.getToken();
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> decodedJson = json.decode(response.body);

        final List<dynamic> notificationListJson = decodedJson['data'];
        return notificationListJson
            .map((jsonItem) => NotificationModel.fromJson(jsonItem))
            .toList();
      } catch (e) {
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }


}
