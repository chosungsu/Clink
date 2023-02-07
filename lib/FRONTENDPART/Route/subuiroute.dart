// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, unused_local_variable

import 'dart:async';
import 'dart:io';
import 'package:clickbyme/Enums/Variables.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/sheets/BottomSheet/AddContent.dart';
import 'package:clickbyme/sheets/Mainpage/appbarplusbtn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:status_bar_control/status_bar_control.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../BACKENDPART/FIREBASE/NoticeVP.dart';
import '../Page/LoginSignPage.dart';
import '../../Tool/AndroidIOS.dart';
import '../../Tool/BGColor.dart';
import '../../Tool/FlushbarStyle.dart';
import '../../Tool/Getx/linkspacesetting.dart';
import '../../Tool/Getx/navibool.dart';
import '../../Tool/Getx/notishow.dart';
import '../../Tool/Getx/uisetting.dart';
import '../../Tool/TextSize.dart';
import 'mainroute.dart';

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
  Hive.box('user_setting').put('currentmypage', 0);
  Get.to(() => const mainroute(), transition: Transition.fade);
}

GoToLogin(String s) {
  Timer? _time = Timer(const Duration(seconds: 0), () {
    Get.to(() => LoginSignPage(first: s));
  });

  return _time;
}

Future getAppInfo({tomail = false}) async {
  info = await PackageInfo.fromPlatform();
  versioninfo = info.version;
  if (tomail) {
    return {"앱 버전": versioninfo};
  } else {}
}

closenotiroom() {
  final draw = Get.put(navibool());
  final uiset = Get.put(uisetting());

  if (draw.drawnoticeopen) {
    draw.setclosenoti();
    Hive.box('user_setting').put('noticepage_opened', false);
    uiset.setpageindex(0);
  } else {}
}

deletenoti(context) async {
  var deleteid = '';
  var updateusername = [];
  final notilist = Get.put(notishow());
  List deletenotiindexlist = [notilist.checkboxnoti.indexOf(true)];
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
    if (deletenotiindexlist[0] == -1) {
      //선택 안한 경우
      Snack.snackbars(
          context: context,
          title: '삭제할 알림을 선택해주세요',
          backgroundcolor: Colors.black,
          bordercolor: draw.backgroundcolor);
    } else {
      for (int i = 0; i < deletenotiindexlist.length; i++) {
        deletelist.insert(i, notilist.listad[deletenotiindexlist[i]].title);
      }
      if (deletelist.length == notilist.listad.length) {
        //전체 삭제인 경우
        firestore.collection('AppNoticeByUsers').get().then((value) {
          for (var element in value.docs) {
            if (element.get('sharename').toString().contains(name) == true) {
              deleteid = element.id;
              updateusername =
                  element.get('sharename').toString().split(',').toList();
              if (updateusername.length == 1) {
                firestore.collection('AppNoticeByUsers').doc(deleteid).delete();
              } else {
                updateusername.removeWhere(
                    (element) => element.toString().contains(name));
                firestore
                    .collection('AppNoticeByUsers')
                    .doc(deleteid)
                    .update({'sharename': updateusername});
              }
            } else {
              if (element.get('username').toString() == name) {
                deleteid = element.id;
                firestore.collection('AppNoticeByUsers').doc(deleteid).delete();
              } else {}
            }
          }
        }).whenComplete(() {
          notilist.allcheck = false;
          notilist.isreadnoti();
        });
      } else {
        //개별 삭제인 경우
        firestore.collection('AppNoticeByUsers').get().then((value) {
          for (var element in value.docs) {
            if (deletelist.contains(element.get('title'))) {
              if (element.get('sharename').toString().contains(name) == true) {
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
                      (element) => element.toString().contains(name));
                  firestore
                      .collection('AppNoticeByUsers')
                      .doc(deleteid)
                      .update({'sharename': updateusername});
                }
              } else {
                if (element.get('username').toString() == name) {
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
          notilist.allcheck = false;
          notilist.isreadnoti();
        });
      }
    }
  }
}

func3(BuildContext context) => Future.delayed(const Duration(seconds: 0), () {
      final linkspaceset = Get.put(linkspacesetting());
      final uiset = Get.put(uisetting());
      if (linkspaceset.color == draw.backgroundcolor) {
        StatusBarControl.setColor(draw.backgroundcolor, animated: true);
      } else {
        StatusBarControl.setColor(linkspaceset.color, animated: true);
      }
      if (uiset.pagenumber == 3 ||
          uiset.pagenumber == 4 ||
          uiset.pagenumber == 5) {
        uiset.setpageindex(0);
        Get.to(() => const mainroute(), transition: Transition.downToUp);
      } else {
        Get.back();
      }
    });
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
  var email = uiset.editpagelist[0].email!;
  var origin = uiset.editpagelist[0].username!;
  var id = uiset.editpagelist[0].id!;

  await firestore.collection('Favorplace').get().then((value) {
    if (value.docs.isEmpty) {
      firestore.collection('Favorplace').add({
        'title': title,
        'email': email,
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
          'email': email,
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
    uiset.setloading(false);
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
  return SizedBox(
    height: 60,
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

  uiset.setloading(true);
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
      uiset.setloading(false);
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

        FileDownloader.downloadFile(
            url: downloadurl,
            name: downloadname,
            onDownloadCompleted: (path) {
              httpsReference.writeToFile(pathseveral);
              Snack.snackbars(
                  context: context,
                  title: '다운로드 완료됨.',
                  backgroundcolor: Colors.green,
                  bordercolor: draw.backgroundcolor);
            });
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
        uiset.setloading(false);
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
