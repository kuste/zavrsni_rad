import 'package:cached_network_image/cached_network_image.dart';
import 'package:dungeon_master/models/board_game.dart';
import 'package:flutter/material.dart';

import 'package:dungeon_master/models/event.dart';
import 'package:dungeon_master/models/games_data.dart';
import 'package:dungeon_master/screens/game-dates_screen.dart';
import 'package:dungeon_master/screens/game_details_screen.dart';
import 'package:dungeon_master/wdgets/game_card.dart';
import 'package:provider/provider.dart';

class GamesScreen extends StatefulWidget {
  GamesScreen({Key key}) : super(key: key);

  @override
  _GamesScreenState createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> with AutomaticKeepAliveClientMixin {
  final GamesData gd = GamesData();

  @override
  void initState() {
    super.initState();
    getEvents();
  }

  Future<List<Event>> getEvents() async {
    return await gd.getAllGameData().then((value) => evntData = value);
  }

  List<Event> evntData = [];
  @override
  Widget build(BuildContext context) {
    super.build(context);
    var height = MediaQuery.of(context).size.height;
    CachedNetworkImage _loadImg(index) {
      return CachedNetworkImage(
          imageUrl: gd.list[index].game.imageUrl,
          placeholder: (context, url) => Image.asset('assets/images/loader.gif'),
          fit: BoxFit.fill,
          alignment: Alignment.centerLeft,
          errorWidget: (context, url, error) {
            return Image.asset(
              'assets/images/no_image.png',
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
            );
          });
    }

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: gd.getDataFromUrl(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  height: 10,
                ),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                itemCount: gd.list.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameDetailsScreen(image: _loadImg(index)),
                        settings: RouteSettings(arguments: gd.list[index].game),
                      ),
                    );
                  },
                  child: Consumer<GamesData>(
                    builder: (context, value, child) => GameCard(
                      image: _loadImg(index),
                      title: value.list[index].game.name,
                      rank: value.list[index].game.description,
                      year: value.list[index].game.yearPublished.toString(),
                      height: height * 0.33,
                      dateCount: value.list[index].eventCount,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameDates(),
                            settings: RouteSettings(
                              arguments: GameRouteParams(games: gd.list[index].game, events: evntData.where((e) => e.gameId == gd.list[index].game.id).toList()),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text("Alert"),
                        content: Text("Can't get data, please check your connection and try agan!"),
                      ));
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class GameRouteParams {
  BoardGame games;
  List<Event> events;
  GameRouteParams({
    this.games,
    this.events,
  });
}
