import 'dart:collection';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/data/event.dart';

class Utils{

  // Convert DateTime format into String Date Time
  static String toDateTime(DateTime dateTime){
    final date = DateFormat.yMMMEd().format(dateTime);
    final time = DateFormat.Hm().format(dateTime);

    return '$date $time';
  }
  
  // Convert DateTime format into Date
  // RETURN : Type ( STRING )
  static String toDate(DateTime dateTime){
    final date = DateFormat.yMMMEd().format(dateTime);

    return '$date';
  }

  static String toDate2(DateTime dateTime){
    final date = DateFormat.MMMd().format(dateTime);

    return '$date';
  }

  // Convert DateTime format into Time
  // RETURN : Type ( STRING )
  static String toTime(DateTime dateTime){
    final time = DateFormat.Hm().format(dateTime);

    return '$time';
  }

  // Convert DateTime format into Day
  // RETURN : Type ( STRING )
  static String toDay(DateTime dateTime){
    final day = DateFormat('EEEE').format(dateTime);

    return '$day';
  }

  // Save data into Shared Preferences
  static void saveData(List<Event> listEvent, SharedPreferences sharedPreferences, String key) {
    List<String> list = listEvent.map((items) => jsonEncode(items.toMap())).toList();  
    sharedPreferences.setStringList(key, list);
  }


  // Load data from Shared Preferences
  // RETURN : Type ( LIST )
  static List<Event> loadDataList(SharedPreferences sharedPreferences, String key) {
    List<Event> listEvent = [];
    if (sharedPreferences.containsKey(key)) {
      sharedPreferences.reload();
      final List<String>? spStr = sharedPreferences.getStringList('event');

      if (spStr != null){
        listEvent = spStr.map((item) => Event.fromMap(jsonDecode(item))).toList();
      }
      return listEvent;
    }
    return listEvent;
  }

  // Load data from Shared Preferences
  // RETURN : Type ( MAP )
  static Map<String, List<Event>> loadDataGroup(SharedPreferences sharedPreferences, String key) {
    Map<String, List<Event>> eventGroup = new Map<String, List<Event>>();

    if (sharedPreferences.containsKey(key)) {
      sharedPreferences.reload();
      final List<String>? spStr = sharedPreferences.getStringList('event');

      if (spStr != null){
        List<Event> listEvent = spStr.map((item) => Event.fromMap(jsonDecode(item))).toList();
        eventGroup = groupBy(
          listEvent,
          (x) => extractDay(x.day),
        );

        for(var day in eventGroup.entries) {
          List<Event> temp = day.value;
          for (var _ in day.value) {
            int i = 0;
            for (var _ in day.value) {
              if(temp.length-1 > i) {
                int check = temp[i].eventDate.from.compareTo(temp[i+1].eventDate.from);
                if (check == 1) {
                  var tmp = temp[i+1];
                  temp[i+1] = temp[i];
                  temp[i] = tmp;
                }
                i++;
              }
            }
          }
          eventGroup[day.key] = temp;
        }
      }
      return eventGroup;
    }
    return eventGroup;
  }

  // Get Day data from list
  // RETURN : Type ( STRING )
  static String extractDay(String day) {
    return '$day';
  }

  // Regrouping List into Map
  // RETURN : Type ( MAP )
  static Map<T, List<S>> groupBy<S, T>(Iterable<S> values, T Function(S) key) {
    var map = <T, List<S>>{};
    for (var element in values) {
      (map[key(element)] ??= []).add(element);
    }
    return map;
  }

  static Map<String, List<Event>> loadDataGroupSorted(SharedPreferences sharedPreferences, String key) {
    const dayAbbreviationToValue = {
      'Monday': DateTime.monday,
      'Tuesday': DateTime.tuesday,
      'Wednesday': DateTime.wednesday,
      'Thursday': DateTime.thursday,
      'Friday': DateTime.friday,
      'Saturday': DateTime.saturday,
      'Sunday': DateTime.sunday,
    };

    return SplayTreeMap.of(
        loadDataGroup(sharedPreferences, key),
        (key1, key2) => dayAbbreviationToValue[key1]!
            .compareTo(dayAbbreviationToValue[key2]!));
  }


  // Add animation on change page
  // RETURN : Type ( ROUTE ( WIDGET ) )
  static Route createRoute(var destination) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => destination,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}