import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:xml2json/xml2json.dart';

import 'package:dungeon_master/constants.dart';
import 'package:dungeon_master/models/board_game.dart';

class GamesData with ChangeNotifier {
  final myTransformer = Xml2Json();
  final List<BoardGame> _list = [];
  Future<dynamic> getDataFromUrl() async {
    try {
      print('getting data...');
      var response = await Dio().get(kApiUrl);
      //var r = await Dio().get('https://api.geekdo.com/xmlapi2/thing?id=300000/type=boardgame');
      if (response.statusCode == 200) {
        var data = response.data['games'] as List<dynamic>;

        data.forEach((element) {
          list.add(BoardGame.fromJson(element));
        });
        // var data = XmlDocument.parse(response.data);
        // myTransformer.parse(data.toXmlString());
        // var convertedData = myTransformer.toGData();
        // var json = jsonDecode(convertedData);
        // ResponseDto responsedata = ResponseDto.fromJson(json);

        // responsedata.item.forEach((element) {
        //   list.add((BoardGame.fromJson(element)));
        // });
        return data;
      }
    } on DioError catch (e) {
      print(e.message);
    } catch (e) {
      print(e);
    }
  }

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<BoardGame> get list => _list;

  Map<dynamic, List<DateTime>> _events = {};

  Map<dynamic, List<DateTime>> get events {
    return {..._events};
  }

  int totalDates(dynamic id) {
    _events.forEach((key, value) {
      if (key == id) {
        return value.length;
      }
    });
    return 0;
  }

  List<GamesData> datesList = [];
  Future<void> addItem(dynamic userId, String id, DateTime date) async {
    if (date != null) {
      if (_events.containsKey(id)) {
        _events.update(id, (d) {
          if (!d.contains(date)) {
            d.add(date);
          }
          return d;
        });
      } else {
        _events.putIfAbsent(id, () => [date]);
      }
      if (_firestore.collection("eventsData").get() != null) {
        await _firestore.collection("eventsData").doc(userId).set({"dates": _events});
      } else {
        await _firestore.collection("eventsData").doc(userId).update({"dates": _events});
      }

      notifyListeners();
    }
  }
}

class EventDates {
  dynamic gameId;
  DateTime dateTime;
  EventDates({
    this.gameId,
    this.dateTime,
  });
}
