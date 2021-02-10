import 'dart:async';

import 'package:dungeon_master/models/board_game.dart';
import 'package:dungeon_master/models/event_data.dart';
import 'package:dungeon_master/models/games_data.dart';
import 'package:dungeon_master/models/user.dart';
import 'package:dungeon_master/models/user_provider.dart';
import 'package:dungeon_master/wdgets/admin_date_card.dart';
import 'package:dungeon_master/wdgets/user_date_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class GameDates extends StatefulWidget {
  static const routeName = '/game-dates';

  @override
  _GameDatesState createState() => _GameDatesState();
}

class _GameDatesState extends State<GameDates> {
  @override
  void initState() {
    super.initState();
    //fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchData() async {
    var response = await GamesData().getAllEventData();
  }

  // Stream<ApiResponse> _stream(Future future) async* {
  //   yield* Stream.fromFuture(future);
  // }

  @override
  Widget build(BuildContext context) {
    final BoardGame game = ModalRoute.of(context).settings.arguments;
    final User user = Provider.of<UserProvider>(context, listen: false).user;
    final _gamesData = Provider.of<GamesData>(context, listen: false);
    final TextEditingController _dateController = new TextEditingController();
    List<DateTime> _selectedDates = [];
    DateTime selectedDate;
    var _key;

    Widget stackBehindDismiss() {
      return Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        color: Colors.red[800],
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      );
    }

    Widget _createDatePicker = Row(
      children: [
        Expanded(
          child: TextField(
            readOnly: true,
            enabled: false,
            controller: _dateController,
            decoration: InputDecoration(
              labelText: "Add date",
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            DatePicker.showDateTimePicker(context, showTitleActions: true, minTime: DateTime.now(), maxTime: DateTime.now().add(Duration(days: 30)), onConfirm: (date) {
              _selectedDates.add(date);
              selectedDate = date;
              _key = Uuid().v1();
              _dateController.text = new DateFormat("dd/MM/yyyy HH:mm:ss").format(date);
            }, currentTime: DateTime.now(), locale: LocaleType.en);
          },
          splashRadius: 20,
          icon: Icon(
            Icons.calendar_today,
          ),
        )
      ],
    );

    // Widget _createEvent = StreamBuilder<List<Event>>(
    //     stream: _stream,
    //     initialData: _gamesData.allData,
    //     builder: (context, snapshot) {
    //       List<Event> dates = [];
    //       if (snapshot.hasError) {
    //         return Center(
    //           child: Text('Data loading error'),
    //         );
    //       }
    //       if (snapshot.hasData) {
    //         if (snapshot.data != null) {
    //           var data = snapshot.data;
    //           if (data != null) {
    //             data.forEach((e) {
    //               if (e.gameId == game.id) {
    //                 dates.add(Event(eventId: e.eventId, dateTime: e.dateTime));
    //               }
    //             });
    //           }
    //         }
    //       }
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       }
    //       return Column(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           SingleChildScrollView(
    //             padding: EdgeInsets.only(top: 18),
    //             physics: NeverScrollableScrollPhysics(),
    //             child: Container(
    //               height: MediaQuery.of(context).size.height * .65,
    //               child: ListView.separated(
    //                 separatorBuilder: (context, index) => SizedBox(
    //                   height: 10,
    //                 ),
    //                 shrinkWrap: true,
    //                 itemCount: dates.length,
    //                 itemBuilder: (context, index) {
    //                   return user.isAdmin
    //                       ? Dismissible(
    //                           background: stackBehindDismiss(),
    //                           key: ObjectKey(Uuid().v4()),
    //                           onDismissed: (direction) {
    //                             // var item = dates.elementAt(index);
    //                             // gameData.removeItem(game.id, item.dateTime);
    //                             // Scaffold.of(context).showSnackBar(SnackBar(
    //                             //     content: Text("Item deleted"),
    //                             //     action: SnackBarAction(
    //                             //         label: "UNDO",
    //                             //         onPressed: () {
    //                             //           var _key = Uuid().v1();
    //                             //           gameData.addItem(user.userId, game.id, item.dateTime, _key);
    //                             //         })));
    //                           },
    //                           child: AdminEventCard(
    //                             date: dates[index].dateTime,
    //                           ),
    //                         )
    //                       : UserEventCard(
    //                           date: dates[index].dateTime,
    //                           isSelected: false, //gameData.selectedDates.isNotEmpty ? gameData.selectedDates.firstWhere((element) => element.dateId == dates[index].dateId).isSelected : false,
    //                           onTap: (value) {
    //                             // if (gameData.selectedDates.isNotEmpty && gameData.selectedDates != null) {
    //                             //   var d = gameData.selectedDates.firstWhere((element) => element.dateId == dates[index].dateId);
    //                             //   print(d.dateId);
    //                             //   setState(() {
    //                             //     d.isSelected = value;
    //                             //   });
    //                             // }
    //                           });
    //                 },
    //               ),
    //             ),
    //           ),
    //           SizedBox(
    //             height: MediaQuery.of(context).size.height * .18,
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.stretch,
    //               children: user.isAdmin
    //                   ? [
    //                       _createDatePicker,
    //                       RaisedButton(
    //                         onPressed: () {
    //                           _gamesData.addEvent(
    //                             new Event(
    //                               eventId: _key,
    //                               dateTime: selectedDate,
    //                               gameId: game.id,
    //                             ),
    //                           );
    //                           _dateController.clear();
    //                         },
    //                         child: Text("Confirm"),
    //                         color: Theme.of(context).primaryColor,
    //                       ),
    //                     ]
    //                   : [
    //                       RaisedButton(
    //                         onPressed: () {
    //                           // _gamesData.addEvent();
    //                           // _dateController.clear();
    //                         },
    //                         child: Text("Confirm"),
    //                         color: Theme.of(context).primaryColor,
    //                       ),
    //                     ],
    //             ),
    //           )
    //         ],
    //       );
    //     });

