import 'package:dungeon_master/models/board_game.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;

class GameDetailsScreen extends StatelessWidget {
  static const String routeName = '/game-details';

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
              Image.network(game.imageUrl),
              Text(game.name),
              Text(desc),
              Text('Min Players ${game.minPlayers.toString()}'),
              Text('Max Players ${game.maxPlayers.toString()}'),
              Text('Min Play Time ${game.minPlaytime.toString()} min'),
              Text('Max Play Time ${game.maxPlaytime.toString()} min'),
              Text('Min Age ${game.minAge.toString()}'),
            ],
          ),
        ),
      ),
    );
  }
}
