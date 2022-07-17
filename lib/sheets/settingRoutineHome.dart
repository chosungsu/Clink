import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive/hive.dart';

settingRoutineHome(
  BuildContext context,
) {
  showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.only(
        topLeft: const Radius.circular(20),
        topRight: Radius.circular(20),
      )),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: 230,
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
            ));
      });
}

SheetPage(
  BuildContext context,
) {
  return SizedBox(
      height: 210,
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
              const SizedBox(
                height: 20,
              ),
              title(context),
              const SizedBox(
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
        children: const [
          Text('설정',
              style: TextStyle(
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
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
              child: Text('검색 조건설정',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ),
            const SizedBox(
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
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                primary: Hive.box('user_setting')
                                                .get('numorimogi_routine') ==
                                            0
                                        ? Colors.grey.shade400
                                        : Colors.white,
                                side: const BorderSide(
                                  width: 1,
                                  color: Colors.black45,
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
                                      '제목',
                                      style: NeumorphicStyle(
                                        shape: NeumorphicShape.flat,
                                        depth: 3,
                                        color: Hive.box('user_setting').get(
                                                        'numorimogi_routine') ==
                                                    0
                                                ? Colors.white
                                                : Colors.black45,
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
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              primary: Hive.box('user_setting')
                                                .get('numorimogi_routine') ==
                                            1
                                        ? Colors.grey.shade400
                                        : Colors.white,
                              side: const BorderSide(
                                width: 1,
                                color: Colors.black45,
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
                                    '내용',
                                    style: NeumorphicStyle(
                                      shape: NeumorphicShape.flat,
                                      depth: 3,
                                      color: Hive.box('user_setting').get(
                                                        'numorimogi_routine') ==
                                                    1
                                                ? Colors.white
                                                : Colors.black45,
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
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      height: 30,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              primary: Hive.box('user_setting')
                                                .get('numorimogi_routine') ==
                                            2
                                        ? Colors.grey.shade400
                                        : Colors.white,
                              side: const BorderSide(
                                width: 1,
                                color: Colors.black45,
                              )),
                          onPressed: () {
                            setState(() {
                              Hive.box('user_setting')
                                  .put('numorimogi_routine', 2);
                            });
                          },
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: NeumorphicText(
                                    '중요도',
                                    style: NeumorphicStyle(
                                      shape: NeumorphicShape.flat,
                                      depth: 3,
                                      color: Hive.box('user_setting').get(
                                                        'numorimogi_routine') ==
                                                    2
                                                ? Colors.white
                                                : Colors.black45,
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
          ],
        ));
  });
}
