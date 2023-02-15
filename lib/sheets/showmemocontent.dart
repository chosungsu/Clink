import 'package:clickbyme/BACKENDPART/Getx/selectcollection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../Tool/NoBehavior.dart';
import '../Tool/TextSize.dart';

showmemocontent(
  BuildContext context,
  List<bool> checkbottoms,
  List<FocusNode> nodes,
  selectcollection scollection,
  List<TextEditingController> controllers,
) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).orientation == Orientation.portrait
            ? Get.width
            : Get.width / 2,
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      )),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              margin: const EdgeInsets.only(
                  left: 10, right: 10, bottom: kBottomNavigationBarHeight),
              child: ScrollConfiguration(
                behavior: NoBehavior(),
                child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: StatefulBuilder(
                    builder: ((context, setState) {
                      return readycontent(context, checkbottoms, nodes,
                          scollection, controllers);
                    }),
                  ),
                ),
              ),
            ));
      }).whenComplete(() {});
}

readycontent(
  BuildContext context,
  List<bool> checkbottoms,
  List<FocusNode> nodes,
  selectcollection scollection,
  List<TextEditingController> controllers,
) {
  return SizedBox(
      child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? (MediaQuery.of(context).size.width - 40) * 0.2
                              : (Get.width / 2 - 40) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                    ],
                  )),
              const SizedBox(
                height: 30,
              ),
              content(context, checkbottoms, nodes, scollection, controllers),
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}

content(
  BuildContext context,
  List<bool> checkbottoms,
  List<FocusNode> nodes,
  selectcollection scollection,
  List<TextEditingController> controllers,
) {
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              for (int i = 0; i < nodes.length; i++) {
                nodes[i].unfocus();
              }
              checkbottoms[0] == false
                  ? checkbottoms[0] = true
                  : checkbottoms[0] = false;
              if (checkbottoms[0] == true) {
                Hive.box('user_setting').put('optionmemoinput', 0);
                Hive.box('user_setting').put('optionmemocontentinput', null);
                scollection.addmemolistin(scollection.memoindex);
                scollection.addmemolistcontentin(scollection.memoindex - 1);

                checkbottoms[0] = false;
                nodes.add(FocusNode(canRequestFocus: true));
                scollection.addmemotextfield();

                /*controllers.add(TextEditingController(
                    text: scollection
                        .memolistcontentin[scollection.memoindex - 1]));*/
                nodes[nodes.length - 1].requestFocus();
                Navigator.pop(context);
              }
            });
          },
          child: Row(
            children: [
              const Icon(
                Icons.post_add,
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              Text('일반장문타입',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize())),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              for (int i = 0; i < nodes.length; i++) {
                nodes[i].unfocus();
              }
              checkbottoms[1] == false
                  ? checkbottoms[1] = true
                  : checkbottoms[1] = false;
              if (checkbottoms[1] == true) {
                Hive.box('user_setting').put('optionmemoinput', 1);
                Hive.box('user_setting').put('optionmemocontentinput', null);
                scollection.addmemolistin(scollection.memoindex);
                scollection.addmemolistcontentin(scollection.memoindex - 1);

                checkbottoms[1] = false;
                nodes.add(FocusNode(canRequestFocus: true));
                scollection.addmemotextfield();
                nodes[nodes.length - 1].requestFocus();
                Navigator.pop(context);
              }
            });
          },
          child: Row(
            children: [
              const Icon(
                Icons.check_box_outline_blank,
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              Text('체크박스타입',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize())),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              for (int i = 0; i < nodes.length; i++) {
                nodes[i].unfocus();
              }
              checkbottoms[2] == false
                  ? checkbottoms[2] = true
                  : checkbottoms[2] = false;
              if (checkbottoms[2] == true) {
                Hive.box('user_setting').put('optionmemoinput', 2);
                Hive.box('user_setting').put('optionmemocontentinput', null);
                scollection.addmemolistin(scollection.memoindex);
                scollection.addmemolistcontentin(scollection.memoindex - 1);
                checkbottoms[2] = false;
                nodes.add(FocusNode(canRequestFocus: true));
                scollection.addmemotextfield();
                nodes[nodes.length - 1].requestFocus();
                Navigator.pop(context);
              }
            });
          },
          child: Row(
            children: [
              const Icon(
                Icons.star_rate,
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              Text('중요문장작성',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize())),
            ],
          ),
        )
      ],
    );
  });
}
