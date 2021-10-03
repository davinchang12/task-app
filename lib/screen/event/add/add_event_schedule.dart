import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/data/event.dart';
import 'package:task_app/resources/utils/utils.dart';
import 'package:task_app/resources/header/resources_widget.dart';

class AddEventSchedule extends StatefulWidget{

  final Event? event;
  final List<Event> listEvent;

  const AddEventSchedule({
    Key? key,
    this.event,
    required this.listEvent
  }) : super(key: key);

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEventSchedule> {

  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  DateTime now = DateTime.now();
  late DateTime fromDate;
  late DateTime toDate;
  late SharedPreferences sharedPreferences;
  late String _dayValue;

  @override
  void initState(){
    initSharedPreferences();
    super.initState();

    if(widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
      _dayValue = Utils.toDay(fromDate);
    }
  }

  void initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void dispose(){
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: appBarCustomize(context, "Add Schedule", true, "Save", saveForm),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTitle(),
              SizedBox(height: 50,),
              buildDayPicker(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget buildTitle() {
    return TextFormField(
      style: TextStyle(fontSize: 22),
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        hintText: 'Tambahkan Judul',
      ),
      onFieldSubmitted: (_) => saveForm(),
      validator: (title) =>
        title != null && title.isEmpty ? 'Title cannot be empty' : null,
      controller: titleController,
    );
  }

  Widget buildDayPicker() {
    return Column(
      children: [
        buildRowDay(text: 'Select day', widget: buildDay()),
        buildRowDay(text: 'Select time from', widget: buildTimeFrom()),
        buildRowDay(text: 'Select time to', widget: buildTimeTo()),
      ],
    );
  }

  Widget buildRowDay({required String text, required Widget widget}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(text)
        ),
        Expanded(
          child: widget,
        ),
      ],
    );
  }

  Widget buildDay() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 5
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          items: <String>['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'].map((String day) {
            return DropdownMenuItem<String>(
              value: day,
              child: new Text(day),
            );
          }).toList(),
            
          value: _dayValue,
          onChanged: (String? value) {
            setState(() {
              _dayValue = value!;
            });
          },
          hint:Text("Select day")
        ),
      ),
    );
  }
  
  Widget buildTimeFrom() {
      return buildDropDownField(
        text: Utils.toTime(fromDate),
        onClicked: () => pickFromDateTime(pickDate: false),
    );
  }

  Widget buildTimeTo() {
    return buildDropDownField(
      text: Utils.toTime(toDate),
      onClicked: () => pickToDateTime(pickDate: false),
    );
  }

  Widget buildHeader({required String header, required Row child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(header),
        child,
      ],
    );
  }

  Widget buildDropDownField({required String text, required Function() onClicked}) {
    return ListTile(
      title: Text(text),
      trailing: Icon(Icons.arrow_drop_down),
      onTap: onClicked,
    );
  }

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(
      context, fromDate,
      pickDate: pickDate
    );

    if (date == null) return;

    if (date.isAfter(toDate)){
      toDate = DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }

    setState(() => fromDate = date);
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(
      context, toDate, 
      pickDate: pickDate,
      firstDate: pickDate ? fromDate : null,
    );

    if (date == null) return;

    setState(() => toDate = date);
  }

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      
      addData(Event(
        title: titleController.text,
        day: _dayValue,
        type: 'schedule',
        eventDate: EventDate(
          from: fromDate,
          to: toDate,
        ),
      ));
      
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  addData(Event event) {
    widget.listEvent.add(event);

    Utils.saveData(widget.listEvent, sharedPreferences, 'event');
  }
}