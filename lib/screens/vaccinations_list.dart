import 'dart:convert';

import 'package:baby/screens/dish_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VaccList extends StatefulWidget {
  const VaccList({
    super.key,
  });

  @override
  State<VaccList> createState() => _VaccListState();
}

class _VaccListState extends State<VaccList> {
  List _items = [];

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/db/vaccination.json');
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
            // Display the data loaded from sample.json
            _items.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            title: Text(
                              _items[index]["month"] > 24 ? (_items[index]["month"]/12).toInt().toString() + " سنوات" : _items[index]["month"].toString() + " أشهر",
                              textDirection: TextDirection.rtl,
                            ),
                            subtitle: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(8),
                                itemCount: _items[index]["vaccs"].length,
                                itemBuilder: (BuildContext context, int element) {
                                  return Text(
                                    "- " + _items[index]["vaccs"][element].toString(),
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }),
                          ),
                        );
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
