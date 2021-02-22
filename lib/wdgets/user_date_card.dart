import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class UserEventCard extends StatelessWidget {
  const UserEventCard({
    @required this.date,
    this.isSelected,
    this.onTap,
  });

  final DateTime date;
  final bool isSelected;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return Card(
      key: ObjectKey(Uuid().v4()),
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        child: CheckboxListTile(
          title: Text(DateFormat('EEEE').format(date)),
          subtitle: Text(DateFormat('dd.MM.yyyy. HH:mm').format(date)),
          value: isSelected,
          onChanged: onTap,
        ),
      ),
    );
  }
}
