import 'package:baby/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:select_card/select_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Borndate extends StatefulWidget {
  const Borndate({super.key});

  @override
  State<Borndate> createState() => _BorndateState();
}

class _BorndateState extends State<Borndate> {
  List<String> titles = ["little boy", "little girl"];
  final List<String> ids = ["M", "F"];
  final List<String> imagesFromAsset = <String>[
    'assets/babyboy.png',
    'assets/babygirl.png'
  ];

  String gender = "";

  register_infos(String gender, int date) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('date', date);

    String g = gender == "little boy" ? "male" : "female";
    await prefs.setString('gender', g);
    print("done");
    if(prefs.getInt('date') != null && prefs.getString('gender') != null){
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Home()));
    }
  }

  DateTime? _selectedDate = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "متى ولد طفلك",
            style: TextStyle(fontSize: 28, fontFamily: "Vazirmatn"),
          ),
          SizedBox(
            height: 20,
          ),
          DatePickerWidget(
            looping: false, // default is not looping
            firstDate: new DateTime(DateTime.now().year - 2,
                DateTime.now().month, DateTime.now().day),
            lastDate: DateTime.now(),
            initialDate: new DateTime(DateTime.now().year, 1, 1),
            dateFormat: "dd-MMM-yyyy",
            locale: DatePicker.localeFromString('en'),
            onChange: (DateTime newDate, _) => _selectedDate = newDate,
            pickerTheme: DateTimePickerTheme(
              backgroundColor: Color(0x000),
              itemTextStyle: TextStyle(color: Colors.black, fontSize: 19),
              dividerColor: Colors.black,
            ),
          ),
          SizedBox(
            height: 20,
          ),

          //choose M or F cards
          Padding(
            padding: const EdgeInsets.only(left: 70),
            child: SelectGroupCard(context,
                titles: titles,
                imageSourceType: ImageSourceType.asset,
                images: imagesFromAsset,
                cardBackgroundColor: Color.fromARGB(255, 160, 195, 210),
                cardSelectedColor: Color.fromARGB(255, 0, 0, 0),
                titleTextColor: Colors.blue.shade900,
                contentTextColor: Colors.black87, onTap: (title) {
              setState(() {
                gender = title;
              });
            }),
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(
                  Color.fromARGB(255, 216, 81, 126)),
            ),
            onPressed: () {
              if (_selectedDate == null || gender == "") {
                print("please change the date or check gender");
              } else {
                print(_selectedDate!.millisecondsSinceEpoch.toString() +
                    "" +
                    gender);
                register_infos(gender, _selectedDate!.millisecondsSinceEpoch);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "حفظ",
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
          )
        ],
      ),
    );
  }
}
