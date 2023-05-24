import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static late SharedPreferences _sharedPreferences;
  static const String _userID = 'userID';
  static const String _token = 'token';
  static const String _userRole = 'userRole';

  static Future init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences;
  }

  static Future clear() async {
    _sharedPreferences.clear();
  }

  static Future setUserId(String userId) async {
    await _sharedPreferences.setString(_userID, userId);
  }

  static Future setRoleUser(String userRole) async {
    await init();
    _sharedPreferences.setString(_userRole, userRole);
  }

  static Future getUserRole() async {
    await init();
    String userRole = _sharedPreferences.getString(_userRole) ?? "";
    return userRole;
  }

  static Future<String> getUserID() async {
    await init();
    String userType = _sharedPreferences.getString(_userID) ?? "";
    return userType;
  }

  static Future setToken(String token) async {
    await init();
    _sharedPreferences.setString(_token, token);
  }

  static Future getToken() async {
    await init();
    String token = _sharedPreferences.getString(_token) ?? "";
    return token;
  }
}
