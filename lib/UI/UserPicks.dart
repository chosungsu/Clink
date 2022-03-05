import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../DB/AD_Home.dart';

UserPicks(BuildContext context) {
  return Column(
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
                '다양한 탐구',
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

    ],
  );
}
Main_Pick(context) {
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
  final List<String> itemImg = [
    'assets/images/fingerprint.png',
    'assets/images/fingerprint.png',
    'assets/images/fingerprint.png',
    'assets/images/fingerprint.png',
  ];
  return SizedBox(
    height: 150,
    child: GridView.builder(
        itemCount: _list_ad.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 3 / 1
        ),
        itemBuilder: (context, index) {
          return Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.white60.withOpacity(0.7),
              child: InkWell(
                onTap: () {

                },
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        itemImg[index],
                        height: 50,
                        width: 50,
                      ),
                      Text(
                        _list_ad[index].title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                )
              )
          );
        }
    )
  );
}