import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:task_app/data/app_color.dart';

class FullCalendarScreen extends StatelessWidget{

  final AppColor _wrn = new AppColor();

  @override
  Widget build(BuildContext context){
    return Container(
      margin: const EdgeInsets.all(8),
      child: SfCalendar(
        backgroundColor: _wrn.background,
        headerStyle: CalendarHeaderStyle(
          textAlign: TextAlign.center
        ),
        view: CalendarView.month,
        initialSelectedDate: DateTime.now(),
        cellBorderColor: Colors.transparent,
      ),
    );
  }
}