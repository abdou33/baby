import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/home.dart';
import '../screens/sources.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key, required this.gender}) : super(key: key);

  final String gender;
  

  @override
  Widget build(BuildContext context) {
    final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'abdou333318@gmail.com',
  );

  const githublink = "https://github.com/abdou33";
  const googleplaylink = "https://play.google.com/";

    return Drawer(
      backgroundColor: gender == "male" ? Colors.blue[50] : Colors.pink[50],
      semanticLabel: "yes",
      child: ListView(padding: EdgeInsets.zero, children: [
        SizedBox(
          height: 60,
        ),
        Image.asset(
          gender == "male" ? "assets/babyboy.png" : "assets/babygirl.png",
          height: 70,
          width: 70,
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 20,
        ),
        const Divider(
          thickness: 2,
          indent: 5,
          endIndent: 5,
          //color: Colors.black,
          height: 3,
        ),
        ListTile(
          trailing: Icon(Icons.source),
          title: Text(
            'المصادر',
            textDirection: TextDirection.rtl,
          ),
          onTap: () {
            Navigator.push(
                (context), MaterialPageRoute(builder: (context) => Sources()));
          },
        ),
        ListTile(
          trailing: Icon(Icons.star),
          title: Text(
            'قيم التطبيق',
            textDirection: TextDirection.rtl,
          ),
          onTap: () async {
            await launchUrl(Uri.parse(googleplaylink), mode: LaunchMode.externalApplication);
          },
        ),
        ListTile(
          trailing: Icon(Icons.feedback),
          title: Text(
            'قدم ملاحظاتك',
            textDirection: TextDirection.rtl,
          ),
          onTap: () {

  launchUrl(emailLaunchUri);
          },
        ),
        ListTile(
          trailing: Icon(Icons.warning),
          title: Text(
            'اخلاء المسؤولية',
            textDirection: TextDirection.rtl,
          ),
          onTap: () {
            AlertDialog alert = AlertDialog(
              icon: Icon(Icons.medical_information),
              content: Text(
                'كل المعلومات في هذا التطبيق تم نقلها من مواقع يرجح أنها موثوقة بصفة كبيرة لكن لا تتردد (تترددي) في استشارة الطبيب اذا راودك (راودكي) أي تساؤل',
                textDirection: TextDirection.rtl,
              ),
            );
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return alert;
              },
            );
          },
        ),
        ListTile(
          trailing: Icon(Icons.face_retouching_natural),
          title: Text('المطور', textDirection: TextDirection.rtl,),
          onTap: () async {
            await launchUrl(Uri.parse(githublink), mode: LaunchMode.externalApplication);
          },
        ),
      ]),
    );
  }
}
