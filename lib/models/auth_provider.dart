import 'package:dungeon_master/models/user.dart' as UserModel;
import 'package:dungeon_master/models/user_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum Status { NotLoggedIn, NotRegistered, LoggedIn, Registered, Authenticating, Registering, LoggedOut }

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    var result;
    _loggedInStatus = Status.Authenticating;
    notifyListeners();
    try {
      UserCredential res = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      var userId = res.user.uid;
      IdTokenResult tokenResult = await res.user.getIdTokenResult();
      var token = tokenResult.token;
      var expDate = tokenResult.expirationTime;
      var userEmail = res.user.email;
      var isAdmin = false;
      if (userEmail == 'admin@admin.com') {
        isAdmin = true;
      }
      UserModel.User authUser = UserModel.User(
        userId: userId,
        token: token,
        expiryDate: expDate,
        isAdmin: isAdmin,
      );
      UserPreferences().saveUser(authUser);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();
      result = {'status': true, 'message': 'Successful', 'user': authUser};
    } catch (e) {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {'status': false, 'message': e.toString()};
    }
    return result;
  }

  Future<Map<String, dynamic>> signUp(String email, String password) async {
    var result;
    _registeredInStatus = Status.Registering;
    notifyListeners();
    try {
      UserCredential res = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      var userId = res.user.uid;
      IdTokenResult tokenResult = await res.user.getIdTokenResult();
      var token = tokenResult.token;
      var expDate = tokenResult.expirationTime;
      var userEmail = res.user.email;
      var isAdmin = false;
      if (userEmail == 'admin@admin.com') {
        isAdmin = true;
      }
      UserModel.User authUser = UserModel.User(
        userId: userId,
        token: token,
        expiryDate: expDate,
        isAdmin: isAdmin,
      );
      _registeredInStatus = Status.Registered;
      UserPreferences().saveUser(authUser);
      result = {'status': true, 'message': 'Successfully registered', 'data': authUser};
    } catch (e) {
      result = {'status': false, 'message': 'Registration failed', 'data': e.toString()};
    }
    return result;
  }

  void logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      UserPreferences().removeUser();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
