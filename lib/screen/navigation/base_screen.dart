import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:task_app/data/app_color.dart';
import 'package:task_app/data/event.dart';
import 'package:task_app/resources/utils/utils.dart';
import 'package:task_app/screen/event/add/add_event_activity.dart';
import 'package:task_app/screen/event/add/add_event_homework.dart';
import 'package:task_app/screen/event/add/add_event_schedule.dart';
import 'package:task_app/screen/calendar/full_calendar_screen.dart';
import 'package:task_app/screen/main_screen/main_screen.dart';

class BaseScreen extends StatefulWidget{

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {

  int selectedIndex = 0;
  String key = 'event';
  AppColor _wrn = new AppColor();
  bool isLoading = true;

  
  late PageController _pageController;
  late SharedPreferences sharedPreferences;
  
  late List<Event> listEvent = [];
  Map<String, List<Event>> eventGroup = new Map<String, List<Event>>();


  @override
  void initState() {
    initSharedPreferences();
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Get shared preferences data
  void initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.containsKey(key)){
      listEvent = Utils.loadDataList(sharedPreferences, key);
      eventGroup = Utils.loadDataGroupSorted(sharedPreferences, key);
  }


    setState(() {
      isLoading = false;
    });
  }

  // Selected / Pressed Bottom Navigation Bar
  void selectedNavBar(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea( 
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          children: [
            isLoading ? loadingView() : MainScreen(listEvent: listEvent, eventGroup: eventGroup,),
            // isLoading ? loadingView() : FullCalendarScreen(),
            isLoading ? loadingView() : Center(child: Text('Under Maintenance'),),
          ],
        ),
      ),
      
      floatingActionButton: middleButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: navButton(),
    );
  }

  Widget loadingView() {
    return Center(
      child: Text(
        "Loading...",
        style: TextStyle(
          color: _wrn.text,
        ),
      ),
    );
  }

  Widget middleButton() {
    return FloatingActionButton(
      backgroundColor: _wrn.tombol,
      onPressed: () {
        buildDialogAdd();
      },
      child: Icon(
        Icons.add,
        color: _wrn.text,
      ),
      elevation: 4.0,
    );
  }

  Widget navButton() {
    return BottomNavigationBar(
      backgroundColor: _wrn.navigator,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (int index) {
        setState(() {
          selectedIndex = index;
          _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
        });        
      },
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: selectedIndex == 0 ? Colors.white : Color(0xFFCAD2C5), 
          ),
          label: 'Home',
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.calendar_today,
            color: selectedIndex == 1 ? Colors.white : Color(0xFFCAD2C5), 
          ),
          label: 'Calendar',
        )
      ],
    );
  }

  Future<String?> buildDialogAdd() {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        var dialogContext = context;
        return AlertDialog(
          title: const Text('Add Type', textAlign: TextAlign.center),
          content: Container(
            height: 200,
            child: Column(
              children: [
                Divider(color: _wrn.text,),
                
                SizedBox(height: 16,),
                buildTextButton(AddEventActivity(listEvent: listEvent,), "Add Activity", dialogContext),
                SizedBox(height: 16,),
                buildTextButton(AddEventSchedule(listEvent: listEvent,), "Add Schedule", dialogContext),
                SizedBox(height: 16,),
                buildTextButton(AddEventHomework(listEvent: listEvent,), "Add Homework", dialogContext),
              
              ],
            ),
          ),
        );
      }
    );
  }

  Widget buildTextButton(var destination, String text, var dialogContext) {
    return TextButton(
      onPressed: () {
        Navigator.push(context, Utils.createRoute(destination)).then((value) => setState((){
          eventGroup = Utils.loadDataGroup(sharedPreferences, key);
          Navigator.of(dialogContext, rootNavigator: true).pop();
        }));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "(+)",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),

          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}