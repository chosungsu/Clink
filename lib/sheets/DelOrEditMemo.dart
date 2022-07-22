import 'package:clickbyme/UI/Home/firstContentNet/DayScript.dart';
import 'package:clickbyme/UI/Home/firstContentNet/MemoScript.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';

DelOrEditMemo(BuildContext context, int index) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: HandlePage(context, index),
        );
      });
}

HandlePage(BuildContext context, int index) {
  return SizedBox(
      height: 120,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
        child: Column(
          children: [
            buildTitle(context, index),
          ],
        ),
      ));
}

buildTitle(BuildContext context, int index) {
  return SizedBox(
      height: 100,
      child: Column(
        children: [
          SizedBox(
              height: 5,
              width: MediaQuery.of(context).size.width - 40,
              child: Row(
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 40) * 0.4,
                  ),
                  Container(
                      width: (MediaQuery.of(context).size.width - 40) * 0.2,
                      alignment: Alignment.topCenter,
                      color: Colors.black45),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 40) * 0.4,
                  ),
                ],
              )),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 30,
            child: InkWell(
                onTap: () {
                  //수정 및 삭제 시트 띄우기
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.bottomToTop,
                        child: DayScript(
                          index: 1,
                          date: DateTime.now(), 
                          position: 'note',
                        )),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      '수정하기',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black),
                    ),
                  ],
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 30,
            child: InkWell(
                onTap: () {
                  //수정 및 삭제 시트 띄우기
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.bottomToTop,
                        child: DayScript(
                          index: 2,
                          date: DateTime.now(), 
                          position: 'note',
                        )),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      '삭제하기',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black),
                    ),
                  ],
                )),
          ),
        ],
      ));
}
