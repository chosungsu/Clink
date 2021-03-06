import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive/hive.dart';

pushalarmsetting(
  BuildContext context,
  int i,
  bool isChecked, DateTime selectedDay,
) {
  showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      )),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: 220,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: SheetPage(context, i, isChecked, selectedDay),
            ));
      });
}

SheetPage(
  BuildContext context,
  int i,
  bool isChecked, DateTime selectedDay,
) {
  return SizedBox(
      height: 200,
      child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              title(context, i, isChecked, selectedDay),
              const SizedBox(
                height: 20,
              ),
              content(context, i, isChecked, selectedDay)
            ],
          )));
}

title(
  BuildContext context,
  int i,
  bool isChecked, DateTime selectedDay,
) {
  return SizedBox(
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          i == 0
              ? const Text('??? ??????????????? ?????????????????????.',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20))
              : const Text('????????? ??????????????? ?????????????????????.',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20))
        ],
      ));
}

content(
  BuildContext context,
  int i,
  bool isChecked, DateTime selectedDay,
) {
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return SizedBox(
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            i == 0
              ? Text(selectedDay.toString() + '\n?????? ????????? ????????? ?????????????????????.\n????????? ????????? ????????? ??? ????????????.',
                  style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 15))
              : Text(selectedDay.toString() + '\n?????? ????????? ????????? ?????????????????????.\n????????? ????????? ????????? ??? ????????????.',
                  style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 15))
          ],
        ));
  });
}
