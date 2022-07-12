// ignore_for_file: unnecessary_const

import 'package:clickbyme/UI/Home/firstContentNet/DayScript.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';

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
          child: HandlePage(context),
        );
      });
}

HandlePage(BuildContext context) {
  return SizedBox(
      height: 150,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        child: Column(
          children: [
            buildTitle(context),
          ],
        ),
      ));
}

buildTitle(BuildContext context) {
  final _formkey = GlobalKey<FormState>();
  return SizedBox(
      height: 100,
      child: Column(
        children: [
          InkWell(
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
                      fkey: _formkey,
                    )),
              );
            },
            child: const Expanded(
                flex: 1,
                child: const Text(
                  '수정하기',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black),
                )),
          ),
          const Expanded(flex: 1, child: const SizedBox()),
          InkWell(
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
                      fkey: _formkey,
                    )),
              );
            },
            child: const Expanded(
                flex: 1,
                child: const Text(
                  '삭제하기',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black),
                )),
          ),
        ],
      ));
}
