class Event {
  late String title;
  late String day;
  late String type;
  late EventDate eventDate;
  
  Event({
    required this.title,
    required this.day,
    required this.type,
    required this.eventDate,
  });

  Event.fromMap(Map<String, dynamic> map) :
    this.title = map['title'],
    this.day = map['day'],
    this.type = map['type'],
    this.eventDate = EventDate.fromMap(map["eventDate"]);

  Map<String, dynamic> toMap(){
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['title'] = this.title;
    data['day'] = this.day;
    data['type'] = this.type;
    data['eventDate'] = this.eventDate.toMap();

    return data;
  }


  @override
  String toString() {
    return '"event" : {"title": $title, "day": $day, "type": $type, ${eventDate.toString()}}';
  }

}

class EventDate {
  late DateTime from;
  late DateTime to;

  EventDate({
    required this.from,
    required this.to,
  });

   EventDate.fromMap(Map<String, dynamic> map) {
    this.from = DateTime.parse(map['from']);
    this.to = DateTime.parse(map['to']);
   }

  Map<String, dynamic> toMap(){
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['from'] = myEncode(this.from);
    data['to'] = myEncode(this.to);
    return data;
  }

  String myEncode(DateTime item) {  
    return item.toIso8601String();
  }

  @override
  String toString() {
    return '"eventDate" : { "from": $from, "to": $to}';
  }
}