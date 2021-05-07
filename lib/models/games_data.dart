import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dungeon_master/models/api_response/api_response.dart';
import 'package:dungeon_master/models/event.dart';
import 'package:dungeon_master/models/event_data.dart';
import 'package:dungeon_master/models/user.dart';
import 'package:dungeon_master/models/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dungeon_master/constants.dart';
import 'package:dungeon_master/models/board_game.dart';

class GamesData with ChangeNotifier {
  // final myTransformer = Xml2Json();
  static List<EventData> _list = [];

  Future<List<EventData>> getDataFromUrl() async {
    List<EventData> result;
    list.clear();
    try {
      print('getting data...');
      var response = await Dio().get(kApiUrl);
      if (response.statusCode == 200) {
        var data = response.data['games'] as List<dynamic>;
        await getAllEventData();
        data.forEach((element) async {
          var game = BoardGame.fromJson(element);
          int result = getAllDatesForGame(game.id);

          list.add(EventData(game: game, eventCount: result));
        });
        list.sort((a, b) => b.eventCount.compareTo(a.eventCount));
        result = list;
        print('data loaded');
      }
    } on DioError catch (e) {
      print(e.message);
    } catch (e) {
      print(e);
    }
    return result;
  }

  //List<BoardGame> get list => _list;

  List<EventData> get list => _list;

  List<Event> _allData = new List<Event>();
  List<Event> get allData => _allData;

  List<Event> _allGameData = new List<Event>();
  List<Event> get allGameData => _allGameData;

  Future<List<Event>> getAllGameData([dynamic gameId]) async {
    var result;
    try {
      User user = await UserPreferences().getUser();

      var res = await Dio().get(kConnDataGetAllForUser,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${user.token}',
            },
          ));
      if (res.statusCode == 200) {
        var responseData = ApiResponse.fromJson(res.data);
        var data = (responseData.data as List)
            ?.map(
              (e) => new Event(
                dateTime: DateTime.parse(e['dateTime']),
                eventId: e['eventId'],
                gameId: e['gameId'],
                isSelected: e['isSelected'],
              ),
            )
            ?.toList();
        _allData = data;
        _allGameData = _allData.where((e) => e.gameId == gameId).toList();
        result = _allGameData;

        notifyListeners();
      } else {
        print(res.statusMessage);
      }
    } on DioError catch (e) {
      print(e.message);
      print(e.error);
      print(e.response.statusMessage);
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<List<Event>> getAllEventData() async {
    var result;
    try {
      User user = await UserPreferences().getUser();

      var res = await Dio().get(kConnDataGetAllForUser,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${user.token}',
            },
          ));
      if (res.statusCode == 200) {
        var responseData = ApiResponse.fromJson(res.data);
        var data = (responseData.data as List)
            ?.map(
              (e) => new Event(
                dateTime: DateTime.parse(e['dateTime']),
                eventId: e['eventId'],
                gameId: e['gameId'],
                isSelected: e['isSelected'],
              ),
            )
            ?.toList();
        _allData = data;
        result = data;

        notifyListeners();
      } else {
        print(res.statusMessage);
      }
    } on DioError catch (e) {
      print(e.message);
      print(e.error);
      print(e.response.statusMessage);
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<void> addEvent(Event event) async {
    var result;
    try {
      User user = await UserPreferences().getUser();
      var res = await http.post(kConnDataAdd,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user.token}',
          },
          body: json.encode({
            'eventId': event.eventId,
            'dateTime': event.dateTime.toIso8601String(),
            'gameId': event.gameId,
            'isSelected': event.isSelected,
          }));
      final responseData = ApiResponse.fromJson(json.decode(res.body));
      var data = (responseData.data as List)
          ?.map(
            (e) => new Event(
              dateTime: DateTime.parse(e['dateTime']),
              eventId: e['eventId'],
              gameId: e['gameId'],
              isSelected: e['isSelected'],
            ),
          )
          ?.toList();
      _allData = data;
      for (var item in _allData) {
        var eventCount = getAllDatesForGame(item.gameId);
        list.firstWhere((element) => element.game.id == item.gameId).eventCount = eventCount;
      }
      result = data;
      if (_allGameData.contains(event)) {
        _allGameData.add(event);
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      //result = {'status': false, 'message': 'Error', 'data': e.toString()};
      print(e);
    }

    return result;
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      User user = await UserPreferences().getUser();
      await http.post("$kConnDataDelete?eventId=$eventId", headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${user.token}',
      });
      _allData.removeWhere((e) => e.eventId == eventId);
      _allGameData.removeWhere((e) => e.eventId == eventId);

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> saveSelectedEvents(List<Event> eventData) async {
    if (_allData == null || _allData.length == 0) {
      return;
    }

    try {
      User user = await UserPreferences().getUser();
      var res = await http.post("$kSaveSelectedEvents",
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user.token}',
          },
          body: jsonEncode(eventData));
    } catch (e) {
      print(e);
    }
  }

  Future<int> getAllSelectedDatesNo() {}
  int getAllSelectedDatesForUser() {
    var data = _allData.where((e) => e.isSelected == true).toList();
    return data.length;
  }

  Future<List<Event>> getAllEventsForGame(dynamic gameId) async {
    var result;
    try {
      User user = await UserPreferences().getUser();

      var res = await Dio().post(
        kConnDataGetAllForUser,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user.token}',
          },
        ),
        data: gameId,
      );
      if (res.statusCode == 200) {
        var responseData = ApiResponse.fromJson(res.data);
        var data = (responseData.data as List)
            ?.map(
              (e) => new Event(
                dateTime: DateTime.parse(e['dateTime']),
                eventId: e['eventId'],
                gameId: e['gameId'],
                isSelected: e['isSelected'],
              ),
            )
            ?.toList();
        result = data;

        notifyListeners();
      } else {
        print(res.statusMessage);
      }
    } on DioError catch (e) {
      print(e.message);
      print(e.error);
      print(e.response.statusMessage);
    } catch (e) {
      print(e);
    }
    return result;
  }

  int getAllDatesForGame(dynamic gameId) {
    return _allData.where((e) => e.gameId == gameId).length;
  }
}
