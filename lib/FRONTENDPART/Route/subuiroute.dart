// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, unused_local_variable

import 'dart:async';
import 'dart:io';
import 'package:clickbyme/BACKENDPART/Enums/Variables.dart';
import 'package:clickbyme/FRONTENDPART/Page/SettingPage.dart';
import 'package:clickbyme/FRONTENDPART/Page/SettingSubPage.dart';
import 'package:clickbyme/main.dart';
import 'package:clickbyme/sheets/BottomSheet/AddContent.dart';
import 'package:clickbyme/sheets/BSContents/appbarplusbtn.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../BACKENDPART/Enums/PushNotification.dart';
import '../../Tool/AndroidIOS.dart';
import '../../Tool/FlushbarStyle.dart';
import '../../BACKENDPART/Getx/linkspacesetting.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../BACKENDPART/Getx/notishow.dart';
import '../../BACKENDPART/Getx/uisetting.dart';
import '../../Tool/TextSize.dart';

///checkForInitialMessage
///
///알람을 받은 현황이 있는지 체크합니다.
void checkForInitialMessage() async {
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    PushNotification notifications = PushNotification(
      title: message.notification?.title,
      body: message.notification?.body,
    );
  });
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    PushNotification notifications = PushNotification(
      title: initialMessage.notification?.title,
      body: initialMessage.notification?.body,
    );
  }
}

Future<bool> onWillPop(context) async {
  final uiset = Get.put(uisetting());
  final draw = Get.put(navibool());
  final searchNode = FocusNode();
  List<int> navinumlist = [0, 1, 2, 3];
  uiset.setmypagelistindex(Hive.box('user_setting').get('currentmypage') ?? 0);
  if (draw.drawopen == true) {
    draw.setclose();
  } else if (draw.settinginsidemap.containsKey(1) == true ||
      draw.settinginsidemap.containsKey(2) == true) {
    if (draw.settinginsidemap.containsKey(1) == true) {
      draw.clicksettinginside(0, false);
    } else if (draw.settinginsidemap.containsKey(2) == true) {
      draw.clicksettinginside(1, true);
    }
    Get.back();
  } else if (uiset.searchpagemove != '') {
    uiset.searchpagemove = '';
    uiset.textrecognizer = '';
    searchNode.unfocus();
    uiset.pagenumber = 1;
  } else if (uiset.pagenumber != 0) {
    uiset.setpageindex(0);
    //Get.to(() => const mainroute(), transition: Transition.fade);
  } else {
    return await Get.dialog(OSDialog(
            context,
            '종료',
            Text('앱을 종료하시겠습니까?',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize())),
            pressed1)) ??
        false;
  }
  return false;
}

void pressed1() {
  Hive.box('user_info').get('autologin') == false
      ? Hive.box('user_info').delete('id')
      : null;
  SystemNavigator.pop();
}

void pressed2() {
  Get.back(result: true);
}

GoToMain() {
  final uiset = Get.put(uisetting());
  Hive.box('user_setting').put('currentmypage', 0);
  uiset.setpageindex(uiset.pagenumber);
  Get.back();
}

GoToStartApp() {
  Get.offAll(() => const SplashPage(), transition: Transition.fade);
}

GoToSettingPage() async {
  final draw = Get.put(navibool());
  draw.setclose();
  draw.clicksettinginside(1, true);
  Get.to(() => const SettingPage(), transition: Transition.fade);
}

GoToSettingSubPage() async {
  final draw = Get.put(navibool());
  draw.clicksettinginside(2, true);
  Get.to(() => const SettingSubPage(), transition: Transition.fade);
}

