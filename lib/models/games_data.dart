import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:dungeon_master/models/event_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:dungeon_master/constants.dart';
import 'package:dungeon_master/models/board_game.dart';

class GamesData with ChangeNotifier {
  // final myTransformer = Xml2Json();
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
        print('data loaded');
        return data;
      }
    } on DioError catch (e) {
      print(e.message);
    } catch (e) {
      print(e);
    }
  }

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  List<BoardGame> get list => _list;

  Map<String, EventData> _eventData = {};
  Map<String, EventData> get eventData => _eventData;

  Future<void> addItem(dynamic userId, String id, DateTime date, dynamic dateId) async {
    List<Event> eventList = new List();

    if (date != null) {
      Event newEvent = Event(dateId: dateId, dateTime: date);
      if (!eventList.contains(newEvent)) {
        eventList.add(newEvent);
        _selectedDates.add(SelectedEvent(dateId: newEvent.dateId, isSelected: false));
      }
      if (_eventData.containsKey(id)) {
        _eventData.update(id, (value) => EventData(userId: userId, dateList: [...value.dateList, Event(dateTime: date, dateId: dateId)]));
      } else {
        _eventData.putIfAbsent(id, () => new EventData(userId: userId, dateList: eventList));
      }
      try {
        for (var item in _eventData.keys) {
          if (item == id) {
            var doc = await _firestore.collection("eventsData").doc(item).get();

            if (!doc.exists) {
              // await _firestore.collection("eventsData").doc(id).set({
              //   "dates": [
              //     {'': ''},
              //   ]
              //});
              eventList.forEach((element) async {
                await _firestore.collection("eventsData").doc(id).set(
                  {
                    'dates': [
                      {
                        'dateId': element.dateId,
                        'dateTime': element.dateTime,
                      }
                    ],
                  },
                  SetOptions(merge: true),
                );
              });
            } else {
              eventList.forEach((element) async {
                await _firestore.collection("eventsData").doc(id).update(
                  {
                    'dates': FieldValue.arrayUnion([
                      {
                        'dateId': element.dateId,
                        'dateTime': element.dateTime,
                      }
                    ]),
                  },
                );
              });
            }
          }
        }
      } catch (e) {
        print(e);
      }
      notifyListeners();
    }
  }

  Future<void> removeItem(String id, dynamic date) async {
    List<Event> newList = [];
    if (_eventData.containsKey(id)) {
      for (var item in _eventData.values) {
        item.dateList.removeWhere((item) => item.dateTime == date);
        newList = item.dateList;
      }
    }
    try {
      for (var item in _eventData.keys) {
        if (item == id) {
          await _firestore.collection("eventsData").doc(item).update({"dates": jsonEncode(newList), 'userId': _eventData[item].userId});
        }
      }
    } catch (e) {
      print(e);
    }
  }

  static List<SelectedEvent> _selectedDates = new List<SelectedEvent>();
  List<SelectedEvent> get selectedDates => _selectedDates;

  Future<void> fetchData() async {
    _selectedDates.clear();
    try {
      var data = await _firestore.collection('eventsData').get();
      if (data != null) {
        List<Event> d = [];
        List<SelectedEvent> sd = [];
        for (var item in data.docs) {
          var dateList = item.data();
          if (dateList != null && dateList['dates'] != null) {
            List<dynamic> dates = dateList['dates'] as List<dynamic>;
            var newDate;
            dates.forEach(
              (e) {
                if (!d.contains(e)) {
                  d.add(Event(dateTime: e['dateTime'].toDate(), dateId: e['dateId'].toString()));
                  newDate = Event(dateTime: e['dateTime'].toDate(), dateId: e['dateId'].toString());
                }
                if (!sd.contains(e)) {
                  sd.add(SelectedEvent(dateId: e['dateId'].toString(), isSelected: false));
                }
              },
            );
            if (_eventData.containsKey(item.id)) {
              _eventData.update(
                item.id,
                (value) => new EventData(dateList: [...value.dateList, newDate], userId: item.data()['userId']),
              );
            } else {
              _eventData.putIfAbsent(
                item.id,
                () => new EventData(dateList: d, userId: item.data()['userId']),
              );
            }
            var doc = await _firestore.collection("savedUserDates").doc(_auth.currentUser.uid).get();
            if (!doc.exists) {
              _selectedDates = List.from(sd);
            } else {
              var dateList = doc.data();
              var dates = dateList['dates'] as List<dynamic>;
              dates.forEach((e) {
                if (!_selectedDates.contains(e)) {
                  _selectedDates.add(SelectedEvent(dateId: e['dateId'], isSelected: e['isSelected']));
                }
              });
            }
          }
        }
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> saveDates() async {
    try {
      var doc = await _firestore.collection("savedUserDates").doc(_auth.currentUser.uid).get();
      List<dynamic> newList = new List();
      _selectedDates.forEach((element) {
        if (!newList.contains(element)) {
          newList.add({
            'dateId': element.dateId,
            'isSelected': element.isSelected,
          });
        }
      });
      if (!doc.exists) {
        await _firestore.collection("savedUserDates").doc(_auth.currentUser.uid).set({
          "dates": newList,
        });
      } else {
        await _firestore.collection("savedUserDates").doc(_auth.currentUser.uid).update({
          "dates": FieldValue.arrayRemove(newList),
        });
        await _firestore.collection("savedUserDates").doc(_auth.currentUser.uid).update({
          "dates": newList,
        });
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}
