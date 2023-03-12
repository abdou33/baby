import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../helper/ad_helper.dart';

class FoodList extends StatefulWidget {
  final int monthsage;
  const FoodList({super.key, required this.monthsage});

  @override
  State<FoodList> createState() => _FoodListState(age: monthsage);
}

class _FoodListState extends State<FoodList> {
  final int age;
  _FoodListState({required this.age});

  bool _searchBoolean = false; //add
  String searchresult = "";

  List _items = [];

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/db/food.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["items"];
    });
  }
  // TODO: Add _bannerAd
  BannerAd? _bannerAd;

  double? screenwidth = null;
  double? adheight = null;

  @override
  void initState() {
    super.initState();
    // Call the readJson method when the app starts
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
  }


  @override
  void dispose() {
    // TODO: Dispose a BannerAd object
    _bannerAd?.dispose();

    super.dispose();
  }

  Widget _searchTextField() {
    //add
    return TextField(
      onChanged: (Text) {
        setState(() {
          searchresult = Text;
        });
      },
      textAlign: TextAlign.right,
      autofocus: true,
      cursorColor: Colors.white,
      textDirection: TextDirection.rtl,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration.collapsed(
        hintText: 'بحث',
        hintTextDirection: TextDirection.rtl,
        hintStyle: TextStyle(
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
    );
  }

  int searchresults = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !_searchBoolean ? Text("") : _searchTextField(),
        actions: [
          // Navigate to the Search Screen
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _searchBoolean
                      ? _searchBoolean = false
                      : _searchBoolean = true;
                });
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(1),
        child: Column(
          children: [
            // Display the data loaded from sample.json
            _items.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return _items[index]["name"].contains(searchresult)
                            ? Card(
                                margin: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    ListTile(
                                  leading: Image.asset(
                                    width: 50,
                                      age < _items[index]["minmonth"]
                                          ? "assets/wrong.png"
                                          : "assets/right.png"),
                                  trailing: Image.asset(_items[index]["image"], width: 50,),
                                  title: Text(
                                    _items[index]["name"],
                                    textDirection: TextDirection.rtl,
                                  ),
                                  subtitle: age < _items[index]["minmonth"]
                                            ? Column(
                                                children: [
                                                  Text(
                                                    "بدءا من " +
                                                        _items[index]
                                                                ["minmonth"]
                                                            .toString() +
                                                        " أشهر \n",
                                          textDirection: TextDirection.rtl,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              )
                                            : Column(
                                                children: [
                                                  Text(
                                                    "بدءا من " +
                                                        _items[index]
                                                                ["minmonth"]
                                                            .toString() +
                                                        " أشهر \n",
                                          textDirection: TextDirection.rtl,
                                                    style: TextStyle(
                                                        color: Colors.black
                                          ),
                                                  ),
                                                ],
                                              )),
                                    Container(
                                      child: age < _items[index]["minmonth"]
                                          ? Text(
                                              _items[index]["less"],
                                              textDirection: TextDirection.rtl,
                                            )
                                          : Text(
                                              _items[index]["more"],
                                              textDirection: TextDirection.rtl,
                                            ),
                                    )
                                  ],
                                )
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                  )
                : Container()
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
                            width:  _bannerAd!.size.width.toDouble(),
                            height: _bannerAd!.size.height.toDouble(),
                            child: AdWidget(ad: _bannerAd!),
                          ),
                        )
                      : SizedBox.shrink(),
            ),
    );
  }
}
