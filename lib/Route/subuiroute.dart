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
import 'package:url_launcher/url_launcher.dart';
import '../DB/PageList.dart';
import '../Page/LoginSignPage.dart';
import '../Tool/BGColor.dart';
import '../Tool/Getx/linkspacesetting.dart';
import '../Tool/Getx/navibool.dart';
import '../Tool/Getx/selectcollection.dart';
import '../Tool/Getx/uisetting.dart';
import '../Tool/NoBehavior.dart';
import '../Tool/TextSize.dart';
import '../UI/Home/firstContentNet/DayScript.dart';
import '../mongoDB/mongodatabase.dart';
import '../sheets/linksettingsheet.dart';
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

GoToMain(BuildContext context) async {
  Timer? _time = Timer(const Duration(seconds: 0), () {
    Get.to(() => const mainroute(index: 0), transition: Transition.leftToRight);
    Hive.box('user_setting').put('page_index', 0);
  });
  return _time;
}

GoToLogin(BuildContext context, String s) {
  Timer? _time = Timer(const Duration(seconds: 0), () {
    Get.to(() => LoginSignPage(first: s));
  });

  return _time;
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
