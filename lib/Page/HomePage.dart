import 'package:clickbyme/UI/UserChoice.dart';
import 'package:clickbyme/UI/UserPicks.dart';
import 'package:clickbyme/UI/UserTips.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import '../Tool/NoBehavior.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool show_what0 = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      if (Hive.box('user_setting').get('no_show_tip_page') != null) {
        show_what0 = Hive.box('user_setting').get('no_show_tip_page');
      } else {
        show_what0 = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (Hive.box('user_setting').get('no_show_tip_page') != null) {
        show_what0 = Hive.box('user_setting').get('no_show_tip_page');
      } else {
        show_what0 = false;
      }
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(widget.title,
            style: TextStyle(
              color: Colors.deepPurpleAccent.shade100,
            )),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: ScrollConfiguration(
          behavior: NoBehavior(),
          child: SingleChildScrollView(
              child: StatefulBuilder(builder: (_, StateSetter setState) {
            return show_what0 == true
                ? Column(
                    children: [
                      UserPicks(context),
                      //AD(context)
                      UserChoice(context),
                    ],
                  )
                : Column(
                    children: [
                      UserTips(context),
                      UserPicks(context),
                      //AD(context),
                      UserChoice(context),
                    ],
                  );
          }))),
    );
  }
}
