import 'package:shared_preferences/shared_preferences.dart';

class AuthTokenProvider {
  final SharedPreferences prefs;
  AuthTokenProvider(this.prefs);

  Future<void> setToken(String token) async {
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    return prefs.getString('token');
  }

  Future<void> clearToken() async {
    await prefs.remove('token');
  }
}
