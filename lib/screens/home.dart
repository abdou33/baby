import 'package:baby/screens/mouvements_list.dart';
import 'package:baby/screens/vaccinations_list.dart';
import 'package:baby/widgets/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helper/ad_helper.dart';
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
  List vacc = [];
  List nextvacc = [" "];

  // TODO: Add _bannerAd
  BannerAd? _bannerAd;

  double? screenwidth = null;
  double? adheight = null;

  @override
  void initState() {
    getinfos();
    readJson();

    // TODO: Load a banner ad
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
            adheight = _bannerAd!.size.height.toDouble();
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: Dispose a BannerAd object
    _bannerAd?.dispose();

    super.dispose();
  }

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/db/vaccination.json');
    final data = await json.decode(response);
    setState(() {
      vacc = data["items"];
      for (int i = 0; i < vacc.length; i++) {
        if (vacc[i]["month"] >= years * 12 + months) {
          nextvacc[0] = vacc[i];
          print(nextvacc[0]);
          break;
        }
      }
      print(nextvacc);
    });
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
            drawer: MyDrawer(gender: gender!),
            backgroundColor:
                gender! == "male" ? Colors.blue[50] : Colors.pink[50],
            appBar: AppBar(
              backgroundColor:
                  gender! == "male" ? Colors.blue[100] : Colors.pink[100],
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: SizedBox(),
                      ),
                      const Text("عمر طفلك :",
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
                                    ? const SizedBox.shrink()
                                    : Text("$years سنوات",
                                        textDirection: TextDirection.rtl,
                                        style: const TextStyle(fontSize: 25))),
                            Container(
                                child: months <= 0
                                    ? const SizedBox.shrink()
                                    : Text("$months أشهر",
                                        textDirection: TextDirection.rtl,
                                        style: const TextStyle(fontSize: 25))),
                            Container(
                                child: days <= 0
                                    ? const SizedBox.shrink()
                                    : Text("$days أيام",
                                        textDirection: TextDirection.rtl,
                                        style: const TextStyle(fontSize: 25))),
                          ],
                        ),
                      )
                    ],
                  ),
                  // upcoming vaccinations
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: (() {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => FoodList(
                        //               monthsage: years * 12 + months,
                        //             )));
                      }),
                      child: Container(
                        width: width,
                        //height: width / 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 2,
                            color: Colors.black,
                          ),
                          image: const DecorationImage(
                              image: AssetImage("assets/vaccinations.png"),
                              fit: BoxFit.cover,
                              opacity: 0.45),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              width: 2,
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("التلقيح القادم",
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        backgroundColor: Colors.white)),
                                Text(
                                    "تلقيح " +
                                        nextvacc[0]["month"].toString() +
                                        " أشهر",
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),
                                ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(8),
                                    itemCount: nextvacc[0]["vaccs"].length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "\t" +
                                                  nextvacc[0]["vaccs"][index] +
                                                  "\n",
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Image.asset("assets/star.png",
                                              width: 20, height: 20),
                                        ],
                                      );
                                    }),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      VaccList()));
                                        },
                                        child: Text(
                                          "قائمة التلقيحات",
                                          style: TextStyle(
                                            color: Colors.deepPurple[600],
                                            fontSize: 15,
                                          ),
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
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
                            width: 2,
                            color: Colors.black,
                          ),
                          image: const DecorationImage(
                              image: AssetImage("assets/vegetables.jpg"),
                              fit: BoxFit.cover,
                              opacity: 0.4),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              width: 2,
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text("الأطعمة المسموحة",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    backgroundColor: Colors.white)),
                          ),
                        ),
                      ),
                      onTap: (() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FoodList(
                                      monthsage: years * 12 + months,
                                    )));
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
                            width: 2,
                          ),
                          image: const DecorationImage(
                              image: AssetImage("assets/dishes.jpeg"),
                              fit: BoxFit.cover,
                              opacity: 0.4),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              width: 2,
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text("أطباق مقترحة",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    backgroundColor: Colors.white)),
                          ),
                        ),
                      ),
                      onTap: (() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Disheslist(
                                      monthsage: years * 12 + months,
                                    )));
                      }),
                    ),
                  ),
                  //Mouvements
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      child: Container(
                        width: width,
                        height: width / 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 2,
                            color: Colors.black,
                          ),
                          image: const DecorationImage(
                              image: AssetImage("assets/mouvements.jpeg"),
                              fit: BoxFit.cover,
                              opacity: 0.4),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              width: 2,
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text("الحركات المتوقعة",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    backgroundColor: Colors.white)),
                          ),
                        ),
                      ),
                      onTap: (() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Mouvementslist(
                                      monthsage: years * 12 + months,
                                    )));
                      }),
                    ),
                  )
                ],
              ),
            ),
            bottomNavigationBar: SizedBox(
              height: adheight != null ? adheight : 0,
              child: // TODO: Display a banner when ready
                  _bannerAd != null
                      ? Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: width,
                            height: _bannerAd!.size.height.toDouble(),
                            child: AdWidget(ad: _bannerAd!),
                          ),
                        )
                      : SizedBox.shrink(),
            ),
          )
        : const Center(
            child: SizedBox(
                height: 100, width: 100, child: CircularProgressIndicator()));
  }
}
