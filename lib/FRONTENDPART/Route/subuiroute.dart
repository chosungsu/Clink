// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, unused_local_variable

import 'dart:async';
import 'dart:io';
import 'package:clickbyme/BACKENDPART/FIREBASE/PersonalVP.dart';
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
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:status_bar_control/status_bar_control.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Page/AddTemplate.dart';
import '../Page/LoginSignPage.dart';
import '../Page/Spacepage.dart';
import '../../Tool/AndroidIOS.dart';
import '../../Tool/BGColor.dart';
import '../../Tool/FlushbarStyle.dart';
import '../../Tool/Getx/linkspacesetting.dart';
import '../../Tool/Getx/navibool.dart';
import '../../Tool/Getx/notishow.dart';
import '../../Tool/Getx/uisetting.dart';
import '../../Tool/TextSize.dart';
import '../../sheets/movetolinkspace.dart';
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
  Get.to(() => const mainroute(index: 0), transition: Transition.fade);
}

GoToLogin(String s) {
  Timer? _time = Timer(const Duration(seconds: 0), () {
    Get.to(() => LoginSignPage(first: s));
  });

  return _time;
}

func2(BuildContext context) async {
  var updateid = '';
  var updateusername = [];
  final notilist = Get.put(notishow());
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
    firestore.collection('AppNoticeByUsers').get().then((value) {
      for (var element in value.docs) {
        if (element.get('sharename').toString().contains(name) == true) {
          updateid = element.id;
          updateusername =
              element.get('sharename').toString().split(',').toList();
          if (updateusername.length == 1) {
            firestore.collection('AppNoticeByUsers').doc(updateid).delete();
          } else {
            updateusername
                .removeWhere((element) => element.toString().contains(name));
            firestore
                .collection('AppNoticeByUsers')
                .doc(updateid)
                .update({'sharename': updateusername});
          }
        } else {
          if (element.get('username').toString() == name) {
            updateid = element.id;
            firestore.collection('AppNoticeByUsers').doc(updateid).delete();
          } else {}
        }
      }
    }).whenComplete(() {
      notilist.isreadnoti();
    });
  }
}

func3(BuildContext context) => Future.delayed(const Duration(seconds: 0), () {
      if (linkspaceset.color == draw.backgroundcolor) {
        StatusBarControl.setColor(draw.backgroundcolor, animated: true);
      } else {
        StatusBarControl.setColor(linkspaceset.color, animated: true);
      }
      if (Hive.box('user_setting').get('page_index') == 3 ||
          Hive.box('user_setting').get('page_index') == 4 ||
          Hive.box('user_setting').get('page_index') == 5) {
        Hive.box('user_setting').put('page_index', 0);
        Get.to(
            () => const mainroute(
                  index: 0,
                ),
            transition: Transition.downToUp);
        /*Navigator.of(context).pushReplacement(
          PageTransition(
            type: PageTransitionType.fade,
            child: const mainroute(
              index: 0,
            ),
          ),
        );*/
      } else {
        Get.back();
      }
    });
func4_changever(context) async {
  var checkid = '';
  Widget title;
  Widget content;
  if (Hive.box('user_setting').get('page_index') == 11 ||
      Hive.box('user_setting').get('page_index') == 12) {
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
    title = Widgets_plusbtn(context)[0];
    content = Widgets_plusbtn(context)[1];
    AddContent(context, title, content, null);
  } else {
    Snack.snackbars(
        context: context,
        title: '접근권한이 없어요!',
        backgroundcolor: Colors.red,
        bordercolor: draw.backgroundcolor);
  }
}

func4(BuildContext context, indexcnt) async {
  var checkid = '';
  if (Hive.box('user_setting').get('page_index') == 11 ||
      Hive.box('user_setting').get('page_index') == 12) {
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
              uiset.pagelist[uiset.mypagelistindex].title) {
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
    Get.to(
        () => AddTemplate(
              id: checkid,
              indexcnt: indexcnt,
            ),
        transition: Transition.upToDown);
  } else {
    Snack.snackbars(
        context: context,
        title: '접근권한이 없어요!',
        backgroundcolor: Colors.red,
        bordercolor: draw.backgroundcolor);
  }
}

func5() {
  Get.to(() => const Spacepage(), transition: Transition.upToDown);
}

func6(
    BuildContext context,
    TextEditingController textEditingController,
    FocusNode searchnode,
    String where,
    String id,
    int categorypicknumber,
    int indexcnt) {
  addmylink(context, usercode, textEditingController, searchnode, where, id,
      categorypicknumber, indexcnt);
}

func7(String title, String email, String origin, String id) async {
  var deleteid = '';

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

CompanyNotice(
  String str,
) {
  final draw = Get.put(navibool());
  final uiset = Get.put(uisetting());

  return StreamBuilder<QuerySnapshot>(
    stream: CompanyNoticeStreamFamily(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        CompanyNoticeChild1(snapshot, 'home');
        return listcompanytousers.isEmpty
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        draw.setclose();
                        launchUrl(CompanyNoticeChild1(snapshot, 'home'));
                      },
                      child: ContainerDesign(
                        color: draw.backgroundcolor,
                        child: SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.campaign,
                                color: draw.color_textstatus,
                                size: 30,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                  fit: FlexFit.tight,
                                  child: Text(
                                    listcompanytousers[0].title,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: draw.color_textstatus,
                                        fontWeight: FontWeight.bold,
                                        fontSize: contentTextsize()),
                                    overflow: TextOverflow.ellipsis,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ));
      }
      return LinearProgressIndicator(
        backgroundColor: BGColor(),
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
      );
    },
  );
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
  final path = mainid + '/';
  var ref;
  var snapshot;
  final urllist = [];
  linkspaceset.setcompleted(true);
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
      linkspaceset.setcompleted(false);
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
        linkspaceset.setcompleted(false);
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
