import 'package:flutter/material.dart';

class Sources extends StatelessWidget {
  const Sources({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: const [
        Text("جدول التلقيحات  : \nhttps://dzdoc.com/sante/conseils-doc/جدول-التطعيم-في-الجزائر", textDirection: TextDirection.rtl,),
        Text("حركات الرضيع : الدفتر الصحي", textDirection: TextDirection.rtl,),
        ],
      ),
    );
  }
}