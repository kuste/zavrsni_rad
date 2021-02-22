import 'package:dungeon_master/models/games_data.dart';
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
                    print(_gamesData.allGameData);
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
                  onPressed: () {
                    _gamesData.saveSelectedEvents(_gamesData.allGameData);
                    _dateController.clear();
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
