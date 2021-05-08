import 'package:dungeon_master/models/games_data.dart';
import 'package:dungeon_master/models/notificaftion_manager.dart';
import 'package:dungeon_master/wdgets/user_date_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDatesScreen extends StatefulWidget {
  final dynamic gameId;
  UserDatesScreen(this.gameId);

  @override
  _UserDatesScreenState createState() => _UserDatesScreenState();
}

class _UserDatesScreenState extends State<UserDatesScreen> {
  @override
  void initState() {
    super.initState();
    // localNotificationManager.setOnNotificationReceive(onNotificationReceive);
    // localNotificationManager.setOnNotificationClick(onNotificationClick);
  }

  onNotificationReceive(ReceiveNotification notification) {
    //print('Notification received: ${notification.id}');
  }

  onNotificationClick(String payload) {
    //print('Payload $payload');
  }

  @override
  Widget build(BuildContext context) {
    final _gamesData = Provider.of<GamesData>(context, listen: false);
    final TextEditingController _dateController = new TextEditingController();

    return Center(
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(top: 18),
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height * .65,
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                    height: 10,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  itemCount: _gamesData.allGameData.length,
                  itemBuilder: (context, index) {
                    return UserEventCard(
                      date: _gamesData.allGameData[index].dateTime,
                      isSelected: _gamesData.allGameData[index].isSelected,
                      onTap: (value) {
                        setState(() {
                          _gamesData.allGameData[index].isSelected = value;
                        });
                      },
                    );
                  },
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(),
                RaisedButton(
                  onPressed: () async {
                    _gamesData.saveSelectedEvents(_gamesData.allGameData);
                    _dateController.clear();
                    Navigator.pop(context);
                    // await localNotificationManager.showNOtification();
                  },
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
