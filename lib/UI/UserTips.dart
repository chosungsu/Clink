import 'package:flutter/material.dart';
import '../DB/AD_Home.dart';

UserTips(BuildContext context) {
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
                Icons.tips_and_updates,
                color: Colors.deepPurpleAccent.shade100,
              ),
              SizedBox(width: 10,),
              const Text(
                '알면 유용한 팁들',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          )
      ),
      TipClips(context),

    ],
  );
}
TipClips(context) {
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
      height: 170,
      child: Padding(
        padding: EdgeInsets.only(left:20, bottom: 20, right: 20),
        child: ListView.builder(
          //controller: mainController,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: _list_ad.length,
            itemBuilder: (context, index) =>
                Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: SizedBox(
                      width: 180,
                      height: 120,
                      child: Card(
                          color: const Color(0xffd3f1ff),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(16.0),
                          ),
                          elevation: 4.0,
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      _list_ad[index].title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      'Tip 톺아보기',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: IconButton(
                                  onPressed: () {
                                    if(index == 1) {

                                    } else if (index == 2) {

                                    } else if (index == 3) {

                                    } else {

                                    }
                                  },
                                  icon: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                ),
                              )
                            ],
                          ),
                      ),
                    )
                )
        ),
      )
  );
}