import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../DB/AD_Home.dart';

AD(BuildContext context) {
  return Card(
    color: Colors.white,
    child: Column(
      children: <Widget>[
        Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(
              vertical: 10, horizontal: 15,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.format_quote,
                  color: Colors.deepPurpleAccent.shade100,
                ),
                SizedBox(width: 10,),
                Text(
                  'AD',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
              ],
            )
        ),
        AdClips(context),

      ],
    ),
  );
}
AdClips(context) {
  final List<AD_Home> _list_ad = [
    AD_Home(
      id: '1',
      title: '일정 관리',
      person_num: 3,
      date: DateTime.now(),
    ),
    AD_Home(
      id: '2',
      title: '인맥 관리',
      person_num: 4,
      date: DateTime.now(),
    ),
    AD_Home(
      id: '3',
      title: '구독 관리',
      person_num: 5,
      date: DateTime.now(),
    ),
    AD_Home(
      id: '4',
      title: '포인트 관리',
      person_num: 5,
      date: DateTime.now(),
    )
  ];
  return SizedBox(
    height: MediaQuery.of(context).size.height / 10,
    child: Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: ListView.builder(
        //controller: mainController,
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: _list_ad.length,
          itemBuilder: (context, index) =>
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 15,
                  child: Card(
                      color: const Color(0xffd3f1ff),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(16.0),
                      ),
                      elevation: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Container(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Center(
                              child: Text(
                                '광고 : ' +
                                    _list_ad[index].title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black45,
                                ),
                              ),
                            )
                        ),
                      )
                  ),
                )
              )
      ),
    )
  );
}