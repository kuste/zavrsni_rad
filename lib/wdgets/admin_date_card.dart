import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminEventCard extends StatelessWidget {
  const AdminEventCard({
    this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE').format(date),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  DateFormat('dd.MM.yyyy. HH:mm').format(date),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
