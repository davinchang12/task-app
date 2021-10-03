import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:task_app/screen/navigation/base_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF2F3E46),
        canvasColor:  Color(0xFF2F3E46),
        accentColor: Color(0xFFCAD2C5),
      ),
      home: BaseScreen(),
    );
  }
}