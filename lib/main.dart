import 'package:baby/screens/first_time_swipes.dart';
import 'package:baby/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool firsttime = false;
  bool doneloading = false;

  String? g = "";
  int? d = 0;

  @override
  void initState() {
    first();
    super.initState();
  }

  first() async {
    final prefs = await SharedPreferences.getInstance();
    d = prefs.getInt('date');
    g = prefs.getString('gender');

    setState(() {
    print("$d + $g");
      if (d != 0 && d != null && g != "" && g != null) {
        doneloading = true;
        firsttime = false;
      } else if (d == null) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Vazirmatn', appBarTheme: AppBarTheme(backgroundColor: g == "male" ? Colors.blue[100] : Colors.pink[100]), scaffoldBackgroundColor: g! == "male" ? Colors.blue[50] : Colors.pink[50], cardColor: g == "male" ? Colors.blue[100] : Colors.pink[100]),
      home: doneloading
          ? firsttime
              ? Swipe()
              : Home()
          : CircularProgressIndicator(),
    );
  }
}
