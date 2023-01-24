import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                        return _items[index]["name"].contains(searchresult) ? Card(
                            margin: const EdgeInsets.all(10),
                            child: ListTile(
                              leading: Image.asset(
                                  age < _items[index]["minmonth"]
                                      ? "assets/wrong.png"
                                      : "assets/right.png"),
                              trailing: Image.asset(_items[index]["image"]),
                              title: Text(
                                _items[index]["name"],
                                textDirection: TextDirection.rtl,
                              ),
                              subtitle: age < _items[index]["minmonth"]
                                  ? Text(
                                      _items[index]["less"],
                                      textDirection: TextDirection.rtl,
                                    )
                                  : Text(
                                      _items[index]["more"],
                                      textDirection: TextDirection.rtl,
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
