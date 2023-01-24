import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Disheslist extends StatefulWidget {
  const Disheslist({super.key, required this.monthsage});

  final int monthsage;

  @override
  State<Disheslist> createState() => _DisheslistState(age: monthsage);
}

class _DisheslistState extends State<Disheslist> {
  final int age;
  _DisheslistState({required this.age});

  List _items = [];
  bool _searchBoolean = false; //add
  String searchresult = "";

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/db/dishes.json');
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
                        return _items[index]["name"].contains(searchresult) ? GestureDetector(
                          onTap: () {
                            //Navigator.push(context,MaterialPageRoute(builder: (context) => FoodList(name: _items[index]["name"],
                            //image: _items[index]["image"], minmonth: _items[index]["minmonth"], how: _items[index]["how"])));
                          },
                          child: Card(
                              margin: const EdgeInsets.all(10),
                              child: ListTile(
                                trailing: Image.asset(_items[index]["image"]),
                                title: Text(
                                  _items[index]["name"],
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                            ),
                        ) : Container();
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
