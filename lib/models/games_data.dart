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
    List<Event> eventList = [];
    _selectedDates.clear();
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

  List<SelectedEvent> _selectedDates = [];
  List<SelectedEvent> get selectedDates => _selectedDates;

  Future<void> fetchData() async {
    try {
      var data = await _firestore.collection('eventsData').get();
      if (data != null) {
        List<Event> d = [];
        List<SelectedEvent> sd = [];
        for (var item in data.docs) {
          var dateList = item.data();
          if (dateList != null && dateList['dates'] != null) {
            List<dynamic> dates = dateList['dates'] as List<dynamic>;
            dates.forEach(
              (e) {
                d.add(Event(dateTime: e['dateTime'].toDate(), dateId: e['dateId'].toString()));
                sd.add(SelectedEvent(dateId: e['dateId'].toString(), isSelected: false));
              },
            );
            _eventData.putIfAbsent(
              item.id,
              () => new EventData(dateList: d, userId: item.data()['userId']),
            );
            var doc = await _firestore.collection("savedUserDates").doc(_auth.currentUser.uid).get();
            if (!doc.exists) {
              _selectedDates = sd;
            } else {
              var dateList = doc.data();
              var dates = dateList['dates'] as List<dynamic>;
              dates.forEach((e) {
                _selectedDates.add(SelectedEvent(dateId: e['dateId'], isSelected: e['isSelected']));
              });
            }
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> saveDates() async {
    try {
      var doc = await _firestore.collection("savedUserDates").doc(_auth.currentUser.uid).get();

      if (!doc.exists) {
        _selectedDates.forEach((element) async {
          await _firestore.collection("savedUserDates").doc(_auth.currentUser.uid).set({
            "dates": [
              {
                'dateId': element.dateId,
                'isSelected': element.isSelected,
              }
            ],
          });
        });
      } else {
        _selectedDates.forEach((element) async {
          await _firestore.collection("savedUserDates").doc(_auth.currentUser.uid).update({
            "dates": FieldValue.arrayUnion([
              {
                'dateId': element.dateId,
                'isSelected': element.isSelected,
              }
            ]),
          });
        });
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}
