class EventData {
  dynamic userId;
  List<Event> dateList;
  EventData({
    this.userId,
    this.dateList,
  });
  EventData.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        dateList = json['dateList'] as List<Event>;

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'dateList': dateList,
      };
}

class UserEventData {
  List<SelectedEvent> dateList;
  UserEventData({
    this.dateList,
  });
  UserEventData.fromJson(Map<String, dynamic> json) : dateList = json['dateList'] as List<SelectedEvent>;

  Map<String, dynamic> toJson() => {
        'dateList': dateList,
      };
}

class Event {
  dynamic eventId;
  DateTime dateTime;
  dynamic gameId;
  Event({this.eventId, this.dateTime, this.gameId});

  Event.fromJson(Map<String, dynamic> json)
      : eventId = json['eventId'],
        dateTime = DateTime.parse(json['dateTime']),
        gameId = json['gameId'];

  Map<String, dynamic> toJson() => {
        'eventId': eventId.toString(),
        'dateTime': dateTime.toIso8601String(),
        'gameId': dateTime.toString(),
      };
}

class SelectedEvent {
  dynamic eventId;
  bool isSelected;
  SelectedEvent({
    this.eventId,
    this.isSelected,
  });
  SelectedEvent.fromJson(Map<String, dynamic> json)
      : eventId = json['eventId'],
        isSelected = json['isSelected'];

  Map<String, dynamic> toJson() => {
        'eventId': eventId,
        'isSelected': isSelected,
      };

  void toggleSelected() {
    isSelected = !isSelected;
  }
}
