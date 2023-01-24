import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dishes_list.dart';
import 'food_list.dart';

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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return gender != null
        ? Scaffold(
          drawer: Drawer(),
            backgroundColor:
                gender! == "male" ? Colors.blue[50] : Colors.pink[50],
            appBar: AppBar(
              backgroundColor:
                  gender! == "male" ? Colors.blue[100] : Colors.pink[100],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(),
                    ),
                    Text("عمر طفلك :",
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
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
                          Container(
                              child: years <= 0
                                  ? Text("")
                                  : Text("$years سنوات",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(fontSize: 25))),
                          Container(
                              child: months <= 0
                                  ? Text("")
                                  : Text("$months أشهر",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(fontSize: 25))),
                          Container(
                              child: days <= 0
                                  ? Text("")
                                  : Text("$days أيام",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(fontSize: 25))),
                        ],
                      ),
                    )
                  ],
                ),
                //food
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    child: Container(
                      width: width,
                      height: width / 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.black,
                        ),
                        image: DecorationImage(
                          image: AssetImage("assets/vegetables.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text("الأطعمة المسموحة",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                backgroundColor: Colors.white)),
                      ),
                    ),
                    onTap: (() {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => FoodList(monthsage: years*12+months,)));
                    }),
                  ),
                ),
                //dishes
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    child: Container(
                      width: width,
                      height: width / 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.black,
                        ),
                        image: DecorationImage(
                          image: AssetImage("assets/dishes.jpeg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text("أطباق مقترحة",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                backgroundColor: Colors.white)),
                      ),
                    ),
                    onTap: (() {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => Disheslist(monthsage: years*12+months,)));
                    }),
                  ),
                )
              ],
            ),
          )
        : Center(
            child: SizedBox(
                height: 100, width: 100, child: CircularProgressIndicator()));
  }
}
