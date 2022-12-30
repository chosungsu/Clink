import 'package:clickbyme/Tool/FlushbarStyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info/package_info.dart';
import '../FRONTENDPART/Route/subuiroute.dart';
import '../Tool/AndroidIOS.dart';
import '../Tool/Getx/PeopleAdd.dart';
import '../Tool/IconBtn.dart';
import '../Tool/TextSize.dart';
import 'package:device_info_plus/device_info_plus.dart';

userinfotalk(BuildContext context, int index, List friendnamelist) {
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
                child: userinfosheet(context, friendnamelist, index),
              )),
        );
      }).whenComplete(() {});
}

userinfosheet(
  BuildContext context,
  List friendnamelist,
  int index,
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
                height: 20,
              ),
              title(context, friendnamelist, index),
              const SizedBox(
                height: 50,
              ),
              content(context, friendnamelist, index),
              const SizedBox(
                height: 10,
              ),
            ],
          )));
}

title(
  BuildContext context,
  List friendnamelist,
  int index,
) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String realname = '';
  String code = '';
  return FutureBuilder(
      future: firestore
          .collection('User')
          .where('subname', isEqualTo: friendnamelist[index])
          .get()
          .then(((snapshot) => {
                snapshot.docs.forEach((doc) {
                  realname = doc.get('name');
                  code = doc.get('code');
                })
              })),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(friendnamelist[index],
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: secondTitleTextsize())),
              SizedBox(
                height: 30,
              ),
              Text('유저코드 : ' + code,
                  style: TextStyle(
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.normal,
                      fontSize: contentTextsize())),
            ],
          ));
        }
        return SizedBox(
            height: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(friendnamelist[index],
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25))
              ],
            ));
      }));
}

content(BuildContext context, List friendnamelist, int index) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String username = Hive.box('user_info').get(
    'id',
  );
  String usercode = Hive.box('user_setting').get('usercode');
  final cal_share_person = Get.put(PeopleAdd());
  List updatenamelist = [];
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconBtn(
                child: IconButton(
                    onPressed: () {
                      Get.back();
                      Snack.show(
                          title: '알림',
                          content: '준비중인 기능입니다.',
                          snackType: SnackType.info,
                          context: context);
                    },
                    icon: Container(
                      alignment: Alignment.center,
                      width: 30,
                      height: 30,
                      child: NeumorphicIcon(
                        Icons.send,
                        size: 30,
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.convex,
                            depth: 2,
                            surfaceIntensity: 0.5,
                            color: Colors.purple.shade200,
                            lightSource: LightSource.topLeft),
                      ),
                    )),
                color: Colors.black),
            IconBtn(
                child: IconButton(
                    onPressed: () async {
                      print(friendnamelist[index]);
                      final reloadpage = await Get.dialog(OSDialog(
                              context,
                              '경고',
                              Text('명단에서 정말 삭제하시겠습니까?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTextsize(),
                                      color: Colors.blueGrey)),
                              pressed2)) ??
                          false;
                      if (reloadpage) {
                        await firestore
                            .collection('PeopleList')
                            .doc(username)
                            .get()
                            .then((value) {
                          if (value.exists) {
                            for (int i = 0;
                                i < value.data()!['friends'].length;
                                i++) {
                              updatenamelist.add(value.data()!['friends'][i]);
                            }
                            updatenamelist.removeWhere(
                                (element) => element == friendnamelist[index]);
                            firestore
                                .collection('PeopleList')
                                .doc(username)
                                .set({'friends': updatenamelist},
                                    SetOptions(merge: true)).whenComplete(() {
                              updatenamelist.clear();
                            });
                          }
                        });
                        await firestore
                            .collection('CalendarSheetHome_update')
                            .where('madeUser', isEqualTo: usercode)
                            .get()
                            .then((value) {
                          for (int i = 0; i < value.docs.length; i++) {
                            for (int j = 0;
                                j < value.docs[i].get('share').length;
                                j++) {
                              updatenamelist.add(value.docs[i].get('share')[j]);
                            }
                            if (updatenamelist.isNotEmpty) {
                              updatenamelist.removeWhere((element) =>
                                  element == friendnamelist[index]);
                              firestore
                                  .collection('CalendarSheetHome_update')
                                  .doc(value.docs[i].id)
                                  .update({'share': updatenamelist});
                            }
                            updatenamelist.clear();
                          }
                        });
                        Get.back();
                        Snack.show(
                            title: '알림',
                            content: '피플명단에서 삭제되었습니다.',
                            snackType: SnackType.info,
                            context: context);
                      }
                    },
                    icon: Container(
                      alignment: Alignment.center,
                      width: 30,
                      height: 30,
                      child: NeumorphicIcon(
                        Icons.person_remove,
                        size: 30,
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.convex,
                            depth: 2,
                            surfaceIntensity: 0.5,
                            color: Colors.red.shade200,
                            lightSource: LightSource.topLeft),
                      ),
                    )),
                color: Colors.black)
          ],
        ),
      ],
    );
  });
}
