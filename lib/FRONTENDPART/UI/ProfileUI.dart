// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names

import 'package:clickbyme/BACKENDPART/FIREBASE/SettingVP.dart';
import 'package:clickbyme/FRONTENDPART/Widget/responsiveWidget.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/sheets/BottomSheet/AddContent.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../BACKENDPART/Enums/Variables.dart';
import '../../../Tool/BGColor.dart';
import '../../BACKENDPART/Getx/linkspacesetting.dart';
import '../../../Tool/TextSize.dart';
import '../../BACKENDPART/Enums/Expandable.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../Tool/AndroidIOS.dart';
import '../../BACKENDPART/Getx/PeopleAdd.dart';
import '../../BACKENDPART/Getx/uisetting.dart';

final uiset = Get.put(uisetting());
final linkspaceset = Get.put(linkspacesetting());
final peopleadd = Get.put(PeopleAdd());
final draw = Get.put(navibool());

///UI
///
///ProfilePage의 UI
UI(controller, searchnode, scrollcontroller, maxWidth, maxHeight) {
  return GetBuilder<uisetting>(builder: (_) {
    uiset.setprofilespace();
    return SingleChildScrollView(
        controller: scrollcontroller,
        child: StatefulBuilder(builder: (context, StateSetter setState) {
          return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  uiset.profileindex == 0
                      ? OptionChoice(
                          context, maxWidth, maxHeight, searchnode, controller)
                      : (uiset.profileindex == 1
                          ? TestScreen(maxWidth, maxHeight)
                          : LicenseScreen(maxWidth, maxHeight)),
                ],
              ));
        }));
  });
}

///OptionChoice
///
///ProfilePage의 기본UI
///각종 옵션들을 Opt_body에서 보여줌.
OptionChoice(context, maxWidth, maxHeight, searchnode, controller) {
  return GestureDetector(
    onTap: () {
      FocusManager.instance.primaryFocus?.unfocus();
    },
    child: SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          optview(context, maxWidth, searchnode, controller)
          /*Responsivelayout(lsoptview(maxWidth, searchnode, controller),
              proptview(maxWidth, searchnode, controller))*/
        ],
      ),
    ),
  );
}

optview(context, maxWidth, searchnode, controller) {
  Widget title;
  Widget content;
  return responsivewidget(
      Column(
        children: List.generate(4, (index) {
          return Column(
            children: [
              ContainerDesign(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              backgroundColor: draw.backgroundcolor,
                              foregroundColor: draw.backgroundcolor,
                              child: Icon(
                                uiset.profilescreen[index].icondata,
                                color: draw.color_textstatus,
                              ),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          uiset.profilescreen[index].title.toString().tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: contentTextsize(),
                              color: draw.color_textstatus),
                        ),
                      ],
                    ),
                    Divider(
                      height: 10,
                      thickness: 2,
                      color: Colors.grey.shade400,
                    ),
                    Opt_body(index, searchnode, controller)
                  ],
                ),
                color: draw.backgroundcolor,
              ),
              const SizedBox(
                height: 20,
              )
            ],
          );
        }),
      ),
      maxWidth);
}

