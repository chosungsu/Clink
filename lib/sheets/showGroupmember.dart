import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../DB/ChipList.dart';
import '../Tool/BGColor.dart';
import '../Tool/SheetGetx/PeopleAdd.dart';
import 'addgroupmember.dart';

SheetPageG(
  BuildContext context,
  FocusNode searchNode,
  TextEditingController controller,
) {
  final List<String> list_user = <String>[];
  return SizedBox(
      height: 390,
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
              buildTitle(),
              const SizedBox(
                height: 20,
              ),
              alphalist(searchNode, controller, context),
            ],
          )));
}

buildTitle() {
  return SizedBox(
      height: 50,
      child: Text(
        '목록',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: contentTitleTextsize(),
            color: Colors.black),
      ));
}

alphalist(FocusNode searchNode, TextEditingController controller,
    BuildContext context) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String username = Hive.box('user_info').get(
    'id',
  );
  List<bool> isselected = List.filled(10000, false, growable: true);
  List<String> list_sp = [];
  final cal_share_person = Get.put(PeopleAdd());

  List listselected_sp = cal_share_person.people;
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return SizedBox(
        height: 280,
        child: Column(
          children: [
            FutureBuilder(
                future: firestore
                    .collection('PeopleList')
                    .doc(username)
                    .get()
                    .then((value) {
                  list_sp.clear();
                  value.data()!.forEach((key, value) {
                    list_sp.add(value);
                  });
                }),
                builder: (context, snapshot) {
                  if (snapshot.hasData || list_sp.isNotEmpty) {
                    return SizedBox(
                        height: 230,
                        width: MediaQuery.of(context).size.width - 40,
                        child: AlphabetScrollView(
                          list: list_sp.map((e) => AlphaModel(e)).toList(),
                          itemExtent: 50,
                          itemBuilder: (_, k, id) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: ListTile(
                                  title: Text('$id'),
                                  leading: const Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  ),
                                  trailing: Checkbox(
                                    onChanged: (value) {
                                      setState(() {
                                        isselected[k] = value!;
                                        if (!listselected_sp.contains(id)) {
                                          if (isselected[k] == true) {
                                            listselected_sp.add(id);
                                          } else {
                                            listselected_sp.removeWhere(
                                                  (element) => element == id);
                                          }
                                        } else {
                                          if (isselected[k] == false) {
                                            listselected_sp.removeWhere(
                                                  (element) => element == id);
                                          } else {
                                            listselected_sp.add(id);
                                          }
                                        }
                                      });
                                    },
                                    value: listselected_sp.contains(id)
                                     ? isselected[list_sp.indexOf(id)] = true
                                     : isselected[list_sp.indexOf(id)] = false,
                                  )),
                            );
                          },
                          selectedTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: contentTitleTextsize(),
                              color: Colors.purpleAccent),
                          unselectedTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: contentTitleTextsize(),
                              color: Colors.black),
                        ));
                  }
                  return SizedBox(
                      height: 230,
                      width: MediaQuery.of(context).size.width - 40,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(
                            color: Colors.black,
                          )
                        ],
                      ));
                }),
            SizedBox(
                height: 50,
                width: (MediaQuery.of(context).size.width - 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: ButtonColor(),
                        ),
                        onPressed: () {
                          Hive.box('user_setting')
                              .put('share_cal_person', listselected_sp);
                          Get.back();
                        },
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: NeumorphicText(
                                  '선택완료',
                                  style: const NeumorphicStyle(
                                    shape: NeumorphicShape.flat,
                                    depth: 3,
                                    color: Colors.white,
                                  ),
                                  textStyle: NeumorphicTextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: contentTitleTextsize(),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ))
                  ],
                ))
          ],
        ));
  });
}
