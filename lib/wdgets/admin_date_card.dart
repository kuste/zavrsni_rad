import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminEventCard extends StatelessWidget {
  const AdminEventCard({
    @required this.date,
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
        padding: EdgeInsets.all(10),
        child: ListTile(
          title: Text(DateFormat('EEEE').format(date)),
          subtitle: Text(DateFormat('dd.MM.yyyy. HH:mm').format(date)),
        ),
      ),
    );
  }
}
