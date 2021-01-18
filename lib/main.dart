import 'package:dungeon_master/models/auth.dart';
import 'package:dungeon_master/models/games_data.dart';
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
              ChangeNotifierProvider.value(
                value: Auth(),
              ),
              ChangeNotifierProvider.value(
                value: GamesData(),
              ),
            ],
            child: Consumer<Auth>(
              builder: (context, value, child) {
                return MaterialApp(
                  title: 'Dungeone Master',
                  theme: ThemeData(
                    primaryColor: Colors.amber,
                    textTheme: TextTheme(
                      bodyText2: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  home: value.isAuth
                      ? HomeScreen()
                      : FutureBuilder(
                          future: value.tryAutoLogin(),
                          builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting ? CircularProgressIndicator() : LoginScreen(),
                        ),
                  routes: {
                    HomeScreen.routeName: (ctx) => HomeScreen(),
                    LoginScreen.routeName: (ctx) => LoginScreen(),
                    RegisterScreen.routeName: (ctx) => RegisterScreen(),
                    GameDetailsScreen.routeName: (ctx) => GameDetailsScreen(),
                    UserProfile.routeName: (ctx) => UserProfile(),
                    GameDates.routeName: (ctx) => GameDates(),
                  },
                );
              },
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
