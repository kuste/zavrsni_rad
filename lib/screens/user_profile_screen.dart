import 'package:dungeon_master/models/games_data.dart';
import 'package:dungeon_master/models/user.dart';
import 'package:dungeon_master/models/user_preferences.dart';
import 'package:dungeon_master/models/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  static const routeName = '/user-profile';

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Future<void> getUserData() async {
    //return await UserPreferences().getUser().then((value) => _user = value);
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    User _user = Provider.of<UserProvider>(context, listen: false).user;
    var size = MediaQuery.of(context).size;
    var _data = Provider.of<GamesData>(context, listen: false);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(size.width * 0.1, 50, size.width * 0.1, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  Align(
                    child: Text('Email'),
                    alignment: Alignment.centerLeft,
                  ),
                  Align(
                    child: Text(
                      _user.userEmail,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  Align(
                    child: Text('Selected events'),
                    alignment: Alignment.centerLeft,
                  ),
                  Align(
                    child: Text(
                      _data.getAllSelectedDatesForUser().toString(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  Divider(
                    color: Colors.black,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  Align(
                    child: Text('Total events'),
                    alignment: Alignment.centerLeft,
                  ),
                  Align(
                    child: Text(
                      _data.allData.length.toString(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
