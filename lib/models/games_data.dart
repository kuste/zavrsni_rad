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

//  DateTime.utc(2021, 1, 1),
//       DateTime.utc(2021, 1, 2),
//       DateTime.utc(2021, 1, 8),
//       DateTime.utc(2021, 1, 9),
//       DateTime.utc(2021, 1, 15),
//       DateTime.utc(2021, 1, 16),
//       DateTime.utc(2021, 1, 22),
//       DateTime.utc(2021, 1, 29),
  // List<GameReservationDatesDto> _dateList = [
  //   GameReservationDatesDto(date: DateTime.utc(2021, 1, 1), time: [TimeOfDay(hour: 16, minute: 0)]),
  //   GameReservationDatesDto(date: DateTime.utc(2021, 1, 2), time: [TimeOfDay(hour: 16, minute: 0)]),
  //   GameReservationDatesDto(date: DateTime.utc(2021, 1, 8), time: [TimeOfDay(hour: 16, minute: 0)]),
  //   GameReservationDatesDto(date: DateTime.utc(2021, 1, 9), time: [TimeOfDay(hour: 16, minute: 0)]),
  // ];

  List<BoardGame> get list => _list;
  // List<GameReservationDate> _dateList;
  // List<GameReservationDate> get dateList => _dateList;

//   List<DateTime> _dates = [];
//   List<GameReservations> _gameReservations = [];
//   List<GameReservations> get gameReservations => _gameReservations;

//   setEventDate({String id, DateTime date}) {
//     _dates.add(date);
//     _gameReservations.add(new GameReservations(gameId: id, dates: _dates));
//     notifyListeners();
//   }

//   getAvaliableDates(dynamic id) {
//     for (var item in _gameReservations) {
//       if (item.gameId == id) {
//         return item.dates;
//       }
//     }
//   }
// }

// class GameReservations {
//   dynamic gameId;
//   List<DateTime> dates;
//   GameReservations({
//     this.gameId,
//     this.dates,
//   });
//   numberOfReservations() => dates.length;
// }

// Map<dynamic, List<DateTime>> reservations = {};
// void numberofReservations(id) => reservations[id].length;

  Map<dynamic, List<DateTime>> _items = {};

  Map<dynamic, List<DateTime>> get items {
    return {..._items};
  }

  int totalDates(dynamic id) {
    _items.forEach((key, value) {
      if (key == id) {
        return value.length;
      }
    });
    return 0;
  }

  void addItem(String id, DateTime date) {
    if (_items.containsKey(id)) {
      //change quantity
      _items.update(id, (d) {
        d.add(date);
        return d;
      });
    } else {
      _items.putIfAbsent(id, () => [date]);
    }

    // print('length ${_items.length.toString()}');
    // print('entries ${_items[id].length}');
    // print('entries ${_items[id]}');
    var items = _items[id];
    print('$id $items');

    // print('keys ${_items.keys.toString()}');
    // print('values ${_items.values.first[0].toString()}');

    notifyListeners();
  }
}
