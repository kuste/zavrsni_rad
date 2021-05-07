// import 'dart:async';
// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/widgets.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Auth with ChangeNotifier {
//   String _token;
//   DateTime _expiryDate;
//   String _userId;
//   Timer _authTimer;
//   bool _isAdmin = false;

//   bool get isAuth {
//     return token != null;
//   }

//   bool get isAdmin => _isAdmin;

//   String get token {
//     if (_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null) {
//       return _token;
//     }
//     return null;
//   }

//   String get userId {
//     return _userId;
//   }

//   //static const _apikey = "AIzaSyByOwBb37ckW9r456QxJBqR9mHPLpNpYAY";
//   Future<bool> checkIfAdmin() async {
//     FirebaseFirestore _firestore = FirebaseFirestore.instance;
//     var res = await _firestore.collection('eventsData').doc(userId).get();
//     return res.exists ? res['isAdmin'] : false;
//   }

//   Future<void> signIn(String email, String password) async {
//     _isAdmin = false;
//     try {
//       UserCredential res = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
//       _userId = res.user.uid;
//       IdTokenResult tokenResult = await res.user.getIdTokenResult();
//       _token = tokenResult.token;
//       _expiryDate = tokenResult.expirationTime;
//       var _userEmail = res.user.email;

//       if (_userEmail == 'admin@admin.com') {
//         _isAdmin = true;
//       }
//       final prefs = await SharedPreferences.getInstance();
//       if (prefs != null) {
//         final userData = json.encode(
//           {
//             "token": _token,
//             "userId": _userId,
//             'isAdmin': _isAdmin,
//             "exDate": _expiryDate.toIso8601String(),
//             "email": _userEmail,
//           },
//         );
//         prefs.setString("userData", userData);
//       }
//       notifyListeners();
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> signUp(String email, String password) async {
//     try {
//       UserCredential res = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
//       if (res != null) {
//         signIn(email, password);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<bool> tryAutoLogin() async {
//     final prefs = await SharedPreferences.getInstance();
//     if (!prefs.containsKey("userData")) {
//       return false;
//     }
//     final extractedUserData = json.decode(prefs.getString("userData")) as Map<String, dynamic>;
//     final exDate = DateTime.parse(extractedUserData["exDate"]);
//     if (exDate.isBefore(DateTime.now())) {
//       return false;
//     }
//     _token = extractedUserData["token"];
//     _userId = extractedUserData["userId"];
//     _isAdmin = extractedUserData["isAdmin"];
//     _expiryDate = DateTime.tryParse(extractedUserData["exDate"]);
//     notifyListeners();
//     return true;
//   }

//   void logout() async {
//     try {
//       _token = null;
//       _userId = null;
//       _expiryDate = null;
//       _isAdmin = false;
//       if (_authTimer != null) {
//         _authTimer.cancel();
//       }
//       _authTimer = null;
//       final prefs = await SharedPreferences.getInstance();
//       if (prefs != null) {
//         await prefs.clear();
//       }
//       await FirebaseAuth.instance.signOut();
//       notifyListeners();
//     } catch (e) {
//       print(e);
//     }
//   }

//   // void _autoLogout() {
//   //   if (_authTimer != null) {
//   //     _authTimer.cancel();
//   //   }
//   //   final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
//   //   _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
//   // }
// }
