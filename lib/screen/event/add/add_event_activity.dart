import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/data/event.dart';
import 'package:task_app/resources/utils/utils.dart';
import 'package:task_app/resources/header/resources_widget.dart';

class AddEventActivity extends StatefulWidget{

  final Event? event;
  final List<Event> listEvent;

  const AddEventActivity({
    
    Key? key,
    this.event,
    required this.listEvent
  }) : super(key: key);

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEventActivity> {

  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;
  late SharedPreferences sharedPreferences;

  @override
  void initState(){
    initSharedPreferences();
    super.initState();

    if(widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
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
      appBar: appBarCustomize(context, "Add Activity", true, "Save", saveForm),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTitle(),
              SizedBox(height: 50,),
              buildDateTimePickers(),
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

  Widget buildDateTimePickers() {
      return Column(
      children: [
        buildFrom(),
        buildTo(),
      ],
    );
  }

  Widget buildFrom() {
      return buildHeader(
      header: 'From',
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: buildDropDownField(
              text: Utils.toDate(fromDate),
              onClicked: () => pickFromDateTime(pickDate: true),
            ),
          ),
          SizedBox(width: 20,),
          Expanded(
            child: buildDropDownField(
              text: Utils.toTime(fromDate),
              onClicked: () => pickFromDateTime(pickDate: false),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTo() {
    return buildHeader(
      header: 'To',
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: buildDropDownField(
              text: Utils.toDate(toDate),
              onClicked: () => pickToDateTime(pickDate: true),
            ),
          ),
          SizedBox(width: 20,),
          Expanded(
            child: buildDropDownField(
              text: Utils.toTime(toDate),
              onClicked: () => pickToDateTime(pickDate: false),
            ),
          ),
        ],
      ),
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
      dense:true,
      contentPadding: EdgeInsets.only(left: 4.0, right: 4.0),
      title: Text(text),
      trailing: Icon(Icons.arrow_drop_down),
      onTap: onClicked,
    );
  }

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(
      fromDate, 
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
      toDate, 
      pickDate: pickDate,
      firstDate: pickDate ? fromDate : null,
    );

    if (date == null) return;

    setState(() => toDate = date);
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
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

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      
      addData(Event(
        title: titleController.text,
        day: Utils.toDay(fromDate),
        type: 'activity',
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