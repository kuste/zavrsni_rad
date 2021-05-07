import 'package:dungeon_master/models/event.dart';
import 'package:dungeon_master/models/games_data.dart';
import 'package:dungeon_master/wdgets/admin_date_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:dungeon_master/models/notificaftion_manager.dart';

class AdminGamesScreen extends StatefulWidget {
  final dynamic gameId;

  AdminGamesScreen(this.gameId);

  @override
  _AdminGamesScreenState createState() => _AdminGamesScreenState();
}

class _AdminGamesScreenState extends State<AdminGamesScreen> {
  @override
  void initState() {
    super.initState();
    //localNotificationManager.setOnNotificationReceive(onNotificationReceive);
    //localNotificationManager.setOnNotificationClick(onNotificationClick);
  }

  // onNotificationReceive(ReceiveNotification notification) {
  //   print('NOtification received: ${notification.id}');
  // }

  // onNotificationClick(String payload) {
  //   print('Payload $payload');
  // }

  @override
  Widget build(BuildContext context) {
    final _gamesData = Provider.of<GamesData>(context);
    final TextEditingController _dateController = new TextEditingController();
    List<DateTime> _selectedDates = [];
    DateTime selectedDate;
    var _key;

    var _addDate = () async {
      var newEvent = new Event(
        eventId: _key,
        dateTime: selectedDate,
        gameId: widget.gameId,
      );
        _gamesData.addEvent(
          newEvent,
        );

      _dateController.clear();
      setState(() {
        _gamesData.getAllGameData(widget.gameId);
      });
      //await localNotificationManager.showNOtification(newEvent);
    };

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

    return Center(
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
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
                  itemCount: _gamesData.allGameData.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                        background: stackBehindDismiss(),
                        key: ObjectKey(Uuid().v4()),
                        onDismissed: (direction) {
                          var item = _gamesData.allGameData.elementAt(index);
                          _gamesData.deleteEvent(item.eventId);
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Item deleted"),
                              action: SnackBarAction(
                                  label: "UNDO",
                                  onPressed: () {
                                    _gamesData.addEvent(new Event(
                                      dateTime: item.dateTime,
                                      eventId: item.eventId,
                                      gameId: item.gameId,
                                    ));
                                    setState(() {
                                      _gamesData.getAllGameData(widget.gameId);
                                    });
                                  })));
                        },
                        child: AdminEventCard(
                          date: _gamesData.allGameData[index].dateTime,
                        ));
                  },
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _createDatePicker,
                RaisedButton(
                  onPressed: _addDate,
                  child: Text("Confirm"),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
