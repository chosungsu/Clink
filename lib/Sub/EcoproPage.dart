import 'package:flutter/material.dart';


class EcoproPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _EcoproPageState();
}

class _EcoproPageState extends State<EcoproPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black54,
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
            '에코 Pro',
            style: TextStyle(color: Colors.blueGrey)),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: makeBody(context),
        ),
      ),
    );
  }
}
// 바디 만들기
Widget makeBody(BuildContext context) {

  return SingleChildScrollView(
    child: Text(
        'Hi'
    ),

  );
}