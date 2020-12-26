import 'package:dungeon_master/models/games_data.dart';
import 'package:dungeon_master/screens/game_details_screen.dart';
import 'package:dungeon_master/wdgets/game_card.dart';
import 'package:flutter/material.dart';

class GamesScreen extends StatefulWidget {
  GamesScreen({Key key}) : super(key: key);
  @override
  _GamesScreenState createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> with AutomaticKeepAliveClientMixin {
  final GamesData gd = GamesData();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var height = MediaQuery.of(context).size.height;
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
                        builder: (context) => GameDetailsScreen(),
                        settings: RouteSettings(arguments: gd.list[index]),
                      ),
                    );
                  },
                  child: GameCard(
                    imageUrl: gd.list[index].imageUrl,
                    title: gd.list[index].name,
                    rank: gd.list[index].description,
                    year: gd.list[index].yearPublished.toString(),
                    height: height * 0.33,
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
