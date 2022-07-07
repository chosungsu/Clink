import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

DelOrEditCalendar(BuildContext context) {
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
          child: HandlePage(),
        );
      });
}

HandlePage() {
  return SizedBox(
      height: 150,
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        child: Column(
          children: [
            buildTitle(),
          ],
        ),
      ));
}
buildTitle() {
  return SizedBox(
    height: 100,
    child: Column(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            '수정하기',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
          )
        ),
        Expanded(
          flex: 1,
          child: SizedBox()
        ),
        Expanded(
          flex: 1,
          child: Text(
            '삭제하기',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
          )
        ),
      ],
    )
  );
}