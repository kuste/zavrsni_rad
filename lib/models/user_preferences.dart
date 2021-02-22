import 'dart:convert';

import 'package:dungeon_master/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs != null) {
      final userData = json.encode(
        {
          "token": user.token,
          "userId": user.userId,
          'role': user.role,
          "exDate": user.expiryDate.toIso8601String(),
        },
      );
      prefs.setString("userData", userData);
      return true;
    }
    return false;
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return new User();
    }
    final extractedUserData = json.decode(prefs.getString("userData")) as Map<String, dynamic>;
    final exDate = DateTime.parse(extractedUserData["exDate"]);

    User user = User(
      expiryDate: exDate,
      userId: extractedUserData["userId"],
      role: extractedUserData["role"],
      token: extractedUserData["token"],
    );
    return user;
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    return token;
  }
}