    return Scaffold(
      appBar: AppBar(
        title: Text('Event Dates'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Consumer<GamesData>(
            builder: (context, snapshot, child) {
              if (snapshot.allData.isNotEmpty) {
                List<Event> dates = [];
                snapshot.allData.forEach((element) {
                  if (element.gameId == game.id) {
                    dates.add(element);
                  }
                });
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SingleChildScrollView(
                      padding: EdgeInsets.only(top: 18),
                      physics: NeverScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * .65,
                        child: ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(
                            height: 10,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                          itemCount: dates.length,
                          itemBuilder: (context, index) => Dismissible(
                            background: stackBehindDismiss(),
                            key: ObjectKey(Uuid().v4()),
                            onDismissed: (direction) {
                              // var item = dates.elementAt(index);
                              // gameData.removeItem(game.id, item.dateTime);
                              // Scaffold.of(context).showSnackBar(SnackBar(
                              //     content: Text("Item deleted"),
                              //     action: SnackBarAction(
                              //         label: "UNDO",
                              //         onPressed: () {
                              //           var _key = Uuid().v1();
                              //           gameData.addItem(user.userId, game.id, item.dateTime, _key);
                              //         })));
                            },
                            child: AdminEventCard(
                              date: dates[index].dateTime,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _createDatePicker,
                        RaisedButton(
                          onPressed: () {
                            _gamesData.addEvent(
                              new Event(
                                eventId: _key,
                                dateTime: selectedDate,
                                gameId: game.id,
                              ),
                            );
                            _dateController.clear();
                          },
                          child: Text("Confirm"),
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ],
                );
              } else if (snapshot == null) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text("Alert"),
                          content: Text("Can't get data, please check your connection and try agan!"),
                        ));
              }
              return CircularProgressIndicator();
            },
          ), //_createEvent,
        ),
      ),
    );
  }
}
