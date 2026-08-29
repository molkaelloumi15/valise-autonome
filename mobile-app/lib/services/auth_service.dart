import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<bool> login(String email, String password) async {
    await Future.delayed(Duration(seconds: 2));
    if (email == "user@example.com" && password == "123456") {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isLoggedIn", true);
      return true;
    }
    return false;
  }

  static Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLoggedIn") ?? false;
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("isLoggedIn");
  }
}
