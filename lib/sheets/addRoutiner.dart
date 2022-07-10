import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive/hive.dart';

addRoutiner(
  BuildContext context,
) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: 380,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SheetPage(context),
        );
      });
}

SheetPage(
  BuildContext context,
) {
  return SizedBox(
      height: 380,
      child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
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
              SizedBox(
                height: 20,
              ),
              title(context),
              SizedBox(
                height: 20,
              ),
              content(context)
            ],
          )));
}

title(
  BuildContext context,
) {
  return SizedBox(
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('설정',
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25))
        ],
      ));
}

content(
  BuildContext context,
) {
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return SizedBox(
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
              child: Text('대시보드 분석표 설정',
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 23)),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 30,
              child: Row(
                children: [
                  Flexible(
                      flex: 1,
                      child: SizedBox(
                        height: 30,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Hive.box('user_setting')
                                            .get('numorimogi_routine') ==
                                        null
                                    ? Colors.white
                                    : (Hive.box('user_setting')
                                                .get('numorimogi_routine') ==
                                            0
                                        ? Colors.white
                                        : Colors.grey.shade400),
                                side: const BorderSide(
                                  width: 0.5,
                                  color: Colors.red,
                                )),
                            onPressed: () {
                              setState(() {
                                Hive.box('user_setting')
                                    .put('numorimogi_routine', 0);
                              });
                            },
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: NeumorphicText(
                                      '퍼센트로 표시',
                                      style: NeumorphicStyle(
                                        shape: NeumorphicShape.flat,
                                        depth: 3,
                                        color: Hive.box('user_setting').get(
                                                    'numorimogi_routine') ==
                                                null
                                            ? Colors.black45
                                            : (Hive.box('user_setting').get(
                                                        'numorimogi_routine') ==
                                                    0
                                                ? Colors.black45
                                                : Colors.white),
                                      ),
                                      textStyle: NeumorphicTextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )),
                      )),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      height: 30,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Hive.box('user_setting')
                                          .get('numorimogi_routine') ==
                                      null
                                  ? Colors.grey.shade400
                                  : (Hive.box('user_setting')
                                              .get('numorimogi_routine') ==
                                          0
                                      ? Colors.grey.shade400
                                      : Colors.white),
                              side: const BorderSide(
                                width: 0.5,
                                color: Colors.red,
                              )),
                          onPressed: () {
                            setState(() {
                              Hive.box('user_setting')
                                  .put('numorimogi_routine', 1);
                            });
                          },
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: NeumorphicText(
                                    '이모지로 표시',
                                    style: NeumorphicStyle(
                                      shape: NeumorphicShape.flat,
                                      depth: 3,
                                      color: Hive.box('user_setting')
                                                  .get('numorimogi_routine') ==
                                              null
                                          ? Colors.white
                                          : (Hive.box('user_setting').get(
                                                      'numorimogi_routine') ==
                                                  0
                                              ? Colors.white
                                              : Colors.black45),
                                    ),
                                    textStyle: NeumorphicTextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 30,
              child: Text('친구 추가',
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 23)),
            ),
          ],
        ));
  });
}