Future<String> getEmailBody() async {
  Map<String, dynamic> userInfo = getUserInfo();
  Map<String, dynamic> appInfo = await getAppInfo(tomail: true);
  Map<String, dynamic> deviceInfo = await getDeviceInfo();

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

Map<String, dynamic> getUserInfo() {
  String name = Hive.box('user_info').get('id');
  String email = Hive.box('user_info').get('email');
  return {"사용자 이름": name, "사용자 이메일": email};
}

Future<Map<String, dynamic>> getDeviceInfo() async {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> deviceData = <String, dynamic>{};

  try {
    if (GetPlatform.isAndroid == true) {
      deviceData = readAndroidDeviceInfo(await deviceInfoPlugin.androidInfo);
    } else if (GetPlatform.isIOS == true) {
      deviceData = readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    }
  } catch (error) {
    deviceData = {"Error": "Failed to get platform version."};
  }

  return deviceData;
}

Map<String, dynamic> readAndroidDeviceInfo(AndroidDeviceInfo info) {
  var release = info.version.release;
  var sdkInt = info.version.sdkInt;
  var manufacturer = info.manufacturer;
  var model = info.model;

  return {
    "OS 버전": "Android $release (SDK $sdkInt)",
    "기기": "$manufacturer $model"
  };
}

Map<String, dynamic> readIosDeviceInfo(IosDeviceInfo info) {
  var systemName = info.systemName;
  var version = info.systemVersion;
  var machine = info.utsname.machine;

  return {"OS 버전": "$systemName $version", "기기": "$machine"};
}

Future getAppInfo({tomail = false}) async {
  info = await PackageInfo.fromPlatform();
  versioninfo = info.version;
  if (tomail) {
    return {"앱 버전": versioninfo};
  } else {}
}

deletenoti(context) async {
  var deleteid = '';
  var updateusername = [];
  final notilist = Get.put(notishow());
  List deletenotiindexlist = [];
  for (int i = 0; i < notilist.checkboxnoti.length; i++) {
    if (notilist.checkboxnoti[i] == true) {
      deletenotiindexlist.add(i);
    }
  }
  List deletelist = [];
  final reloadpage = await Get.dialog(OSDialog(
          context,
          '경고',
          Text('알림들을 삭제하시겠습니까?',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: contentTextsize(),
                  color: Colors.blueGrey)),
          pressed2)) ??
      false;
  if (reloadpage) {
    if (deletenotiindexlist.isEmpty) {
      //선택 안한 경우
      Snack.snackbars(
          context: context,
          title: '삭제할 알림을 선택해주세요',
          backgroundcolor: Colors.black,
          bordercolor: draw.backgroundcolor);
    } else {
      for (int i = 0; i < deletenotiindexlist.length; i++) {
        deletelist.insert(
            i, notilist.listappnoti[deletenotiindexlist[i]].title);
      }
      if (deletelist.length == notilist.listappnoti.length) {
        //전체 삭제인 경우
        firestore.collection('AppNoticeByUsers').get().then((value) {
          for (var element in value.docs) {
            if (element.get('sharename').toString().contains(appnickname) ==
                true) {
              deleteid = element.id;
              updateusername =
                  element.get('sharename').toString().split(',').toList();
              if (updateusername.length == 1) {
                firestore.collection('AppNoticeByUsers').doc(deleteid).delete();
              } else {
                updateusername.removeWhere(
                    (element) => element.toString().contains(appnickname));
                firestore
                    .collection('AppNoticeByUsers')
                    .doc(deleteid)
                    .update({'sharename': updateusername});
              }
            } else {
              if (element.get('username').toString() == appnickname) {
                deleteid = element.id;
                firestore.collection('AppNoticeByUsers').doc(deleteid).delete();
              } else {}
            }
          }
        }).whenComplete(() {
          notilist.isreadnoti();
          notilist.resetcheckboxnoti();
        });
      } else {
        //개별 삭제인 경우
        firestore.collection('AppNoticeByUsers').get().then((value) {
          for (var element in value.docs) {
            if (deletelist.contains(element.get('title'))) {
              if (element.get('sharename').toString().contains(appnickname) ==
                  true) {
                deleteid = element.id;
                updateusername =
                    element.get('sharename').toString().split(',').toList();
                if (updateusername.length == 1) {
                  firestore
                      .collection('AppNoticeByUsers')
                      .doc(deleteid)
                      .delete();
                } else {
                  updateusername.removeWhere(
                      (element) => element.toString().contains(appnickname));
                  firestore
                      .collection('AppNoticeByUsers')
                      .doc(deleteid)
                      .update({'sharename': updateusername});
                }
              } else {
                if (element.get('username').toString() == appnickname) {
                  deleteid = element.id;
                  firestore
                      .collection('AppNoticeByUsers')
                      .doc(deleteid)
                      .delete();
                } else {}
              }
            }
          }
        }).whenComplete(() {
          notilist.isreadnoti();
          notilist.resetcheckboxnoti();
        });
      }
      if (notilist.allcheck) {
        notilist.allcheck = false;
      } else {}
    }
  }
}

