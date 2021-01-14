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
}

class Event {
  DateTime dateTime;
  bool isSelected = false;
  Event({
    this.dateTime,
    this.isSelected,
  });

  Event.fromJson(Map<String, dynamic> json)
      : dateTime = json['dateTime'],
        isSelected = json['dateList'];

  Map<String, dynamic> toJson() => {
        'dateTime': dateTime.toIso8601String(),
        'isSelected': isSelected,
      };
  void toggleSelected() {
    isSelected = !isSelected;
  }
}
