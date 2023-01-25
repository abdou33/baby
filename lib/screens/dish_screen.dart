import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Dishscreen extends StatelessWidget {
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
                      "$image",
                      fit: BoxFit.contain,
                    ),
                  )),
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("$name",
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        )),
                    Text(
                      " $month أشهر",
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
                itemCount: ingrediants.length,
                itemBuilder: (context, index) {
                  return Text(
                    ingrediants[index],
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
                itemCount: how.length,
                itemBuilder: (context, index) {
                  return Text(
                    "- " + how[index],
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
                itemCount: benefits.length,
                itemBuilder: (context, index) {
                  return Text(
                    benefits[index],
                    textDirection: TextDirection.rtl,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
