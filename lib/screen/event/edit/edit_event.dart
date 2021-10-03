import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:task_app/data/event.dart';
import 'package:task_app/resources/utils/utils.dart';
import 'package:task_app/resources/header/resources_widget.dart';

class EditEvent extends StatefulWidget{

  final String day;
  final List<Event> listEvent;

  EditEvent({required this.listEvent, required this.day});

  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {

  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    initSharedPreferences();
    super.initState();
  }

  void initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: appBarCustomize(context, "Edit", false, "", null),
      body: buildView(),
    );
  }

  Widget buildView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          buildShowDay(),
          buildCardList(),
        ],
      ),
    );
  }

  Widget buildShowDay() {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(
          bottom: 28
        ),
        child: Text(
          widget.day,
        ),
      ),
    );
  }

  Widget buildCardList() {
    return Column(
      children: widget.listEvent.map((event) {
        if (event.day == widget.day) {
          event = event;
        }
        return buildCard(event);
      }).toList(),
    );
  }

  Widget buildCard(Event event) {
    return Card(
      child: event.day == widget.day ? Dismissible(
        key: Key('${event.hashCode}'),
        background: Container(
          color: Colors.red[700],
          child: Row(
            children: [
              Icon(Icons.double_arrow, size: 20),
              Text(
                'Swipe to delete',
              ),
            ],
          ),  
        ),
        onDismissed: (direction) {
          setState(() {
            removeItem(event);
          });
        },
        direction: DismissDirection.startToEnd,
        child: buildListTile(event, 10, 10),
      ) : Container(),
    );
  }

  removeItem(Event event) {
    widget.listEvent.remove(event);

    Utils.saveData(widget.listEvent, sharedPreferences, 'event');
  }
}