func4(context, textcontroller, searchnode, where, id, categorypicknum) async {
  final uiset = Get.put(uisetting());
  var checkid = '';
  Widget title;
  Widget content;
  if (uiset.pagenumber == 11 || uiset.pagenumber == 12) {
    await firestore.collection('Favorplace').get().then((value) {
      checkid = '';
      if (value.docs.isEmpty) {
        checkid = '';
      } else {
        final valuespace = value.docs;

        for (int i = 0; i < valuespace.length; i++) {
          if (valuespace[i]['title'] ==
              (Hive.box('user_setting').get('currenteditpage') ?? '')) {
            if (valuespace[i]['setting'] == 'block') {
            } else {
              checkid = valuespace[i]['id'];
            }
          }
        }
      }
    });
  } else {
    await firestore.collection('Pinchannel').get().then((value) {
      checkid = '';
      if (value.docs.isEmpty) {
        checkid = '';
      } else {
        final valuespace = value.docs;

        for (int i = 0; i < valuespace.length; i++) {
          if (valuespace[i]['linkname'] ==
              uiset.pagelist[Hive.box('user_setting').get('currentmypage')]
                  .title) {
            if (valuespace[i]['setting'] == 'block') {
              if (valuespace[i]['username'] == usercode) {
                checkid = valuespace[i].id;
              } else {}
            } else {
              checkid = valuespace[i].id;
            }
          }
        }
      }
    });
  }
  if (checkid != '') {
    textcontroller.text = '';
    uiset.checktf(true);
    title = Widgets_plusbtn(context, checkid, textcontroller, searchnode, where,
        id, categorypicknum)[0];
    content = Widgets_plusbtn(context, checkid, textcontroller, searchnode,
        where, id, categorypicknum)[1];
    AddContent(context, title, content, searchnode);
  } else {
    Snack.snackbars(
        context: context,
        title: '접근권한이 없어요!',
        backgroundcolor: Colors.red,
        bordercolor: draw.backgroundcolor);
  }
}

func7() async {
  final uiset = Get.put(uisetting());
  var deleteid = '';
  var title = uiset.editpagelist[0].title;
  var setting = uiset.editpagelist[0].setting;
  var origin = uiset.editpagelist[0].username!;
  var id = uiset.editpagelist[0].id!;

  await firestore.collection('Favorplace').get().then((value) {
    if (value.docs.isEmpty) {
      firestore.collection('Favorplace').add({
        'title': title,
        'originuser': origin,
        'favoradduser': usercode,
        'id': id,
        'setting': 'block'
      });
    } else {
      final valuespace = value.docs;
      for (int i = 0; i < valuespace.length; i++) {
        if (valuespace[i]['favoradduser'] == usercode) {
          if (valuespace[i]['title'] == title) {
            deleteid = valuespace[i].id;
          }
        }
      }
      if (deleteid == '') {
        firestore.collection('Favorplace').add({
          'title': title,
          'originuser': origin,
          'favoradduser': usercode,
          'id': id,
          'setting': 'block'
        });
      } else {
        firestore.collection('Favorplace').doc(deleteid).delete();
        Hive.box('user_setting').put('currenteditpage', null);
      }
    }
    uiset.setloading(false, 0);
  });
}

