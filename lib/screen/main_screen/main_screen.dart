import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:task_app/data/app_color.dart';
import 'package:task_app/data/event.dart';
import 'package:task_app/resources/header/resources_widget.dart';
import 'package:task_app/screen/event/edit/edit_event.dart';
import 'package:task_app/resources/utils/utils.dart';
import 'package:task_app/screen/navigation/base_screen.dart';

// ignore: must_be_immutable
class MainScreen extends StatefulWidget{

  List<Event> listEvent;
  Map<String, List<Event>> eventGroup;

  MainScreen({required this.listEvent, required this.eventGroup});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  AppColor _wrn = new AppColor();
  String todayDay = DateFormat('EEEE').format(DateTime.now());

  late SharedPreferences sharedPreferences;
  String key = 'event';

  @override
  void initState() {
    initSharedPreferences();
    super.initState();
  }

  void initSharedPreferences() async {
    sharedPreferences = await getSPInstance();
  }

  Future<SharedPreferences> getSPInstance() async {
    return SharedPreferences.getInstance();
  }
  
  @override
  Widget build(BuildContext context){
    double screenWidth = MediaQuery.of(context).size.width;
    return widget.eventGroup.isEmpty ? emptyView() : buildListView(screenWidth);
  }

  Widget emptyView() {
    return Center(
      child: Text(
        "Belum ada Jadwal",
        style: TextStyle(
          color: _wrn.text,
        ),
      ),
    );
  }

  Widget buildListView(double screenWidth) {
    return ListView.builder(
      itemCount: widget.eventGroup.length,
      itemBuilder: (context, index){

        final String _dataValues = widget.eventGroup.keys.elementAt(index);
        List<Event>? _data = widget.eventGroup[_dataValues];

        return buildInkWell(_dataValues, _data, screenWidth);
      },
    );
  }

  Widget buildInkWell(String _dataValues, List<Event>? _data, double screenWidth) {
    return InkWell(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          decoration: _dataValues == todayDay ? 
            BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(0, 10),
                  blurRadius: 5,
                  spreadRadius: 5
                ),
              ]
            ) 
            : 
            null,
          margin: const EdgeInsets.only(
            top: 32,
          ),
          width: screenWidth - (screenWidth * 0.12),
          child: buildCard(_dataValues, (_dataValues == todayDay), _data),
        ),
      ),
    );
  }

  Widget buildCard(String _dataValues, bool today, List<Event>? _data) {
    
    return Card(
      color: _wrn.item,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeaderCard(_dataValues, today),
            
            Divider(color: _wrn.text,),
            SizedBox(height: 8,),

            Column(
              children:[
                checkType(_data!, 'schedule') ?
                Text('Schedule') : Container(),
                buildItemType(_data, 'schedule'),
                
                checkType(_data, 'schedule') ?
                SizedBox(height:12) : SizedBox(),

                checkType(_data, 'homework') ?
                Text('Homework') : Container(),
                buildItemType(_data, 'homework'),

                checkType(_data, 'homework') ?
                SizedBox(height:12) : SizedBox(),

                checkType(_data, 'activity') ?
                Text('Activity') : Container(),
                buildItemType(_data, 'activity'),
              ]
            ),
            SizedBox(height: 14,),
          ],
        ),
      ),
    );
  }

  Widget buildHeaderCard(String _dataValues, bool today) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildHeaderDay(_dataValues, today),
        buildHeaderEditButton(_dataValues)
      ],
    );
  }

  Widget buildHeaderDay(String _dataValues, bool today) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        _dataValues + (today ? ' (Today)' : ''),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget buildHeaderEditButton(String _dataValues) {
    return IconButton(
      onPressed: () {
        Navigator.push(context, Utils.createRoute(EditEvent(
            listEvent: widget.listEvent, 
            day: _dataValues,
          ))).then(updateBackPage);
      }, 
      icon: Icon(Icons.edit),
      iconSize: 20,
      padding: const EdgeInsets.all(0),
    );
  }

  Widget buildItemType(List<Event> _data, String type) {
    return Column(
      children: _data.map((event) { 
        if (event.type == type) {
          return buildListTile(event, 2, 2);
        } else {
          return Container();
        }
      }).toList(),
    );
  }

   FutureOr updateBackPage(dynamic value) {
      setState(() {
        Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => BaseScreen(),
        transitionDuration: Duration(seconds: 0),
        ));
      });
   }

   bool checkType(List<Event> _data, String type) {
      var checkData = _data.where((event) => event.type.contains(type));
      return checkData.length >= 1 ? true : false;
   }
}