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
  dynamic dateId;
  DateTime dateTime;
  Event({
    this.dateId,
    this.dateTime,
  });

  Event.fromJson(Map<String, dynamic> json)
      : dateId = json['dateId'],
        dateTime = json['dateTime'];

  Map<String, dynamic> toJson() => {
        'dateId': dateId.toString(),
        'dateTime': dateTime.toIso8601String(),
      };
}

class SelectedEvent {
  dynamic dateId;
  bool isSelected;
  SelectedEvent({
    this.dateId,
    this.isSelected,
  });
  SelectedEvent.fromJson(Map<String, dynamic> json)
      : dateId = json['dateId'],
        isSelected = json['isSelected'];

  Map<String, dynamic> toJson() => {
        'dateId': dateId,
        'isSelected': isSelected,
      };

  void toggleSelected() {
    isSelected = !isSelected;
  }
}
