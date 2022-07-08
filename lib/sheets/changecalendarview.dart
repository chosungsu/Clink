import 'package:clickbyme/UI/Home/2ContentNet/DayContentHome.dart';
import 'package:clickbyme/UI/Sign/UserCheck.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:page_transition/page_transition.dart';

changecalendarview(BuildContext context, String calendarview) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
              height: 300,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: const Text(
                          "캘린더뷰 변경하시겠습니까?",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 180,
                        child: Column(
                          children: [
                            ListTile(
                              title: Text('월 단위뷰'),
                              leading: Radio(
                                value: 'month',
                                groupValue: calendarview,
                                onChanged: (value) {
                                  setState(() {
                                    calendarview = value.toString();
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('주 단위뷰'),
                              leading: Radio(
                                value: 'week',
                                groupValue: calendarview,
                                onChanged: (value) {
                                  setState(() {
                                    calendarview = value.toString();
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('일 단위뷰'),
                              leading: Radio(
                                value: 'day',
                                groupValue: calendarview,
                                onChanged: (value) {
                                  setState(() {
                                    calendarview = value.toString();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: NeumorphicButton(
                          onPressed: () {
                            Hive.box('user_setting')
                                .put('radio_cal', calendarview);
                            Navigator.pop(context);
                            //일정관리로 넘어가기
                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child: DayContentHome()),
                            );
                          },
                          style: NeumorphicStyle(
                              shape: NeumorphicShape.concave,
                              depth: 2,
                              color: Colors.deepPurple.shade200,
                              lightSource: LightSource.topLeft),
                          child: Center(
                              child: Text(
                            "변경하기",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                    ],
                  );
                },
              )),
        );
      });
}
