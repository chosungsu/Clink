// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/BACKENDPART/Api/NoticeApi.dart';
import 'package:clickbyme/FRONTENDPART/Widget/responsiveWidget.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import '../../Tool/AndroidIOS.dart';
import '../../BACKENDPART/Getx/notishow.dart';
import '../../BACKENDPART/Getx/uisetting.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../Tool/ContainerDesign.dart';
import '../../Tool/MyTheme.dart';

final listid = [];
final draw = Get.put(navibool());
final uiset = Get.put(uisetting());
final notilist = Get.put(notishow());

SetBoxUI(width) {
  return GetBuilder<notishow>(builder: (_) {
    return StatefulBuilder(
      builder: (context, setState) {
        return SizedBox(
            height: 50,
            child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: SizedBox(
                  width: width - 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () {
                            notilist.setclicker(0);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '공지사항',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'NanumMyeongjo',
                                    fontSize: contentTextsize(),
                                    color: notilist.clicker == 0
                                        ? MyTheme.colorpastelpurple
                                        : draw.color_textstatus),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: 10,
                                child: Divider(
                                  height: 3,
                                  color: notilist.clicker == 0
                                      ? MyTheme.colorpastelpurple
                                      : draw.backgroundcolor,
                                  thickness: 2,
                                  indent: 0,
                                  endIndent: 0,
                                ),
                              )
                            ],
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                          onTap: () {
                            notilist.setclicker(1);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'My',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'NanumMyeongjo',
                                    fontSize: contentTextsize(),
                                    color: notilist.clicker == 1
                                        ? MyTheme.colorpastelpurple
                                        : draw.color_textstatus),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: 10,
                                child: Divider(
                                  height: 3,
                                  color: notilist.clicker == 1
                                      ? MyTheme.colorpastelpurple
                                      : draw.backgroundcolor,
                                  thickness: 2,
                                  indent: 0,
                                  endIndent: 0,
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                )));
      },
    );
  });
}

UI(width) {
  return FutureBuilder(
    future: NoticeApiProvider().getTasks(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return SpinKitThreeBounce(
          size: 30,
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                  color: Colors.blue.shade200, shape: BoxShape.circle),
            );
          },
        );
      } else {
        return GetBuilder<notishow>(
          builder: (_) {
            return notilist.listappnoti.isEmpty || notilist.clicker == 1
                ? NotInPageScreen(width)
                : Responsivelayout(Page0(width), Page1(width));
          },
        );
      }
    },
  );
}

NotInPageScreen(width) {
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
  );
}

Page0([width]) {
  return responsivewidget(StatefulBuilder(
    builder: (context, setState) {
      return Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: notilist.listappnoti.length,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ContainerDesign(
                      child: SizedBox(
                        height: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notilist.listappnoti[index].title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize(),
                                  color: draw.color_textstatus),
                            ),
                            Divider(
                              height: 3,
                              color: draw.color_textstatus,
                              thickness: 1,
                              indent: 0,
                              endIndent: 30,
                            ),
                            Text(
                              notilist.listappnoti[index].content,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentsmallTextsize(),
                                  color: draw.color_textstatus),
                            ),
                          ],
                        ),
                      ),
                      color: draw.backgroundcolor),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );
            },
          ));
    },
  ), width);
}

Page1(width) {
  return responsivewidget(StatefulBuilder(
    builder: (context, setState) {
      return Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: notilist.listappnoti.length,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ContainerDesign(
                      child: SizedBox(
                        height: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notilist.listappnoti[index].title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize(),
                                  color: draw.color_textstatus),
                            ),
                            Divider(
                              height: 3,
                              color: draw.color_textstatus,
                              thickness: 1,
                              indent: 0,
                              endIndent: 30,
                            ),
                            Text(
                              notilist.listappnoti[index].content,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentsmallTextsize(),
                                  color: draw.color_textstatus),
                            ),
                          ],
                        ),
                      ),
                      color: draw.backgroundcolor),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );
            },
          ));
    },
  ), width);
}
