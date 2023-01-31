// ignore_for_file: non_constant_identifier_names

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

UI(
  maxWidth,
  maxHeight,
) {
  return GetBuilder<uisetting>(
    builder: (_) {
      return StreamBuilder<QuerySnapshot>(
        stream: NotiAlarmStreamFamily(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            NotiAlarmRes1(snapshot, listid, readlist);
            return linkspaceset.indexcnt.isEmpty
                ? NotInPageScreen(
                    maxWidth,
                    maxHeight,
                  )
                : SizedBox(
                    height: maxHeight,
                    width: maxWidth,
                    child: Responsivelayout(
                        Page0(
                          maxHeight,
                          maxWidth,
                        ),
                        Page1(
                          maxHeight,
                          maxWidth,
                        )),
                  );
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
        width: maxWidth * 0.5,
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
        width: maxWidth < 1000 ? maxWidth * 0.8 : maxWidth * 0.5,
        height: maxHeight > 1500 ? maxHeight * 0.5 : maxHeight,
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
  return SizedBox(
    width: maxWidth * 0.5,
    height: maxHeight,
    child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: notilist.listad.length,
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
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    ContainerDesign(
                      color: readlist[index] == 'no'
                          ? draw.backgroundcolor
                          : BGColor_shadowcolor(),
                      child: Column(
                        children: [
                          SizedBox(
                              height: 100,
                              width: maxWidth * 0.5 - 20,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                      fit: FlexFit.tight,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            notilist.listad[index].title,
                                            softWrap: true,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: readlist[index] == 'no'
                                                    ? draw.color_textstatus
                                                    : draw.backgroundcolor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: contentTextsize()),
                                            overflow: TextOverflow.fade,
                                          )
                                        ],
                                      )),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        notilist.listad[index].date.toString(),
                                        style: TextStyle(
                                            color: readlist[index] == 'no'
                                                ? draw.color_textstatus
                                                : draw.backgroundcolor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: contentTextsize()),
                                        overflow: TextOverflow.fade,
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
                ),
              ));
        }),
  );
}

Page1(
  maxHeight,
  maxWidth,
) {
  return SizedBox(
    width: maxWidth < 1000 ? maxWidth * 0.8 : maxWidth * 0.5,
    height: maxHeight < 1500 ? maxHeight * 0.5 : maxHeight,
    child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: notilist.listad.length,
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
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    ContainerDesign(
                      color: readlist[index] == 'no'
                          ? draw.backgroundcolor
                          : BGColor_shadowcolor(),
                      child: Column(
                        children: [
                          SizedBox(
                              height: 100,
                              width: maxWidth < 1000
                                  ? maxWidth * 0.8 - 20
                                  : maxWidth * 0.5 - 20,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                      fit: FlexFit.tight,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            notilist.listad[index].title,
                                            softWrap: true,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: readlist[index] == 'no'
                                                    ? draw.color_textstatus
                                                    : draw.backgroundcolor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: contentTextsize()),
                                            overflow: TextOverflow.fade,
                                          )
                                        ],
                                      )),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        notilist.listad[index].date.toString(),
                                        style: TextStyle(
                                            color: readlist[index] == 'no'
                                                ? draw.color_textstatus
                                                : draw.backgroundcolor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: contentTextsize()),
                                        overflow: TextOverflow.fade,
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
                ),
              ));
        }),
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
