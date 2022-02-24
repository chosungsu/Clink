import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


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
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('종료'),
        content: const Text('앱을 종료하시겠습니까?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: new Text('아니요'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: new Text('네'),
          ),
        ],
      ),
    )) ?? false;
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