///Opt_body
///
///uiset.profilescreen으로 옵션들을 기입받았고 이를 인덱스별로 보여줌.
Opt_body(index, searchnode, controller) {
  Widget title;
  Widget content;

  return StatefulBuilder(
    builder: (context, setState) {
      return SizedBox(
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: uiset.profilescreen[index].subtitles.length,
            itemBuilder: (context, index2) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (index == 0) {
                      } else if (index == 1) {
                        uiset.checkprofilepageindex(1);
                      } else if (index == 2) {
                        controller.clear();
                        title = Widgets_addpeople(
                            context, controller, searchnode)[0];
                        content = Widgets_addpeople(
                            context, controller, searchnode)[1];
                        AddContent(context, title, content, searchnode);
                      } else {
                        if (index2 == 0) {
                          var url = Uri.parse(
                              'https://linkaiteam.github.io/LINKAITEAM/개인정보처리방침');
                          launchUrl(url);
                        } else if (index2 == 1) {
                          uiset.checkprofilepageindex(3);
                        } else {
                          controller.clear();
                          title = Widgets_tocompany(
                              context, controller, searchnode)[0];
                          content = Widgets_tocompany(
                              context, controller, searchnode)[1];
                          AddContent(context, title, content, searchnode);
                        }
                      }
                    },
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                              uiset.profilescreen[index].subtitles[index2]
                                  .toString()
                                  .tr,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize(),
                                  color: TextColor()),
                            ),
                          ),
                          index == 0
                              ? SizedBox(
                                  height: 30,
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                          flex: 1,
                                          child: SizedBox(
                                              height: 30,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(
                                                    () {
                                                      if (index2 == 0) {
                                                        Hive.box('user_setting')
                                                            .put(
                                                                'which_color_background',
                                                                0);
                                                        draw.setnavicolor();
                                                      } else if (index2 == 1) {
                                                        draw.setts(0);
                                                      } else if (index2 == 2) {
                                                        draw.setnavi(0);
                                                      } else {
                                                        draw.setclose();
                                                        draw.setmenushowing(
                                                            true);
                                                      }
                                                    },
                                                  );
                                                },
                                                child: index2 == 0
                                                    ? CircleAvatar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: Hive.box('user_setting')
                                                                        .get(
                                                                            'which_color_background') ==
                                                                    0 ||
                                                                Hive.box('user_setting')
                                                                        .get(
                                                                            'which_color_background') ==
                                                                    null
                                                            ? Container(
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    border: Border.all(
                                                                        width:
                                                                            2,
                                                                        color: Hive.box('user_setting').get('which_color_background') == 0 ||
                                                                                Hive.box('user_setting').get('which_color_background') == null
                                                                            ? Colors.blue.shade400
                                                                            : BGColor_shadowcolor())),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    NeumorphicIcon(
                                                                  Icons.check,
                                                                  size: 25,
                                                                  style: NeumorphicStyle(
                                                                      shape: NeumorphicShape
                                                                          .convex,
                                                                      depth: 2,
                                                                      color: Colors
                                                                          .blue
                                                                          .shade300,
                                                                      lightSource:
                                                                          LightSource
                                                                              .topLeft),
                                                                ),
                                                              )
                                                            : null,
                                                      )
                                                    : (index2 == 1
                                                        ? CircleAvatar(
                                                            backgroundColor:
                                                                BGColor_shadowcolor(),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  border: Border.all(
                                                                      width: 2,
                                                                      color: Hive.box('user_setting').get('which_text_size') == 0 ||
                                                                              Hive.box('user_setting').get('which_text_size') ==
                                                                                  null
                                                                          ? Colors
                                                                              .blue
                                                                              .shade400
                                                                          : BGColor_shadowcolor())),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child:
                                                                  NeumorphicIcon(
                                                                Icons
                                                                    .format_size,
                                                                size: 15,
                                                                style: NeumorphicStyle(
                                                                    shape: NeumorphicShape
                                                                        .convex,
                                                                    depth: 2,
                                                                    color: Colors
                                                                        .blue
                                                                        .shade300,
                                                                    lightSource:
                                                                        LightSource
                                                                            .topLeft),
                                                              ),
                                                            ),
                                                          )
                                                        : (index2 == 2
                                                            ? CircleAvatar(
                                                                backgroundColor:
                                                                    BGColor_shadowcolor(),
                                                                child:
                                                                    Container(
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      border: Border.all(
                                                                          width:
                                                                              2,
                                                                          color: draw.navi == 0
                                                                              ? Colors.blue.shade400
                                                                              : BGColor_shadowcolor())),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      NeumorphicIcon(
                                                                    Icons
                                                                        .align_horizontal_left,
                                                                    size: 25,
                                                                    style: NeumorphicStyle(
                                                                        shape: NeumorphicShape
                                                                            .convex,
                                                                        depth:
                                                                            2,
                                                                        color: Colors
                                                                            .blue
                                                                            .shade300,
                                                                        lightSource:
                                                                            LightSource.topLeft),
                                                                  ),
                                                                ),
                                                              )
                                                            : CircleAvatar(
                                                                backgroundColor:
                                                                    BGColor_shadowcolor(),
                                                                child:
                                                                    Container(
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      border: Border.all(
                                                                          width:
                                                                              2,
                                                                          color: Hive.box('user_setting').get('menushowing') == true || Hive.box('user_setting').get('menushowing') == null
                                                                              ? Colors.blue.shade400
                                                                              : BGColor_shadowcolor())),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      NeumorphicIcon(
                                                                    Ionicons
                                                                        .eye,
                                                                    size: 25,
                                                                    style: NeumorphicStyle(
                                                                        shape: NeumorphicShape
                                                                            .convex,
                                                                        depth:
                                                                            2,
                                                                        color: Colors
                                                                            .blue
                                                                            .shade300,
                                                                        lightSource:
                                                                            LightSource.topLeft),
                                                                  ),
                                                                ),
                                                              ))),
                                              ))),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Flexible(
                                          flex: 1,
                                          child: SizedBox(
                                              height: 30,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(
                                                    () {
                                                      if (index2 == 0) {
                                                        Hive.box('user_setting')
                                                            .put(
                                                                'which_color_background',
                                                                1);
                                                        draw.setnavicolor();
                                                      } else if (index2 == 1) {
                                                        draw.setts(1);
                                                      } else if (index2 == 2) {
                                                        draw.setnavi(1);
                                                      } else {
                                                        draw.setmenushowing(
                                                            false);
                                                      }
                                                    },
                                                  );
                                                },
                                                child: index2 == 0
                                                    ? CircleAvatar(
                                                        backgroundColor:
                                                            Colors.black,
                                                        child: Hive.box('user_setting')
                                                                    .get(
                                                                        'which_color_background') ==
                                                                1
                                                            ? Container(
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    border: Border.all(
                                                                        width:
                                                                            2,
                                                                        color: Hive.box('user_setting').get('which_color_background') ==
                                                                                1
                                                                            ? Colors.blue.shade400
                                                                            : BGColor_shadowcolor())),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    NeumorphicIcon(
                                                                  Icons.check,
                                                                  size: 25,
                                                                  style: NeumorphicStyle(
                                                                      shape: NeumorphicShape
                                                                          .convex,
                                                                      depth: 2,
                                                                      color: Colors
                                                                          .blue
                                                                          .shade300,
                                                                      lightSource:
                                                                          LightSource
                                                                              .topLeft),
                                                                ),
                                                              )
                                                            : null,
                                                      )
                                                    : (index2 == 1
                                                        ? CircleAvatar(
                                                            backgroundColor:
                                                                BGColor_shadowcolor(),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  border: Border.all(
                                                                      width: 2,
                                                                      color: Hive.box('user_setting').get('which_text_size') ==
                                                                              1
                                                                          ? Colors
                                                                              .blue
                                                                              .shade400
                                                                          : BGColor_shadowcolor())),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child:
                                                                  NeumorphicIcon(
                                                                Icons
                                                                    .text_fields,
                                                                size: 25,
                                                                style: NeumorphicStyle(
                                                                    shape: NeumorphicShape
                                                                        .convex,
                                                                    depth: 2,
                                                                    color: Colors
                                                                        .blue
                                                                        .shade300,
                                                                    lightSource:
                                                                        LightSource
                                                                            .topLeft),
                                                              ),
                                                            ),
                                                          )
                                                        : (index2 == 2
                                                            ? CircleAvatar(
                                                                backgroundColor:
                                                                    BGColor_shadowcolor(),
                                                                child:
                                                                    Container(
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      border: Border.all(
                                                                          width:
                                                                              2,
                                                                          color: draw.navi == 1
                                                                              ? Colors.blue.shade400
                                                                              : BGColor_shadowcolor())),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      NeumorphicIcon(
                                                                    Icons
                                                                        .align_horizontal_right,
                                                                    size: 25,
                                                                    style: NeumorphicStyle(
                                                                        shape: NeumorphicShape
                                                                            .convex,
                                                                        depth:
                                                                            2,
                                                                        color: Colors
                                                                            .blue
                                                                            .shade300,
                                                                        lightSource:
                                                                            LightSource.topLeft),
                                                                  ),
                                                                ),
                                                              )
                                                            : CircleAvatar(
                                                                backgroundColor:
                                                                    BGColor_shadowcolor(),
                                                                child:
                                                                    Container(
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      border: Border.all(
                                                                          width:
                                                                              2,
                                                                          color: Hive.box('user_setting').get('menushowing') == false
                                                                              ? Colors.blue.shade400
                                                                              : BGColor_shadowcolor())),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      NeumorphicIcon(
                                                                    Ionicons
                                                                        .eye_off,
                                                                    size: 25,
                                                                    style: NeumorphicStyle(
                                                                        shape: NeumorphicShape
                                                                            .convex,
                                                                        depth:
                                                                            2,
                                                                        color: Colors
                                                                            .blue
                                                                            .shade300,
                                                                        lightSource:
                                                                            LightSource.topLeft),
                                                                  ),
                                                                ),
                                                              ))),
                                              ))),
                                    ],
                                  ),
                                )
                              : Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 30,
                                  color: TextColor(),
                                ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }),
      );
    },
  );
}

