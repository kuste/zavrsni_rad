import 'package:dungeon_master/models/board_game.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;

class GameDetailsScreen extends StatelessWidget {
  static const String routeName = '/game-details';

  final Widget image;

  GameDetailsScreen({this.image});

  @override
  Widget build(BuildContext context) {
    final BoardGame game = ModalRoute.of(context).settings.arguments;
    final desc = parse(game.description).body.text;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              image,
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  border: Border(
                      bottom: BorderSide(
                    color: Colors.black,
                    width: 1,
                  )),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          game.name,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text('Min Age ${game.minAge.toString()}'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(desc),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  border: Border.symmetric(
                      horizontal: BorderSide(
                    color: Colors.black,
                    width: 1,
                  )),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text('Players ${game.minPlayers.toString()} - ${game.maxPlayers.toString()}'),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text('Play Time ${game.minPlaytime.toString()} - ${game.maxPlaytime.toString()} min'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
