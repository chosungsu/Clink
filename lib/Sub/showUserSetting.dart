import 'package:flutter/material.dart';


class showUserSetting extends StatefulWidget {
  const showUserSetting({Key? key,
    required this.name, required this.email}) : super(key: key);
  final String name, email;

  @override
  State<StatefulWidget> createState() => _showUserSettingState();
}

class _showUserSettingState extends State<showUserSetting> {
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
            '#' + widget.name + '님의 Room',
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