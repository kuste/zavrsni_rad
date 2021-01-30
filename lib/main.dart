import 'package:dungeon_master/models/auth.dart';
import 'package:dungeon_master/models/auth_provider.dart';
import 'package:dungeon_master/models/games_data.dart';
import 'package:dungeon_master/models/user.dart';
import 'package:dungeon_master/models/user_preferences.dart';
import 'package:dungeon_master/models/user_provider.dart';
import 'package:dungeon_master/screens/game-dates_screen.dart';
import 'package:dungeon_master/screens/game_details_screen.dart';
import 'package:dungeon_master/screens/home_screen.dart';
import 'package:dungeon_master/screens/login_screen.dart';
import 'package:dungeon_master/screens/register_screen.dart';
import 'package:dungeon_master/screens/user_profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    Future<User> getUserData() => UserPreferences().getUser();
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error'),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => AuthProvider()),
              ChangeNotifierProvider(create: (_) => UserProvider()),
              ChangeNotifierProvider(create: (_) => GamesData()),
            ],
            child: MaterialApp(
              title: 'Dungeone Master',
              theme: ThemeData(
                primaryColor: Colors.amber,
                textTheme: TextTheme(
                  bodyText2: TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ),
              home: FutureBuilder(
                future: getUserData(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return CircularProgressIndicator();
                    default:
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      else if (snapshot.data.token == null)
                        return LoginScreen();
                      else
                        UserPreferences().removeUser();
                      Provider.of<UserProvider>(context, listen: false).setUser(snapshot.data);
                      return HomeScreen();
                  }
                },
              ),
              routes: {
                HomeScreen.routeName: (ctx) => HomeScreen(),
                LoginScreen.routeName: (ctx) => LoginScreen(),
                RegisterScreen.routeName: (ctx) => RegisterScreen(),
                GameDetailsScreen.routeName: (ctx) => GameDetailsScreen(),
                UserProfile.routeName: (ctx) => UserProfile(),
                GameDates.routeName: (ctx) => GameDates(),
              },
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
