import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../helper/ad_helper.dart';

class Dishscreen extends StatefulWidget {
  const Dishscreen(
      {super.key,
      required this.image,
      required this.name,
      required this.month,
      required this.ingrediants,
      required this.how,
      required this.benefits});

  final String image;
  final String name;
  final int month;
  final List<String> ingrediants;
  final List<String> how;
  final List<String> benefits;

  @override
  State<Dishscreen> createState() => _DishscreenState();
}

class _DishscreenState extends State<Dishscreen> {

  // TODO: Add _bannerAd
  BannerAd? _bannerAd;

  double? screenwidth = null;
  double? adheight = null;

  @override
  void initState() {
    super.initState();

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    border: Border.all(width: 4, color: Colors.black),
                    borderRadius: BorderRadius.circular(100), //<-- SEE HERE
                  ),
                  child: ClipOval(
                      child: SizedBox.fromSize(
                    size: Size.fromRadius(50),
                    child: Image.asset(
                      "${widget.image}",
                      fit: BoxFit.contain,
                    ),
                  )),
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("${widget.name}",
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        )),
                    Text(
                      " ${widget.month} أشهر",
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                )),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text("المكونات:",
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                )),
            Expanded(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.ingrediants.length,
                itemBuilder: (context, index) {
                  return Text(
                    widget.ingrediants[index],
                    textDirection: TextDirection.rtl,
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text("الكيفية:",
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                )),
            Expanded(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.how.length,
                itemBuilder: (context, index) {
                  return Text(
                    "- " + widget.how[index],
                    textDirection: TextDirection.rtl,
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text("الفوائد الصحية:",
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                )),
            Expanded(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.benefits.length,
                itemBuilder: (context, index) {
                  return Text(
                    widget.benefits[index],
                    textDirection: TextDirection.rtl,
                  );
                },
              ),
            ),
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