ADSHOW() {
  /*TargetPlatform os = Theme.of(context).platform;

  BannerAd banner = BannerAd(
    listener: BannerAdListener(
      onAdFailedToLoad: (Ad ad, LoadAdError error) {},
      onAdLoaded: (_) {},
    ),
    size: AdSize.banner,
    adUnitId: UNIT_ID[os == TargetPlatform.iOS ? 'ios' : 'android']!,
    request: const AdRequest(),
  )..load();
  return Container(
    height: 50,
    child: AdWidget(ad: banner),
  );*/
  return GetBuilder<navibool>(builder: (_) {
    return Container(
      height: 60,
      color: draw.backgroundcolor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              '광고공간입니다',
              style: TextStyle(
                  color: Colors.grey.shade300,
                  fontWeight: FontWeight.bold,
                  fontSize: contentTextsize()),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  });
}

searchfiles(
    BuildContext context, String mainid, FilePickerResult? result) async {
  final linkspaceset = Get.put(linkspacesetting());
  final filenames = [];
  if (result != null) {
    for (int i = 0; i < result.files.length; i++) {
      linkspaceset.selectedfile!.add({
        'name': result.files[i].name,
        'size': result.files[i].size,
        'path': result.files[i].path,
      });
    }
    linkspaceset.pickedFilefirst = result.files.first;
  } else {
    return;
  }
}

uploadfiles(String mainid) async {
  final linkspaceset = Get.put(linkspacesetting());
  final uiset = Get.put(uisetting());
  final path = mainid + '/';
  var ref;
  var snapshot;
  final urllist = [];

  uiset.setloading(true, 0);
  for (int i = 0; i < linkspaceset.selectedfile!.length; i++) {
    ref = FirebaseStorage.instance
        .ref()
        .child(path + linkspaceset.selectedfile![i]['name']);
    snapshot = await ref.putFile(File(linkspaceset.selectedfile![i]['path']));
    urllist.add(await snapshot.ref.getDownloadURL());
  }
  await firestore
      .collection('Pinchannelin')
      .doc(mainid)
      .get()
      .then((value) async {
    linkspaceset.changeurllist.clear();
    for (int j = 0; j < value.data()!['spaceentercontent'].length; j++) {
      linkspaceset.changeurllist.add(value.data()!['spaceentercontent'][j]);
    }
    for (int k = 0; k < urllist.length; k++) {
      linkspaceset.changeurllist.add(urllist[k]);
    }
    await firestore.collection('Pinchannelin').doc(mainid).update(
        {'spaceentercontent': linkspaceset.changeurllist}).whenComplete(() {
      uiset.setloading(false, 0);
    });
  });
  Get.back();
}

Future<void> downloadFileExample(String mainid, BuildContext context) async {
  List downloadfile = [];
  List downloadfilesubname = [];
  String downloadname = '';
  String downloadurl = '';
  var pathseveral;

  var httpsReference;

  final storageRef = FirebaseStorage.instance.ref();
  final linkspaceset = Get.put(linkspacesetting());
  await _requestPermission(context);
  var status = await Permission.storage.status;
  if (status.isGranted) {
    Directory? appDocDir = await getExternalStorageDirectory();
    List folders = appDocDir!.path.split('/');
    String newpath = '';
    for (int x = 1; x < folders.length; x++) {
      String folder = folders[x];
      if (folder != 'Android') {
        newpath += '/' + folder;
      } else {
        break;
      }
    }
    newpath = newpath + '/LinkAI';
    appDocDir = Directory(newpath);
    if (!await appDocDir.exists()) {
      await appDocDir.create(recursive: true);
    } else {}
    if (linkspaceset.ischecked.any((element) => element == true) == true) {
      for (int i = 0; i < linkspaceset.inindextreetmp.length; i++) {
        if (linkspaceset.ischecked[i] == true) {
          downloadfile.add(linkspaceset.inindextreetmp[i].placeentercode);
          downloadfilesubname.add(linkspaceset.inindextreetmp[i].substrcode);
        } else {}
      }
      for (int j = 0; j < downloadfile.length; j++) {
        downloadurl = downloadfile[j];
        downloadname = downloadfilesubname[j];
        httpsReference = storageRef.child(mainid + "/$downloadname");
        //httpsReference = FirebaseStorage.instance.refFromURL(downloadfile[i]);
        pathseveral = File(appDocDir.path + '/' + downloadname);

        /*FileDownloader.downloadFile(
            url: downloadurl,
            name: downloadname,
            onDownloadCompleted: (path) {
              httpsReference.writeToFile(pathseveral);
              Snack.snackbars(
                  context: context,
                  title: '다운로드 완료됨.',
                  backgroundcolor: Colors.green,
                  bordercolor: draw.backgroundcolor);
            });*/
      }
    } else {
      Snack.snackbars(
          context: context,
          title: '선택된 항목이 없습니다.',
          backgroundcolor: Colors.black,
          bordercolor: draw.backgroundcolor);
    }
  } else {
    await _requestPermission(context);
  }
}

Future<void> deleteFileExample(String mainid, BuildContext context) async {
  List downloadfile = [];
  List checkedindex = [];
  var httpsReference;
  String downloadname = '';
  final storageRef = FirebaseStorage.instance.ref();
  final linkspaceset = Get.put(linkspacesetting());
  final uiset = Get.put(uisetting());

  downloadfile.add(linkspaceset
      .inindextreetmp[linkspaceset.islongchecked.indexOf(true)].substrcode);
  downloadname = downloadfile[0];
  httpsReference =
      storageRef.child(mainid + "/$downloadname").delete().whenComplete(() {
    firestore.collection('Pinchannelin').doc(mainid).get().then((value) async {
      linkspaceset.changeurllist.clear();
      for (int j = 0; j < value.data()!['spaceentercontent'].length; j++) {
        linkspaceset.changeurllist.add(value.data()!['spaceentercontent'][j]);
      }
      if (linkspaceset.changeurllist.contains(linkspaceset
          .inindextreetmp[linkspaceset.islongchecked.indexOf(true)]
          .placeentercode)) {
        linkspaceset.changeurllist.removeAt(linkspaceset.changeurllist.indexOf(
            linkspaceset
                .inindextreetmp[linkspaceset.islongchecked.indexOf(true)]
                .placeentercode));
      }
      await firestore.collection('Pinchannelin').doc(mainid).update(
          {'spaceentercontent': linkspaceset.changeurllist}).whenComplete(() {
        uiset.setloading(false, 0);
        Snack.snackbars(
            context: context,
            title: '삭제가 완료됨.',
            backgroundcolor: Colors.red,
            bordercolor: draw.backgroundcolor);
      });
    });
  });
}

Future<void> _requestPermission(BuildContext context) async {
  var status = await Permission.storage.status;
  if (status.isDenied) {
    Snack.snackbars(
        context: context,
        title: '권한 허용하여야 정상 다운로드가능합니다.',
        backgroundcolor: Colors.black,
        bordercolor: draw.backgroundcolor);
    await Permission.storage.request();
  } else if (status.isPermanentlyDenied) {
    await openAppSettings();
  } else {
    if (status.isGranted) {
    } else {
      await Permission.storage.request();
    }
  }
}
