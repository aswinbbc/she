import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  Constants._();
  static const double padding = 20;

  static const double avatarRadius = 45;
  // static const BASE_URL = "https://hosted_url.com/";
  static const BASE_URL = "http://192.168.135.116/she_secure/admin/api/";

  static Future<String> get UserId async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id') ?? "0";
  }

  static Future logout() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove("user_id");
  }
}
