// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:status_bar_control/status_bar_control.dart';
import 'package:url_launcher/url_launcher.dart';
import '../DB/PageList.dart';
import '../Page/AddTemplate.dart';
import '../Page/LoginSignPage.dart';
import '../Page/NotiAlarm.dart';
import '../Page/Spacepage.dart';
import '../Tool/AndroidIOS.dart';
import '../Tool/BGColor.dart';
import '../Tool/FlushbarStyle.dart';
import '../Tool/Getx/linkspacesetting.dart';
import '../Tool/Getx/navibool.dart';
import '../Tool/Getx/notishow.dart';
import '../Tool/Getx/selectcollection.dart';
import '../Tool/Getx/uisetting.dart';
import '../Tool/NoBehavior.dart';
import '../Tool/TextSize.dart';
import '../UI/Home/firstContentNet/DayScript.dart';
import '../mongoDB/mongodatabase.dart';
import '../sheets/linksettingsheet.dart';
import '../sheets/movetolinkspace.dart';
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

GoToMain() async {
  Timer? _time = Timer(const Duration(seconds: 0), () {
    Get.to(() => const mainroute(index: 0), transition: Transition.leftToRight);
  });
  return _time;
}

GoToLogin(String s) {
  Timer? _time = Timer(const Duration(seconds: 0), () {
    Get.to(() => LoginSignPage(first: s));
  });

  return _time;
}

func1() => Get.to(() => const NotiAlarm(), transition: Transition.upToDown);
func2(BuildContext context) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var updateid = '';
  var updateusername = [];
  String name = Hive.box('user_info').get('id');
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

func3() => Future.delayed(const Duration(seconds: 0), () {
      final linkspaceset = Get.put(linkspacesetting());
      if (linkspaceset.color == BGColor()) {
        StatusBarControl.setColor(BGColor(), animated: true);
      } else {
        StatusBarControl.setColor(linkspaceset.color, animated: true);
      }
      Get.back();
    });
func4(BuildContext context) async {
  final uiset = Get.put(uisetting());
  String usercode = Hive.box('user_setting').get('usercode');
  var checkid = '';
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  if (Hive.box('user_setting').get('page_index') == 11 ||
      Hive.box('user_setting').get('page_index') == 21) {
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
            ),
        transition: Transition.upToDown);
  } else {
    Snack.show(
        context: context,
        title: '알림',
        content: '접근권한이 없습니다!',
        snackType: SnackType.info,
        behavior: SnackBarBehavior.floating);
  }
}

func5() => Get.to(() => const Spaceapage(), transition: Transition.upToDown);
func6(BuildContext context, TextEditingController textEditingController,
    FocusNode searchnode) {
  String usercode = Hive.box('user_setting').get('usercode');
  addmylink(context, usercode, textEditingController, searchnode);
}

