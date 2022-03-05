import 'package:flutter/material.dart';
import '../Dialogs/destroyBackKey.dart';


class FeedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text('피드', style: TextStyle(color: Colors.blueGrey)),
        elevation: 0,
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Container(
          child: Center(
            child: makeBody(context),
          ),
        ),
      ),
    );
  }
  Future<bool> _onWillPop() async {
    return (await destroyBackKey(context)) ?? false;
  }
}

// 바디 만들기
Widget makeBody(BuildContext context) {

  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            child : Center(
                child : Column(
                    children : <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40, left: 30, right: 30),
                        //child: LoginBtn(),
                        child: Column(
                          children: [

                          ],
                        ),
                      ),
                    ]
                )
            )
        ),
      ],
    ),

  );
}