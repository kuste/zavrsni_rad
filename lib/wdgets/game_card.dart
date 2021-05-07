import 'package:flutter/material.dart';

class GameCard extends StatefulWidget {
  final Widget image;
  final String title;
  final String year;
  final String rank;
  final double height;
  final Function onTap;
  final int dateCount;
  const GameCard({
    this.onTap,
    this.image,
    this.title,
    this.year,
    this.rank,
    this.height,
    this.dateCount,
  });

  @override
  _GameCardState createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  Widget setYear() {
    if (widget.year == "null") {
      return Text("");
    } else {
      return Text(widget.year);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height * 0.3,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 6,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: SizedBox(
                child: widget.image,
              ),
            ),
            Expanded(
              flex: 10,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Text(
                          widget.title,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                        child: setYear(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            NamedIcon(
              iconData: Icons.date_range_rounded,
              text: 'Dates',
              notificationCount: widget.dateCount,
              onTap: widget.onTap,
            )
          ],
        ),
      ),
    );
  }
}

class NamedIcon extends StatelessWidget {
  final IconData iconData;
  final String text;
  final Function onTap;
  final int notificationCount;

  const NamedIcon({
    Key key,
    this.onTap,
    @required this.text,
    @required this.iconData,
    this.notificationCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 72,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(iconData),
                Text(text, overflow: TextOverflow.ellipsis),
              ],
            ),
            Positioned(
              top: 5,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                alignment: Alignment.center,
                child: Text(
                  '$notificationCount',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
