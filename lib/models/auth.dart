import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  //static const _apikey = "AIzaSyByOwBb37ckW9r456QxJBqR9mHPLpNpYAY";

  Future<void> signIn(String email, String password) async {
    try {
      UserCredential res = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      _userId = res.user.uid;
      IdTokenResult tokenResult = await res.user.getIdTokenResult();
      _token = tokenResult.token;
      _expiryDate = tokenResult.expirationTime;
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      if (prefs != null) {
        final userData = json.encode(
          {
            "token": _token,
            "userId": _userId,
            "exDate": _expiryDate.toIso8601String(),
          },
        );
        prefs.setString("userData", userData);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      UserCredential res = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      if (res != null) {
        signIn(email, password);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString("userData")) as Map<String, dynamic>;
    final exDate = DateTime.parse(extractedUserData["exDate"]);
    if (exDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData["token"];
    _userId = extractedUserData["userId"];
    _expiryDate = DateTime.tryParse(extractedUserData["exDate"]);
    notifyListeners();
    _autoLogout();
    return true;
  }

  void logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      print(_authTimer.toString());
      _token = null;
      _userId = null;
      _expiryDate = null;
      if (_authTimer != null) {
        _authTimer.cancel();
      }
      _authTimer = null;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      if (prefs != null) {
        await prefs.clear();
      }
    } catch (e) {
      print(e);
    }
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
