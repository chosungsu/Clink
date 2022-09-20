import 'package:clickbyme/Tool/FlushbarStyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info/package_info.dart';
import '../Dialogs/destroyBackKey.dart';
import '../Tool/AndroidIOS.dart';
import '../Tool/Getx/PeopleAdd.dart';
import '../Tool/IconBtn.dart';
import '../Tool/TextSize.dart';
import 'package:device_info_plus/device_info_plus.dart';

userinfotalk(BuildContext context, int index, List friendnamelist) {
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
                          width: (MediaQuery.of(context).size.width - 40) * 0.2,
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
                            .collection('CalendarSheetHome')
                            .where('madeUser',
                                isEqualTo: cal_share_person.secondname)
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
                                  .collection('CalendarSheetHome')
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

Future<String> _getEmailBody() async {
  Map<String, dynamic> userInfo = _getUserInfo();
  Map<String, dynamic> appInfo = await _getAppInfo();
  Map<String, dynamic> deviceInfo = await _getDeviceInfo();

  String body = "";

  body += "==============\n";
  body += "아래는 문의하시는 사용자 정보로, 참고용입니다.\n\n";

  userInfo.forEach((key, value) {
    body += "$key: $value\n";
  });

  appInfo.forEach((key, value) {
    body += "$key: $value\n";
  });

  deviceInfo.forEach((key, value) {
    body += "$key: $value\n\n";
  });

  body += "==============\n\n";
  body += "아래에 오류 및 건의사항을 적어주시면 됩니다.문의하신 내용은 업데이트에 최대한 반영해보도록 하겠습니다.감사합니다!\n\n";
  body += "==============\n\n";
  return body;
}

Map<String, dynamic> _getUserInfo() {
  String name = Hive.box('user_info').get('id');
  String email = Hive.box('user_info').get('email');
  return {"사용자 이름": name, "사용자 이메일": email};
}

Future<Map<String, dynamic>> _getDeviceInfo() async {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> deviceData = <String, dynamic>{};

  try {
    if (GetPlatform.isAndroid == true) {
      deviceData = _readAndroidDeviceInfo(await deviceInfoPlugin.androidInfo);
    } else if (GetPlatform.isIOS == true) {
      deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    }
  } catch (error) {
    deviceData = {"Error": "Failed to get platform version."};
  }

  return deviceData;
}

Map<String, dynamic> _readAndroidDeviceInfo(AndroidDeviceInfo info) {
  var release = info.version.release;
  var sdkInt = info.version.sdkInt;
  var manufacturer = info.manufacturer;
  var model = info.model;

  return {
    "OS 버전": "Android $release (SDK $sdkInt)",
    "기기": "$manufacturer $model"
  };
}

Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo info) {
  var systemName = info.systemName;
  var version = info.systemVersion;
  var machine = info.utsname.machine;

  return {"OS 버전": "$systemName $version", "기기": "$machine"};
}

Future<Map<String, dynamic>> _getAppInfo() async {
  PackageInfo info = await PackageInfo.fromPlatform();
  return {"앱 버전": info.version};
}
