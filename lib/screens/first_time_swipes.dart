import 'package:baby/screens/fill_born_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Swipe extends StatefulWidget {
  const Swipe({super.key});

  @override
  State<Swipe> createState() => _SwipeState();
}

class _SwipeState extends State<Swipe> {
  late PageController _pagecontroller;

  int _pageIndex = 0;

  @override
  void initState() {
    _pagecontroller = PageController(initialPage: 0);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _pagecontroller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100] ,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: data.length,
                controller: _pagecontroller,
                onPageChanged: (index) {
                  setState(() {
                    _pageIndex = index;
                    print(index);
                  });
                },
                itemBuilder: ((context, index) => onboardcontent(
                      image: data[index].image,
                      title: data[index].title,
                      description: data[index].description,
                    )),
              ),
            ),
            Row(
              children: [
                ...List.generate(
                    data.length,
                    (index) => Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: dotsindicator(
                            isActive: index == _pageIndex,
                          ),
                        )),
                Spacer(),
                SizedBox(
                  child: ElevatedButton(
                    child: Center(child: Image.asset("assets/boardingscreen/arrow.png")),
                    onPressed: () {
                      _pagecontroller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                          if(_pageIndex == 2){
                            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Borndate()));
                          }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), 
                        backgroundColor: Colors.pink,
                        fixedSize: Size(50, 50),
                        ),
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}

class dotsindicator extends StatelessWidget {
  const dotsindicator({
    Key? key,
    this.isActive = false,
  }) : super(key: key);
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: isActive ? 12 : 4,
      width: 4,
      decoration: BoxDecoration(
          color: isActive ? Colors.pink : Colors.pink.withOpacity(0.4),
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
}

class Onboard {
  final String image, title, description;
  Onboard(
      {required this.image, required this.title, required this.description});
}

final List<Onboard> data = [
  Onboard(image: "assets/boardingscreen/image1.png", title: "عنوان 1", description: "الوصف 1"),
  Onboard(image: "assets/boardingscreen/image2.png", title: "عنوان 2", description: "الوصف 2"),
  Onboard(image: "assets/boardingscreen/image3.png", title: "عنوان 3", description: "الوصف 3"),
];

class onboardcontent extends StatelessWidget {
  const onboardcontent({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
  }) : super(key: key);

  final String image, title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30),
        Image.asset(image),
        SizedBox(height: 20),
        Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(description),
      ],
    );
  }
}
