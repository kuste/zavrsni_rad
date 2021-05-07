import 'package:dungeon_master/models/board_game.dart';

class EventData {
  BoardGame _game;
  int _eventCount;

  EventData({BoardGame game, int eventCount}) {
    this._eventCount = eventCount;
    this._game = game;
  }

  BoardGame get game => _game;
  int get eventCount => _eventCount;

  set eventCount(int eventCount) {
    this._eventCount = eventCount;
  }
}
