import 'package:shared_preferences/shared_preferences.dart';

class LogStatus {
  static String token = "";
  static bool admin = false;

  void setToken(String token, bool admin) async {
    final shPref = await SharedPreferences.getInstance();
    shPref.setString("token", token);
    shPref.setBool("admin", admin);
  }

  void removeToken() async {
    final shPref = await SharedPreferences.getInstance();
    shPref.remove("token");
    shPref.remove("admin");
  }

  Future<Map> getToken() async {
    final shPref = await SharedPreferences.getInstance();
    String token = shPref.getString("token") ?? "";
    bool? admin = shPref.getBool("admin");
    return {"token": token, "admin": admin};
  }
}
