import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:dungeon_master/models/event_data.dart';
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

  Map<String, EventData> _eventData = {};
  Map<String, EventData> get eventData => _eventData;

  Future<void> addItem(dynamic userId, String id, DateTime date, [bool isSelected = false]) async {
    List<Event> eventList = [];
    if (date != null) {
      if (!eventList.contains(date)) {
        eventList.add(Event(dateTime: date, isSelected: isSelected));
      }
      if (_eventData.containsKey(id)) {
        _eventData.update(id, (value) => EventData(userId: userId, dateList: [...value.dateList, Event(dateTime: date, isSelected: isSelected)]));
      } else {
        _eventData.putIfAbsent(id, () => new EventData(userId: userId, dateList: eventList));
      }
      try {
        for (var item in _eventData.keys) {
          if (item == id) {
            var doc = await _firestore.collection("eventsData").doc(item).get();

            if (!doc.exists) {
              await _firestore.collection("eventsData").doc(id).set({"dates": jsonEncode(eventList), 'userId': userId});
            } else {
              await _firestore.collection("eventsData").doc(item).update({"dates": jsonEncode(_eventData[item].dateList), 'userId': _eventData[item].userId});
            }
          }
        }
      } catch (e) {
        print(e);
      }
      notifyListeners();
    }
  }

  Future<void> fetchData() async {
    try {
      var data = await _firestore.collection('eventsData').get();
      if (data != null) {
        for (var item in data.docs) {
          var dateList = item.data();
          var dates = jsonDecode(dateList['dates']) as List;
          var d = dates.map((e) => Event(dateTime: DateTime.parse(e['dateTime']), isSelected: e['isSelected'])).toList();
          _eventData.putIfAbsent(
            item.id,
            () => new EventData(dateList: d, userId: item.data()['userId']),
          );
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
