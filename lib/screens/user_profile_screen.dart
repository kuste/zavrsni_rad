import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  static const routeName = '/user-profile';
  UserProfile({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Profile'),
      ),
    );
  }
}
