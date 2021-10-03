import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/data/event.dart';
import 'package:task_app/resources/utils/utils.dart';
import 'package:task_app/resources/header/resources_widget.dart';

class AddEventHomework extends StatefulWidget{

  final Event? event;
  final List<Event> listEvent;

  const AddEventHomework({
    Key? key,
    this.event,
    required this.listEvent
  }) : super(key: key);

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEventHomework> {

  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
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
      toDate = DateTime.now();
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
              buildDay(),
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



  Widget buildDay() {
    return DropdownButton(
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
      hint:Text("Select item")
    );
  }
  
  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      
      addData(Event(
        title: titleController.text,
        day: _dayValue,
        type: 'homework',
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