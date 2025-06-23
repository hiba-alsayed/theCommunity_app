import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_service.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<String?> getFCMToken() async {
    try {
      final String? token = await _firebaseMessaging.getToken();
      print('🔐 FCM Token Fetched for Login: $token');
      return token;
    } catch (e) {
      print('🔥 An error occurred while fetching FCM token: $e');
      return null;
    }
  }
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    final fCMToken = await _firebaseMessaging.getToken();
    print('🔐TOKEN: $fCMToken');

    // Foreground message
    FirebaseMessaging.onMessage.listen((message) {
      print('📥 Foreground Notification');
      if (message.notification != null) {
        NotificationService.showNotification(
          title: message.notification!.title ?? '',
          body: message.notification!.body ?? '',
          payload: message.data.toString(),
        );
      }
    });

    // When app is opened from background by tapping notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('🚪 Notification caused app to open');
      // You can navigate to a specific screen here
    });

    // Background
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('📩 Background Notification Received');
  print('title : ${message.notification?.title}');
  print('body : ${message.notification?.body}');
  print('payload : ${message.data}');
}