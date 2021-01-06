import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:dungeon_master/models/board_game.dart';
import 'package:dungeon_master/models/games_data.dart';
import 'package:provider/provider.dart';

class GameDates extends StatefulWidget {
  static const routeName = '/game-dates';

  @override
  _GameDatesState createState() => _GameDatesState();
}

//final List<GameReservationDatesDto> dateList = GamesData().dateList;

class _GameDatesState extends State<GameDates> {
  @override
  Widget build(BuildContext context) {
    final BoardGame game = ModalRoute.of(context).settings.arguments;

    final TextEditingController _dateController = new TextEditingController();
    List<DateTime> _selectedDates = [];
    DateTime selectedDate;
    Widget _createDatePicker = Row(
      children: [
        Expanded(
          child: TextField(
            readOnly: true,
            enabled: false,
            controller: _dateController,
            decoration: InputDecoration(
              labelText: "Select Date",
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            DatePicker.showDateTimePicker(context, showTitleActions: true, minTime: DateTime.now(), maxTime: DateTime.now().add(Duration(days: 30)), onConfirm: (date) {
              _selectedDates.add(date);
              selectedDate = date;
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

    Widget _createEvent = Consumer<GamesData>(
      builder: (context, value, child) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                    height: 10,
                  ),
                  shrinkWrap: true,
                  itemCount: value.items[game.id] != null ? 1 : 0,
                  itemBuilder: (context, index) {
                    return Column(
                      children: value.items[game.id].map((e) => Text(e.toIso8601String())).toList(),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _createDatePicker,
                  RaisedButton(
                    onPressed: () {
                      value.addItem(game.id, selectedDate);
                      _dateController.clear();
                    },
                    child: Text("Confirm"),
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Event Dates'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: _createEvent,
      ),
    );
  }
}
