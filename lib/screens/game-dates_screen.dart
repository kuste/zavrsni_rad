import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dungeon_master/models/auth.dart';
import 'package:dungeon_master/wdgets/user_date_card.dart';
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

class _GameDatesState extends State<GameDates> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var _isSelected = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await GamesData().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final BoardGame game = ModalRoute.of(context).settings.arguments;
    final Auth auth = Provider.of<Auth>(context);
    final TextEditingController _dateController = new TextEditingController();
    List<DateTime> _selectedDates = [];
    DateTime selectedDate;
    final gameData = Provider.of<GamesData>(context);

    gameData.fetchData();
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

    Widget _createEvent = StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection("eventsData").snapshots(),
        builder: (context, snapshot) {
          List<dynamic> dates = [];
          if (snapshot.hasError) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data;
            final events = data.docs.isNotEmpty ? data.docs : null;
            if (events != null) {
              events.forEach((element) {
                if (element.id == game.id) {
                  var eventData = element.data();
                  if (eventData != null) {
                    List datesList = jsonDecode(eventData['dates']);
                    if (datesList != null) {
                      datesList.forEach((element) {
                        print(element['dateTime']);
                        dates.add(DateTime.parse(element['dateTime']));
                      });
                    }
                  }
                }
              });
            }
          }
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
                    shrinkWrap: true,
                    itemCount: dates.length,
                    itemBuilder: (context, index) {
                      var a = gameData.eventData[game.id];
                      return UserDateCard(
                        date: dates[index],
                        isChecked: false,
                        checkboxCallback: (value) {
                          setState(() {});
                        },
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
                        gameData.addItem(auth.userId, game.id, selectedDate, _isSelected);
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
        });

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
