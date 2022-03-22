import 'package:clickbyme/UI/UserChoice.dart';
import 'package:clickbyme/UI/UserPicks.dart';
import 'package:clickbyme/UI/UserSubscription.dart';
import 'package:clickbyme/UI/UserTips.dart';
import 'package:flutter/material.dart';
import '../Tool/NoBehavior.dart';
import '../UI/AD.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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
            child: Column(
              children: [
                UserTips(context),
                UserPicks(context),
                //AD(context),
                UserChoice(context),
              ],
            ),
          )),
    );
  }
}
