import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../DB/AD_Home.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text('SuChip', style: TextStyle(color: Colors.blueGrey)),
        elevation: 0,
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: ListView(
          children: <Widget>[
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                vertical: 10, horizontal: 15,
              ),
              child: Row(
                children: const [
                  Icon(
                      Icons.push_pin
                  ),
                  SizedBox(width: 10,),
                  Text(
                    '메인 PICK',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                ],
              )
            ),
            Main_Pick(context),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(
                  vertical: 10, horizontal: 15,
                ),
                child: Row(
                  children: const [
                    Icon(
                        Icons.subscriptions
                    ),
                    SizedBox(width: 10,),
                    Text(
                      'My 구독',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                )
            ),
          ],
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
            child: const Text('아니요'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text('네'),
          ),
        ],
      ),
    )) ?? false;
  }
}
Main_Pick(context) {
  final List<AD_Home> _list_ad = [
    AD_Home(
      id: '1',
      title: 'Netflix',
      person_num: 3,
      date: DateTime.now(),
    ),
    AD_Home(
      id: '2',
      title: 'Coupang Play',
      person_num: 4,
      date: DateTime.now(),
    )
  ];
  return SizedBox(
    height: 200,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 15, right: 15),
          width: 300,
          child: Card(
            color: const Color(0xffd3f1ff),
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(16.0),
            ),
            elevation: 4.0,
            child: Column(
              children: [
                const SizedBox(height: 10,),
                Container(
                  child: Text(
                    _list_ad[0].title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.red,
                    ),
                  ),
                  margin: const EdgeInsets.symmetric(
                    vertical: 20, horizontal: 15,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        DateFormat('yyyy-MM-dd')
                            .format(_list_ad[0].date),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 5,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          child: Text(
                            '현재 참여중인 인원 수 : ' +
                                _list_ad[0].person_num.toString() +
                                '명',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 15, right: 15),
          width: 300,
          child: Card(
            color: const Color(0xffd49af8),
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(16.0),
            ),
            elevation: 4.0,
            child: Column(
              children: [
                SizedBox(height: 10,),
                Container(
                  child: Text(
                    _list_ad[1].title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.red,
                    ),
                  ),
                  margin: const EdgeInsets.symmetric(
                    vertical: 20, horizontal: 15,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        DateFormat('yyyy-MM-dd')
                            .format(_list_ad[1].date),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 5,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          child: Text(
                            '현재 참여중인 인원 수 : ' +
                                _list_ad[1].person_num.toString() +
                                '명',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        )
      ],
    ),
  );
}
