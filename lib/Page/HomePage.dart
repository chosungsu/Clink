import 'package:clickbyme/UI/UserChoice.dart';
import 'package:clickbyme/UI/UserPicks.dart';
import 'package:clickbyme/UI/UserTips.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import '../Tool/NoBehavior.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool show_what0 = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String str_snaps = '';
  String str_todo = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        if (Hive.box('user_setting').get('no_show_tip_page') != null) {
          show_what0 = Hive.box('user_setting').get('no_show_tip_page');
        } else {
          show_what0 = false;
        }
        firestore
            .collection('TODO')
            .doc(Hive.box('user_info').get('id') +
                DateFormat('yyyy-MM-dd')
                    .parse(DateTime.now().toString().split(' ')[0])
                    .toString())
            .get()
            .then((DocumentSnapshot ds) {
          if (ds.data() != null) {
            str_snaps = (ds.data() as Map)['time'];
            str_todo = (ds.data() as Map)['todo'];
          } else {}
        });
      });
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
      firestore
            .collection('TODO')
            .doc(Hive.box('user_info').get('id') +
                DateFormat('yyyy-MM-dd')
                    .parse(DateTime.now().toString().split(' ')[0])
                    .toString())
            .get()
            .then((DocumentSnapshot ds) {
          if (ds.data() != null) {
            str_snaps = (ds.data() as Map)['time'];
            str_todo = (ds.data() as Map)['todo'];
          } else {}
        });
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
                      UserChoice(context, str_snaps, str_todo),
                    ],
                  )
                : Column(
                    children: [
                      UserTips(context),
                      UserPicks(context),
                      //AD(context),
                      UserChoice(context, str_snaps, str_todo),
                    ],
                  );
          }))),
    );
  }
}
