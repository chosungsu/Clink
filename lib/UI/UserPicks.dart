import 'package:flutter/material.dart';
import '../DB/AD_Home.dart';
import '../Sub/GoToDoDate.dart';

UserPicks(BuildContext context) {
  return Column(
    children: <Widget>[
      Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(
            vertical: 10, horizontal: 15,
          ),
          child: Row(
            children: [
              Icon(
                Icons.push_pin,
                color: Colors.deepPurpleAccent.shade100,
              ),
              SizedBox(width: 10,),
              const Text(
                'Let\'s do it!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.grey,
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
      title: '구독 관리',
      person_num: 5,
      date: DateTime.now(),
    ),
    AD_Home(
      id: '3',
      title: '사이트 링크 관리',
      person_num: 5,
      date: DateTime.now(),
    ),
    AD_Home(
      id: '4',
      title: '톡톡 PLUS',
      person_num: 4,
      date: DateTime.now(),
    ),
  ];
  final List<String> itemImg = [
    'assets/images/fingerprint.png',
    'assets/images/fingerprint.png',
    'assets/images/icon-link.png',
    'assets/images/icon-chat.png',
  ];
  return SizedBox(
    height: 300,
    child: GridView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: _list_ad.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3 / 2
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
                  if (index == 0) {
                    //일정관리탭으로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              GoToDoDate()),
                    );
                  } else if (index == 1) {

                  } else if (index == 2) {

                  } else {

                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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