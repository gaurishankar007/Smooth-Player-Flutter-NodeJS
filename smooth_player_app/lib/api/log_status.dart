import 'package:shared_preferences/shared_preferences.dart';

class LogStatus {
  static String token = "";

  void setToken(String token) async {
    final shPref = await SharedPreferences.getInstance();
    shPref.setString("token", token);
  }

  void removeToken() async {
    final shPref = await SharedPreferences.getInstance();
    shPref.remove("token");
  }

  Future<String> getToken() async {
    final shPref = await SharedPreferences.getInstance();
    String token = shPref.getString("token") ?? "";
    return token;
  }
}
