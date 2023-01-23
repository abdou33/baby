import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? gender = null;
  int? dateinms = 0;
  int years = 0;
  int months = 0;
  int days = 0;

  @override
  void initState() {
    getinfos();
    super.initState();
  }

  getinfos() async {
    final prefs = await SharedPreferences.getInstance();
    dateinms = prefs.getInt('date');
    gender = prefs.getString('gender');

    setState(() {
      toymd(dateinms);
    });
  }

  toymd(int? val1) {
    int timenow = DateTime.now().millisecondsSinceEpoch;
    int val = timenow - val1!;
    years = (val / 31536000000).toInt();
    print(years.toString() + "years");
    months = ((val - (years * 31536000000)) / 2592000000).toInt();
    print(months.toString() + "months");
    days = (((val - (years * 31536000000)) - (months * 2592000000)) / 86400000)
        .toInt();
    print(days.toString() + "days");
  }

  @override
  Widget build(BuildContext context) {
    return gender != null ? Scaffold(
      backgroundColor: gender! == "male" ? Colors.blue[50] :Colors.pink[50],
      appBar: AppBar(
        backgroundColor: gender! == "male" ? Colors.blue[100] :Colors.pink[100],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: SizedBox(),),
              Text("عمر طفلك :", textDirection: TextDirection.rtl, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(child: years <= 0 ? Text( "" ) : Text("$years سنوات", textDirection: TextDirection.rtl, style: TextStyle(fontSize: 25))),
                    Container(child: months <= 0 ? Text( "" ) : Text("$months أشهر", textDirection: TextDirection.rtl, style: TextStyle(fontSize: 25))),
                    Container(child: days <= 0 ? Text( "" ) : Text("$days أيام", textDirection: TextDirection.rtl, style: TextStyle(fontSize: 25))),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    )
    : Center(child: SizedBox(height: 100, width: 100 ,child: CircularProgressIndicator()));
  }
}
