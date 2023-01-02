// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/Getx/notishow.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:status_bar_control/status_bar_control.dart';
import '../../BACKENDPART/FIREBASE/PersonalVP.dart';
import '../../Enums/Variables.dart';
import '../../Tool/Loader.dart';
import '../Route/mainroute.dart';
import '../Route/subuiroute.dart';
import '../../Tool/AppBarCustom.dart';
import '../../Tool/Getx/navibool.dart';
import '../../Tool/NoBehavior.dart';
import '../../UI/Home/firstContentNet/ChooseCalendar.dart';
import '../../UI/Home/firstContentNet/DayNoteHome.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'DrawerScreen.dart';

class NotiAlarm extends StatefulWidget {
  const NotiAlarm({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _NotiAlarmState();
}

class _NotiAlarmState extends State<NotiAlarm>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final notilist = Get.put(notishow());
  final draw = Get.put(navibool());
  final readlist = [];
  final listid = [];

  @override
  void initState() {
    super.initState();
    draw.navi = 1;
    //Hive.box('user_setting').put('page_index', 5);
    Hive.box('user_setting').put('page_index', 2);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    //notilist.noticontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<navibool>(
        builder: (_) => Scaffold(
            backgroundColor: draw.backgroundcolor,
            body: SafeArea(
                child: draw.drawopen == true
                    ? Stack(
                        children: [
                          draw.navi == 0
                              ? Positioned(
                                  left: 0,
                                  child: SizedBox(
                                    width: 80,
                                    child: DrawerScreen(
                                      index: Hive.box('user_setting')
                                          .get('page_index'),
                                    ),
                                  ),
                                )
                              : Positioned(
                                  right: 0,
                                  child: SizedBox(
                                    width: 80,
                                    child: DrawerScreen(
                                      index: Hive.box('user_setting')
                                          .get('page_index'),
                                    ),
                                  ),
                                ),
                          UI(),
                          uiset.loading == true
                              ? const Loader(
                                  wherein: 'route',
                                )
                              : Container()
                        ],
                      )
                    : Stack(
                        children: [
                          UI(),
                          uiset.loading == true
                              ? const Loader(
                                  wherein: 'route',
                                )
                              : Container()
                        ],
                      ))));
  }

  UI() {
    double height = MediaQuery.of(context).size.height;
    return GetBuilder<navibool>(
        builder: (_) => AnimatedContainer(
            transform: Matrix4.translationValues(draw.xoffset, draw.yoffset, 0)
              ..scale(draw.scalefactor),
            duration: const Duration(milliseconds: 250),
            child: GetBuilder<navibool>(
              builder: (_) => GestureDetector(
                onTap: () {
                  draw.drawopen == true
                      ? setState(() {
                          draw.drawopen = false;
                          draw.setclose();
                          Hive.box('user_setting').put('page_opened', false);
                        })
                      : null;
                },
                child: SizedBox(
                  height: height,
                  child: Container(
                      color: draw.backgroundcolor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppBarCustom(
                            title: 'notipagetitle'.tr,
                            righticon: true,
                            doubleicon: false,
                            iconname: AntDesign.delete,
                          ),
                          CompanyNotice('home'),
                          allread(),
                          Flexible(
                              fit: FlexFit.tight,
                              child: SizedBox(
                                child: ScrollConfiguration(
                                  behavior: NoBehavior(),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: UserNotice(),
                                  ),
                                ),
                              )),
                          ADSHOW(),
                        ],
                      )),
                ),
              ),
            )));
  }

  allread() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          allreadBox()
        ],
      ),
    );
  }

  allreadBox() {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                for (int i = 0; i < listid.length; i++) {
                  notilist.updatenoti(listid[i]);
                  readlist[i] = 'yes';
                }
              });
            },
            child: Text(
              'notipageread'.tr,
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: contentTextsize(),
                  decoration: TextDecoration.underline),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  UserNotice() {
    return StreamBuilder<QuerySnapshot>(
      stream: NotiAlarmStreamFamily(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          NotiAlarmRes1(snapshot, listid, readlist);
          return notilist.listad.isEmpty
              ? Center(
                  child: NeumorphicText(
                    'notisearch'.tr,
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      depth: 3,
                      color: draw.color_textstatus,
                    ),
                    textStyle: NeumorphicTextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTitleTextsize(),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox(
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: notilist.listad.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              notilist.updatenoti(listid[index]);
                              setState(() {
                                readlist[index] = 'yes';
                              });
                              notilist.listad[index].title
                                      .toString()
                                      .contains('메모')
                                  ? Get.to(
                                      () => const DayNoteHome(
                                            title: '',
                                            isfromwhere: 'notihome',
                                          ),
                                      transition: Transition.rightToLeft)
                                  : Get.to(
                                      () => const ChooseCalendar(
                                            isfromwhere: 'notihome',
                                            index: 0,
                                          ),
                                      transition: Transition.rightToLeft);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                ContainerDesign(
                                  color: readlist[index] == 'no'
                                      ? draw.backgroundcolor
                                      : draw.color_textstatus,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          height: 100,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              80,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                  fit: FlexFit.tight,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        notilist.listad[index]
                                                            .title,
                                                        softWrap: true,
                                                        maxLines: 2,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: readlist[
                                                                        index] ==
                                                                    'no'
                                                                ? draw
                                                                    .color_textstatus
                                                                : draw
                                                                    .backgroundcolor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                contentTextsize()),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      )
                                                    ],
                                                  )),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    notilist.listad[index].date
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: readlist[
                                                                    index] ==
                                                                'no'
                                                            ? draw
                                                                .color_textstatus
                                                            : draw
                                                                .backgroundcolor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            contentTextsize()),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              )
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            ));
                      }),
                );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Center(child: CircularProgressIndicator())],
          ));
        }
        return SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: NeumorphicText(
                  'notisearch'.tr,
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      depth: 3,
                      color: draw.color_textstatus),
                  textStyle: NeumorphicTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: contentTitleTextsize(),
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    Future.delayed(const Duration(seconds: 0), () {
      StatusBarControl.setColor(draw.backgroundcolor, animated: true);
      draw.setnavi();
      Hive.box('user_setting').put('page_index', 0);
      Get.to(
          () => const mainroute(
                index: 0,
              ),
          transition: Transition.downToUp);
      //Get.back();
    });
    return false;
  }
}