import 'package:clickbyme/Tool/Getx/selectcollection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../Tool/TextSize.dart';

showmemocontent(
  BuildContext context,
  List<bool> checkbottoms,
  List<FocusNode> nodes,
  selectcollection scollection,
) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
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
        return Container(
          margin: const EdgeInsets.all(10),
          child: Padding(
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
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: readycontent(context, checkbottoms, nodes, scollection),
              )),
        );
      }).whenComplete(() {});
}

readycontent(
  BuildContext context,
  List<bool> checkbottoms,
  List<FocusNode> nodes,
  selectcollection scollection,
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
                          width: (MediaQuery.of(context).size.width - 40) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                    ],
                  )),
              const SizedBox(
                height: 30,
              ),
              content(context, checkbottoms, nodes, scollection),
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
) {
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            setState(() {
              checkbottoms[0] == false
                  ? checkbottoms[0] = true
                  : checkbottoms[0] = false;
              if (checkbottoms[0] == true) {
                Hive.box('user_setting').put('optionmemoinput', 0);
                Hive.box('user_setting').put('optionmemocontentinput', null);
                scollection.addmemolistin(scollection.memoindex);
                scollection.addmemolistcontentin(scollection.memoindex - 1);

                checkbottoms[0] = false;
              }
              for (int i = 0; i < nodes.length; i++) {
                nodes[i].unfocus();
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
            Navigator.pop(context);
            setState(() {
              checkbottoms[1] == false
                  ? checkbottoms[1] = true
                  : checkbottoms[1] = false;
              if (checkbottoms[1] == true) {
                Hive.box('user_setting').put('optionmemoinput', 1);
                Hive.box('user_setting').put('optionmemocontentinput', null);
                scollection.addmemolistin(scollection.memoindex);
                scollection.addmemolistcontentin(scollection.memoindex - 1);

                checkbottoms[0] = false;
              }
              for (int i = 0; i < nodes.length; i++) {
                nodes[i].unfocus();
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
            Navigator.pop(context);
            setState(() {
              checkbottoms[2] == false
                  ? checkbottoms[2] = true
                  : checkbottoms[2] = false;
              if (checkbottoms[2] == true) {
                Hive.box('user_setting').put('optionmemoinput', 2);
                Hive.box('user_setting').put('optionmemocontentinput', null);
                scollection.addmemolistin(scollection.memoindex);
                scollection.addmemolistcontentin(scollection.memoindex - 1);
                checkbottoms[2] = false;
              }
              for (int i = 0; i < nodes.length; i++) {
                nodes[i].unfocus();
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
