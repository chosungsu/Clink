import 'package:clickbyme/DB/SpaceContent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../DB/SpaceList.dart';

class SpaceShowRoom extends GetxController {
  List<SpaceContent> spaceroom = [];
  List content = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String name = Hive.box('user_info').get('id');
  DateTime Date = DateTime.now();

  void setspaceroom() {
    spaceroom = Hive.box('user_setting').get('spaceroom') ?? [];
    update();
    notifyChildrens();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    setcontentspaceroom();
    print('init space');
    update();
    notifyChildrens();
  }

  void setcontentspaceroom() {
    firestore
        .collection('CalendarDataBase')
        .where('OriginalUser', isEqualTo: name)
        .where('Date',
            isEqualTo: Date.toString().split('-')[0] +
                '-' +
                Date.toString().split('-')[1] +
                '-' +
                Date.toString().split('-')[2].substring(0, 2) +
                '일')
        .get()
        .then((value) {
      content.clear();
      value.docs.isEmpty
          ? firestore
              .collection('CalendarDataBase')
              .where('Date',
                  isEqualTo: Date.toString().split('-')[0] +
                      '-' +
                      Date.toString().split('-')[1] +
                      '-' +
                      Date.toString().split('-')[2].substring(0, 2) +
                      '일')
              .get()
              .then(((value) {
              value.docs.forEach((element) {
                for (int i = 0; i < element['Shares'].length; i++) {
                  if (element['Shares'][i].contains(name)) {
                    if (int.parse(
                            element['Timestart'].toString().substring(0, 2)) >=
                        Date.hour) {
                      content.add(SpaceContent(
                          title: element['Daytodo'],
                          date: element['Timestart'] +
                              '-' +
                              element['Timefinish']));
                    }
                  }
                }
              });
            }))
          : value.docs.forEach((element) {
              if (int.parse(element['Timestart'].toString().substring(0, 2)) >=
                  Date.hour) {
                content.add(SpaceContent(
                    title: element['Daytodo'],
                    date: element['Timestart'] + '-' + element['Timefinish']));
              }
            });
    });
    update();
    notifyChildrens();
  }
}