func7(String title, String email, String origin, String id) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final uiset = Get.put(uisetting());
  var deleteid = '';
  String usercode = Hive.box('user_setting').get('usercode');

  await firestore.collection('Favorplace').get().then((value) {
    if (value.docs.isEmpty) {
      firestore.collection('Favorplace').add({
        'title': title,
        'email': email,
        'originuser': origin,
        'favoradduser': usercode,
        'id': id
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
          'id': id
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
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List<CompanyPageList> listcompanytousers = [];
  var url;
  final draw = Get.put(navibool());
  bool serverstatus = Hive.box('user_info').get('server_status');
  final uiset = Get.put(uisetting());

  return serverstatus == true
      ? FutureBuilder(
          future:
              MongoDB.getData(collectionname: 'companynotice').then((value) {
            for (int j = 0; j < value.length; j++) {
              final messageyes = value[j]['showthisinapp'];
              final messagewhere = value[j]['where'];
              if (messageyes == 'yes' && messagewhere == 'home') {
                listcompanytousers.add(CompanyPageList(
                  title: value[j]['title'],
                  url: value[j]['url'],
                ));
                url = Uri.parse(value[j]['url']);
              }
            }
          }),
          builder: ((context, snapshot) {
            return listcompanytousers.isEmpty
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            draw.setclose();
                            launchUrl(Uri.parse(listcompanytousers[0].url));
                          },
                          child: Container(
                            height: 10.h,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey.shade200,
                            ),
                            child: SizedBox(
                              height: 15.h,
                              width: double.infinity,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.campaign,
                                    color: Colors.black45,
                                    size: 30,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                      fit: FlexFit.tight,
                                      child: Text(
                                        listcompanytousers[0].title,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.black45,
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
          }))
      : StreamBuilder<QuerySnapshot>(
          stream: firestore.collection('CompanyNotice').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              listcompanytousers.clear();
              final valuespace = snapshot.data!.docs;
              for (var sp in valuespace) {
                final messageText = sp.get('title');
                final messageDate = sp.get('date');
                final messageyes = sp.get('showthisinapp');
                final messagewhere = sp.get('where');
                if (messageyes == 'yes' && messagewhere == str) {
                  listcompanytousers.add(CompanyPageList(
                    title: messageText,
                    url: messageDate,
                  ));
                  url = Uri.parse(sp.get('url'));
                }
              }

              return listcompanytousers.isEmpty
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              draw.setclose();
                              launchUrl(Uri.parse(listcompanytousers[0].url));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey.shade200,
                              ),
                              child: SizedBox(
                                height: 30,
                                width: double.infinity,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.campaign,
                                      color: Colors.black45,
                                      size: 30,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                        fit: FlexFit.tight,
                                        child: Text(
                                          listcompanytousers[0].title,
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: Colors.black45,
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
  final linkspaceset = Get.put(linkspacesetting());
  //프로버전 구매시 보이지 않게 함
  /*Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //ADEvents(context)
      ],
    )*/
  return Container(
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

Speeddialmemo(
    BuildContext context,
    String usercode,
    TextEditingController controller,
    FocusNode searchNode,
    ScrollController scrollController,
    ValueNotifier<bool> isDialOpen,
    String name) {
  final uiset = Get.put(uisetting());
  return GetBuilder<uisetting>(
      builder: (_) => Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              uiset.showtopbutton == false
                  ? const SizedBox()
                  : FloatingActionButton(
                      onPressed: () {
                        scrollToTop(scrollController);
                      },
                      backgroundColor: BGColor(),
                      child: Icon(
                        Icons.arrow_upward,
                        color: TextColor(),
                      ),
                    ),
              //const SizedBox(width: 10),
              /*SpeedDial(
                  openCloseDial: isDialOpen,
                  activeIcon: Icons.close,
                  icon: Icons.add,
                  backgroundColor: Colors.blue,
                  overlayColor: BGColor(),
                  overlayOpacity: 0.4,
                  spacing: 10,
                  spaceBetweenChildren: 10,
                  children: [
                    /*SpeedDialChild(
              child: NeumorphicIcon(
                Icons.local_offer,
                size: 30,
                style: NeumorphicStyle(
                    shape: NeumorphicShape.convex,
                    depth: 2,
                    surfaceIntensity: 0.5,
                    color: TextColor(),
                    lightSource: LightSource.topLeft),
              ),
              backgroundColor: Colors.blue.shade200,
              onTap: () {
                addhashtagcollector(context, usercode, controller, searchNode,
                    'outside', scollection, isresponsive);
              },
              label: '해시태그 추가',
              labelStyle: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                  fontSize: contentTextsize()),
            ),*/
                    SpeedDialChild(
                      child: NeumorphicIcon(
                        Icons.add,
                        size: 30,
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.convex,
                            depth: 2,
                            surfaceIntensity: 0.5,
                            color: TextColor(),
                            lightSource: LightSource.topLeft),
                      ),
                      backgroundColor: Colors.orange.shade200,
                      onTap: () {
                        linkmadeplace(context, usercode, name, 'add', -1);
                      },
                      label: '필드 추가',
                      labelStyle: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize()),
                    ),
                  ]),*/
            ],
          ));
}
