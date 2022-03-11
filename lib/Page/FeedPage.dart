import 'package:clickbyme/UI/UserTips.dart';
import 'package:flutter/material.dart';
import '../Dialogs/destroyBackKey.dart';
import '../Tool/NoBehavior.dart';
import '../UI/NoticeApps.dart';
import '../UI/UserPicks.dart';


class FeedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.grey.shade100,
        toolbarHeight: 100,
        title: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Row(
            children: [
              Text(
                  '체크잇',
                  style: TextStyle(
                    color: Colors.deepPurpleAccent.shade100,
                  )
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.check_circle,
                color: Colors.deepPurpleAccent.shade100,
              )
            ],
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return ScrollConfiguration(
                behavior: NoBehavior(),
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    children: [
                      makeBody(context)
                    ],
                  ),
                ),
              );
            })
      ),
    );
  }
  Future<bool> _onWillPop() async {
    return (await destroyBackKey(context)) ?? false;
  }
}

// 바디 만들기
Widget makeBody(BuildContext context) {

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      NoticeApps(context),
      UserTips(context),
      UserPicks(context),
    ],
  );
}