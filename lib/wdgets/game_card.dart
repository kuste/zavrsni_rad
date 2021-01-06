import 'package:flutter/material.dart';

class GameCard extends StatefulWidget {
  final Widget image;
  final String title;
  final String year;
  final String rank;
  final double height;
  final Function onTap;

  const GameCard({
    this.onTap,
    this.image,
    this.title,
    this.year,
    this.rank,
    this.height,
  });

  @override
  _GameCardState createState() => _GameCardState();
}

const List<String> _popupItemList = ['Dates'];

class _GameCardState extends State<GameCard> {
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
                        child: Text(
                          '(${widget.year})',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (_) => widget.onTap(),
              itemBuilder: (_) => _popupItemList
                  .map(
                    (e) => PopupMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
