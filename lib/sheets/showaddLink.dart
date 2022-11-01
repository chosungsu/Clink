import 'package:clickbyme/Tool/Getx/selectcollection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info/package_info.dart';
import '../Tool/BGColor.dart';
import '../Tool/FlushbarStyle.dart';
import '../Tool/TextSize.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../mongoDB/mongodatabase.dart';

linkstation(
  BuildContext context,
  TextEditingController textEditingController_add_sheet,
  FocusNode searchNode_add_section,
  selectcollection scollection,
  String username,
) {
  return SizedBox(
      child: Padding(
    padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
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
        title(context),
        const SizedBox(
          height: 20,
        ),
        content(context, textEditingController_add_sheet,
            searchNode_add_section, scollection, username),
        const SizedBox(
          height: 20,
        ),
      ],
    ),
  ));
}

title(
  BuildContext context,
) {
  return SizedBox(
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('컬렉션 추가',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25))
        ],
      ));
}

content(
  BuildContext context,
  TextEditingController textEditingController_add_sheet,
  FocusNode searchNode_add_section,
  selectcollection scollection,
  String username,
) {
  bool serverstatus = Hive.box('user_info').get('server_status');
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final updatelist = [];

  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      children: [
        TextField(
          minLines: 2,
          maxLines: 2,
          focusNode: searchNode_add_section,
          style: TextStyle(fontSize: contentTextsize(), color: Colors.black),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: 2,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
                width: 2,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            contentPadding: const EdgeInsets.only(left: 10),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            filled: true,
            fillColor: Colors.grey.shade200,
            isCollapsed: true,
            hintText: '추가할 컬렉션 입력',
            hintStyle:
                TextStyle(fontSize: contentTextsize(), color: Colors.black45),
          ),
          controller: textEditingController_add_sheet,
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 50,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                primary: ButtonColor(),
              ),
              onPressed: () async {
                if (textEditingController_add_sheet.text.isEmpty) {
                  Snack.show(
                      title: '알림',
                      content: '추가할 컬렉션이 비어있어요!',
                      context: context,
                      snackType: SnackType.warning);
                } else {
                  if (serverstatus) {
                    await MongoDB.find(
                        collectionname: 'linknet',
                        query: 'username',
                        what: username);
                    if (MongoDB.res == null) {
                      await MongoDB.add(collectionname: 'linknet', addlist: {
                        'username': username,
                        'link': [textEditingController_add_sheet.text],
                      });
                    } else {
                      await MongoDB.getData(collectionname: 'linknet')
                          .then((value) {
                        updatelist.clear();
                        for (int j = 0; j < value.length; j++) {
                          final user = value[j]['username'];
                          if (user == username) {
                            for (int i = 0; i < value[j]['link'].length; i++) {
                              updatelist.add(value[j]['link'][i]);
                            }
                          }
                        }
                      });
                      updatelist.add(textEditingController_add_sheet.text);
                      await MongoDB.update(
                          collectionname: 'linknet',
                          query: 'username',
                          what: username,
                          updatelist: {
                            'link': updatelist,
                          });
                    }
                    Snack.show(
                        context: context,
                        title: '알림',
                        content: '정상적으로 추가되었습니다.',
                        snackType: SnackType.info,
                        behavior: SnackBarBehavior.floating);
                  } else {
                    updatelist.clear();
                    var id = '';
                    firestore.collection('MemoCollections').get().then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        if (value.docs[i].get('madeUser') == username) {
                          updatelist.add(value.docs[i].get('title'));
                          id = value.docs[i].id;
                        }
                      }
                      firestore.collection('MemoCollections').doc(id).delete();
                    });
                    firestore.collection('MemoCollections').add({
                      'madeUser': username,
                      'title': updatelist,
                    }).whenComplete(() {
                      setState(() {
                        textEditingController_add_sheet.clear();
                        Snack.show(
                            context: context,
                            title: '알림',
                            content: '정상적으로 추가되었습니다.',
                            snackType: SnackType.info,
                            behavior: SnackBarBehavior.floating);
                      });
                    });
                  }
                  Get.back();
                }
              },
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: NeumorphicText(
                        '생성하기',
                        style: const NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          depth: 3,
                          color: Colors.white,
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize(),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
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
