import 'package:clickbyme/DB/TODO.dart';
import 'package:clickbyme/Tool/Shimmer_home.dart';
import 'package:clickbyme/UI/UserChoice.dart';
import 'package:clickbyme/UI/UserPicks.dart';
import 'package:clickbyme/UI/UserTips.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shimmer/shimmer.dart';
import '../Futures/homeasync.dart';
import '../Tool/NoBehavior.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool show_what0 = false;
  DateTime selectedDay = DateTime.now();

  @override
  initState() {
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
      body: Container(
        color: Colors.grey.shade300,
        height: MediaQuery.of(context).size.height,
        child: ScrollConfiguration(
          behavior: NoBehavior(),
          child: SingleChildScrollView(
              child: StatefulBuilder(builder: (_, StateSetter setState) {
            return show_what0 == true
                ? Column(
                    children: [
                      UserPicks(context),
                      //AD(context)
                      FutureBuilder<List<TODO>>(
                        future: homeasync(
                            selectedDay), // a previously-obtained Future<String> or null
                        builder: (BuildContext context,
                            AsyncSnapshot<List<TODO>> snapshot) {
                          if (snapshot.hasData &&
                              snapshot.connectionState ==
                                  ConnectionState.done) {
                            return UserChoice(context, snapshot.data!);
                          } else {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Neumorphic(
                                    style: NeumorphicStyle(
                                      shape: NeumorphicShape.convex,
                                      border: NeumorphicBorder.none(),
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(5)),
                                      depth: 5,
                                      color: Colors.white,
                                    ),
                                    child: Shimmer_home(context))
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  )
                : Column(
                    children: [
                      UserTips(context),
                      UserPicks(context),
                      //AD(context),
                      FutureBuilder<List<TODO>>(
                        future: homeasync(
                            selectedDay), // a previously-obtained Future<String> or null
                        builder: (BuildContext context,
                            AsyncSnapshot<List<TODO>> snapshot) {
                          if (snapshot.hasData &&
                              snapshot.connectionState ==
                                  ConnectionState.done) {
                            return UserChoice(context, snapshot.data!);
                          } else {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Neumorphic(
                                    style: NeumorphicStyle(
                                      shape: NeumorphicShape.convex,
                                      border: NeumorphicBorder.none(),
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(5)),
                                      depth: 5,
                                      color: Colors.white,
                                    ),
                                    child: Shimmer_home(context))
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  );
          }))),
      )
    );
  }
}
