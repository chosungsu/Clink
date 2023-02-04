// ignore_for_file: non_constant_identifier_names

import 'dart:ui';

import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import '../../BACKENDPART/FIREBASE/NoticeVP.dart';
import '../../Tool/AndroidIOS.dart';
import '../../Tool/Getx/notishow.dart';
import '../../Tool/Getx/uisetting.dart';
import '../../Tool/Getx/navibool.dart';
import '../../UI/Home/firstContentNet/ChooseCalendar.dart';
import '../UI(Widget/DayNoteHome.dart';

final readlist = [];
final listid = [];
final draw = Get.put(navibool());
final uiset = Get.put(uisetting());
final notilist = Get.put(notishow());

SetBoxUI() {
  bool _ischecked = false;
  return StatefulBuilder(
    builder: (context, setState) {
      return SizedBox(
          height: 30,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 30,
                  child: Checkbox(
                      value: _ischecked,
                      onChanged: (value) {
                        setState(() {
                          _ischecked = value!;
                        });
                      }),
                )
              ],
            ),
          ));
    },
  );
}

UI(
  maxWidth,
  maxHeight,
) {
  return GetBuilder<notishow>(
    builder: (_) {
      return StreamBuilder<QuerySnapshot>(
        stream: NotiAlarmStreamFamily(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            NotiAlarmRes1(snapshot, listid, readlist);
            return notilist.listad.isEmpty
                ? NotInPageScreen(
                    maxWidth,
                    maxHeight,
                  )
                : Responsivelayout(
                    Page0(
                      maxHeight,
                      maxWidth,
                    ),
                    Page1(
                      maxHeight,
                      maxWidth,
                    ));
          } else if (!snapshot.hasData) {
            return NotInPageScreen(
              maxWidth,
              maxHeight,
            );
          }
          return LinearProgressIndicator(
            backgroundColor: draw.backgroundcolor,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          );
        },
      );
    },
  );
}

NotInPageScreen(maxWidth, maxHeight) {
  return Responsivelayout(
      SizedBox(
        width: maxWidth,
        height: maxHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              AntDesign.frowno,
              color: Colors.orange,
              size: 30,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              '해당 페이지는 비어있습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: contentTextsize(), color: draw.color_textstatus),
            ),
          ],
        ),
      ),
      SizedBox(
        width: maxWidth,
        height: maxHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              AntDesign.frowno,
              color: Colors.orange,
              size: 30,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              '해당 페이지는 비어있습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: contentTextsize(), color: draw.color_textstatus),
            ),
          ],
        ),
      ));
}

Page0(
  maxHeight,
  maxWidth,
) {
  return StatefulBuilder(
    builder: (context, setState) {
      return SizedBox(
        width: maxWidth,
        height: maxHeight,
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: notilist.listad.length,
            padding: const EdgeInsets.only(left: 20, right: 20),
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    notilist.updatenoti(listid[index]);
                    notilist.listad[index].title.toString().contains('메모')
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 30,
                            child: Checkbox(
                                value: notilist.checkboxnoti[index],
                                onChanged: (value) {
                                  setState(() {
                                    notilist.checkboxnoti[index] = value!;
                                  });
                                }),
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: ContainerDesign(
                              color: readlist[index] == 'no'
                                  ? draw.backgroundcolor
                                  : draw.color_textstatus,
                              child: SizedBox(
                                  height: 100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ScrollConfiguration(
                                        behavior:
                                            ScrollConfiguration.of(context)
                                                .copyWith(dragDevices: {
                                          PointerDeviceKind.touch,
                                          PointerDeviceKind.mouse,
                                        }, scrollbars: false),
                                        child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            physics: const ScrollPhysics(),
                                            child: Text(
                                              notilist.listad[index].title,
                                              softWrap: true,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: readlist[index] == 'no'
                                                      ? draw.color_textstatus
                                                      : draw.backgroundcolor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize()),
                                            )),
                                      ),
                                      Text(
                                        notilist.listad[index].date.toString(),
                                        style: TextStyle(
                                            color: readlist[index] == 'no'
                                                ? draw.color_textstatus
                                                : draw.backgroundcolor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: contentsmallTextsize()),
                                        overflow: TextOverflow.visible,
                                      ),
                                    ],
                                  )),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ));
            }),
      );
    },
  );
}

Page1(
  maxHeight,
  maxWidth,
) {
  return StatefulBuilder(
    builder: (context, setState) {
      return SizedBox(
        width: maxWidth,
        height: maxHeight,
        child: ListView.builder(
            physics: const ScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: notilist.listad.length,
            padding: const EdgeInsets.only(left: 20, right: 20),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  notilist.updatenoti(listid[index]);
                  notilist.listad[index].title.toString().contains('메모')
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30,
                          child: Checkbox(
                              value: notilist.checkboxnoti[index],
                              onChanged: (value) {
                                setState(() {
                                  notilist.checkboxnoti[index] = value!;
                                });
                              }),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: ContainerDesign(
                            color: readlist[index] == 'no'
                                ? draw.backgroundcolor
                                : draw.color_textstatus,
                            child: SizedBox(
                                height: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ScrollConfiguration(
                                      behavior: ScrollConfiguration.of(context)
                                          .copyWith(dragDevices: {
                                        PointerDeviceKind.touch,
                                        PointerDeviceKind.mouse,
                                      }, scrollbars: false),
                                      child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          physics: const ScrollPhysics(),
                                          child: Text(
                                            notilist.listad[index].title,
                                            softWrap: true,
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: readlist[index] == 'no'
                                                    ? draw.color_textstatus
                                                    : draw.backgroundcolor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: contentTextsize()),
                                          )),
                                    ),
                                    Text(
                                      notilist.listad[index].date.toString(),
                                      style: TextStyle(
                                          color: readlist[index] == 'no'
                                              ? draw.color_textstatus
                                              : draw.backgroundcolor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: contentsmallTextsize()),
                                      overflow: TextOverflow.visible,
                                    ),
                                  ],
                                )),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              );
            }),
      );
    },
  );
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
            /*setState(() {
              for (int i = 0; i < listid.length; i++) {
                notilist.updatenoti(listid[i]);
                readlist[i] = 'yes';
              }
            });*/
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