///TestScreen
///
///실험실 공간으로 같은 페이지를 UI변경.
TestScreen(maxWidth, maxHeight) {
  return GestureDetector(
    onTap: () {
      FocusManager.instance.primaryFocus?.unfocus();
    },
    child: SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Responsivelayout(
              lstestview(maxWidth, maxHeight), prtestview(maxWidth, maxHeight))
        ],
      ),
    ),
  );
}

lstestview(maxWidth, maxHeight) {
  return responsivewidget(
      SizedBox(
        height: maxHeight,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                '새로운 잇플\'s Box들을 열심히 개발중이에요~~!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: contentTextsize(), color: draw.color_textstatus),
              ),
            ]),
      ),
      maxWidth);
}

prtestview(maxWidth, maxHeight) {
  return responsivewidget(
      SizedBox(
        height: maxHeight,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                '새로운 잇플\'s Box들을 열심히 개발중이에요~~!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: contentTextsize(), color: draw.color_textstatus),
              ),
            ]),
      ),
      maxWidth);
}

///LicenseHome
///
///앱이 사용한 라이선스 리스트를 보여주는 공간으로 같은 페이지 UI변경.
LicenseScreen(maxWidth, maxHeight) {
  return GetBuilder<uisetting>(builder: (_) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Responsivelayout(lslicenseview(maxWidth, maxHeight),
                prlicenseview(maxWidth, maxHeight))
          ],
        ),
      ),
    );
  });
}

lslicenseview(maxWidth, maxHeight) {
  return SizedBox(
      width: maxWidth * 0.6, height: maxHeight, child: buildPanel());
}

prlicenseview(maxWidth, maxHeight) {
  return SizedBox(height: maxHeight, child: buildPanel());
}

buildPanel() {
  return StatefulBuilder(
    builder: (context, setState) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        child: ExpansionPanelList(
            expansionCallback: ((panelIndex, isExpanded) {
              setState(() {
                licensedata[panelIndex].isExpanded = !isExpanded;
              });
            }),
            dividerColor: Colors.grey,
            children: licensedata.map<ExpansionPanel>((Expandable expandable) {
              return ExpansionPanel(
                  canTapOnHeader: true,
                  backgroundColor: Colors.grey.shade300,
                  headerBuilder: ((context, isExpanded) {
                    return ListTile(
                      title: Text(
                        expandable.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTextsize(),
                            color: draw.color_textstatus),
                      ),
                    );
                  }),
                  body: ListTile(
                    subtitle: Text(
                      expandable.sub,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentsmallTextsize(),
                          color: draw.color_textstatus),
                    ),
                  ),
                  isExpanded: expandable.isExpanded);
            }).toList()),
      );
    },
  );
}
