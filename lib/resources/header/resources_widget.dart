import 'package:flutter/material.dart';

import 'package:task_app/data/app_color.dart';
import 'package:task_app/data/event.dart';
import 'package:task_app/resources/utils/utils.dart';

AppColor _wrn = new AppColor();

// ---------------------------------
//
// CUSTOMIZED ADD EVENT HEADER
//
//
PreferredSizeWidget? appBarCustomize(var context, String textHeader, bool haveAction, String actionHeader, var action) {
  return AppBar(
    leading: backButton(context),
    title: headerText(textHeader),
    actions: haveAction ? actionButton(actionHeader, action) : null,
  );
}

Widget backButton(context) {
  return IconButton(
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
    }, 
    icon: Icon(
      Icons.arrow_back,
      color: Colors.red,
    ),
  );
}

Widget headerText(String text) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 18,
    ),
  );
}

List<Widget> actionButton(String text, var action) {
  return [
    ElevatedButton.icon(
      onPressed: action, 
      icon: Icon(Icons.done), 
      label: Text(text),
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
    ),
  ];
}

Future<DateTime?> pickDateTime(
  var context, DateTime initialDate, {
  required bool pickDate,
  DateTime? firstDate
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context, 
        initialDate: initialDate, 
        firstDate: firstDate ?? DateTime(2015, 8), 
        lastDate: DateTime(2101),
      );

      if (date == null) return null;

      final time = Duration(
        hours: initialDate.hour,
        minutes: initialDate.minute,
      );

      return date.add(time);
    }

    else {
      final timeOfDay = await showTimePicker(
        context: context, 
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (timeOfDay == null) return null;

      final date = DateTime(
        initialDate.year, initialDate.month, initialDate.day
      );
      final time = Duration(
        hours: timeOfDay.hour,
        minutes: timeOfDay.minute,
      );

      return date.add(time);
    }
}

//
//
// END OF CUSTOMIZED ADD EVENT HEADER
//
// ---------------------------------





// ---------------------------------
//
// CUSTOMIZED MAIN AND EDIT LIST TILE
//
//

Widget buildListTile(Event event, double leftPadding, double rightPadding) {
  return ListTile(
    contentPadding: EdgeInsets.only(
      left: leftPadding,
      right: rightPadding,
      top: 5,
      bottom: 5
    ),
    leading: buildListTileIcon(event),
    title: buildListTileTitle(event),
    trailing: event.type == 'homework' ? null : event.type == 'activity' ? buildListTileDateActivity(event) : buildListTileDateSchedule(event),
  );
}

Widget buildListTileIcon(Event event) {
  String eventType = event.type;
  Icon icons;
  if (eventType == 'activity') {
    icons = Icon(Icons.local_activity);
  } else if (eventType == 'schedule') {
    icons = Icon(Icons.school);
  } else {
    icons = Icon(Icons.book);
  }
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      icons,
      Container(height: 20, child: VerticalDivider(color: _wrn.text)),
    ],
  ); 
}

Widget buildListTileDateActivity(Event event) {
  String eventDateFromDate = Utils.toDate2(event.eventDate.from);
  String eventDateToDate = Utils.toDate2(event.eventDate.to);
  String eventDateFromTime = Utils.toTime(event.eventDate.from);
  String eventDateToTime = Utils.toTime(event.eventDate.to);

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        (eventDateFromDate + " - " + eventDateToDate),
        style: TextStyle(
          color: _wrn.text,
          fontSize: 14,
        ),
      ),
      Text(
        (eventDateFromTime + " - " + eventDateToTime),
        style: TextStyle(
          color: _wrn.text,
          fontSize: 14,
        ),
      ),
    ],
  );
}

Widget buildListTileDateSchedule(Event event) {
  String eventDateFromTime = Utils.toTime(event.eventDate.from);
  String eventDateToTime = Utils.toTime(event.eventDate.to);

  return Text(
    (eventDateFromTime + " - " + eventDateToTime),
    style: TextStyle(
      color: _wrn.text,
      fontSize: 16,
    ),
  );
}

Widget buildListTileTitle(Event event) {
  return RichText(
    overflow: TextOverflow.ellipsis,
    strutStyle: StrutStyle(fontSize: 14.0),
    text: TextSpan(
        style: TextStyle(color: _wrn.text),
        text: event.title),
  );   
}

//
//
// END OF CUSTOMIZED MAIN AND EDIT LIST TILE
//
// ---------------------------------
