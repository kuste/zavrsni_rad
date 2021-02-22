import 'package:dungeon_master/models/event_data.dart';
import 'package:dungeon_master/models/games_data.dart';
import 'package:dungeon_master/models/user.dart';
import 'package:dungeon_master/models/user_provider.dart';
import 'package:dungeon_master/screens/admin_dates_screen.dart';
import 'package:dungeon_master/screens/games_screen.dart';
import 'package:dungeon_master/screens/user_dates_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameDates extends StatefulWidget {
  static const routeName = '/game-dates';

  @override
  _GameDatesState createState() => _GameDatesState();
}

class _GameDatesState extends State<GameDates> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GameRouteParams gameData = ModalRoute.of(context).settings.arguments;
    final _userProvider = Provider.of<UserProvider>(context, listen: false);
    final _gamesData = Provider.of<GamesData>(context, listen: false);

    final game = gameData.games;

    return Scaffold(
      appBar: AppBar(
        title: Text('Event Dates'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _gamesData.getAllGameData(gameData.games.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _userProvider.user.role == Role.admin ? AdminGamesScreen(game.id) : UserDatesScreen(game.id);
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
