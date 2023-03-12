import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Mouvementslist extends StatefulWidget {
  const Mouvementslist({super.key, required this.monthsage});

  final int monthsage;

  @override
  State<Mouvementslist> createState() => MouvementslistState(age: monthsage);
}

class MouvementslistState extends State<Mouvementslist> {
  final int age;
  MouvementslistState({required this.age});

  List _items = [];
  String searchresult = "";

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/db/mouvements.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["items"];
    });
  }

  @override
  void initState() {
    super.initState();
    // Call the readJson method when the app starts
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(1),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Text(
                "الحركات المتوقعة في عمر $age أشهر",
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Display the data loaded from sample.json
            _items.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return age == _items[index]["month"]
                            ? Card(
                                margin: const EdgeInsets.all(10),
                                child: ListTile(
                                  title: Container(
                                      width: 100,
                                      height: 100,
                                      child:
                                          Image.asset("assets/star.png")),
                                          //Image.asset(_items[index]["image"])),
                                  subtitle: Text(
                                    _items[index]["description"],
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                              )
                            : SizedBox.shrink();
                      },
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
