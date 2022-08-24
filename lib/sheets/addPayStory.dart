import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';

import '../Tool/Getx/onequeform.dart';

addPaystory(
  BuildContext context,
  FocusNode searchNode,
  TextEditingController controller,
  String username,
  DateTime date,
  String s,
) {
  Get.bottomSheet(
          Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: GestureDetector(
                  onTap: () {
                    searchNode.unfocus();
                  },
                  child: SheetPageAC(
                      context, searchNode, controller, username, date, s)),
            ),
          ),
          backgroundColor: Colors.white,
          isScrollControlled: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
      .whenComplete(() {
    controller.clear();
    final cntget = Get.put(onequeform());
    cntget.setcnt();
  });
}

SheetPageAC(
  BuildContext context,
  FocusNode searchNode,
  TextEditingController controller,
  String username,
  DateTime date,
  String s,
) {
  Color _color = Hive.box('user_setting').get('typecolorcalendar') == null
      ? Colors.blue
      : Color(Hive.box('user_setting').get('typecolorcalendar'));
  return SizedBox(
      child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              content(
                  context, searchNode, controller, username, _color, date, s)
            ],
          )));
}

content(
  BuildContext context,
  FocusNode searchNode,
  TextEditingController controller,
  String username,
  Color _color,
  DateTime date,
  String s,
) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          onTap: () {},
          horizontalTitleGap: 10,
          dense: true,
          leading: const Icon(Icons.table_view),
          title: Text('더치페이 작성',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: contentTextsize())),
        ),
        ListTile(
          onTap: () {},
          horizontalTitleGap: 10,
          dense: true,
          leading: const Icon(Icons.document_scanner),
          title: Text('영수증 저장',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: contentTextsize())),
        )
      ],
    );
  });
}
