class Event {
  dynamic eventId;
  DateTime dateTime;
  dynamic gameId;
  bool isSelected;

  Event({this.eventId, this.dateTime, this.gameId, this.isSelected = false});

  Event.fromJson(Map<String, dynamic> json)
      : eventId = json['eventId'],
        dateTime = DateTime.parse(json['dateTime']),
        gameId = json['gameId'],
        isSelected = json['isSelected'];

  Map<String, dynamic> toJson() => {
        'eventId': eventId.toString(),
        'dateTime': dateTime.toIso8601String(),
        'gameId': dateTime.toString(),
        'isSelected': isSelected,
      };
}
