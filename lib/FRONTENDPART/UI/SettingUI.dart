// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names

import 'package:clickbyme/BACKENDPART/ViewPoints/SettingVP.dart';
import 'package:clickbyme/FRONTENDPART/Route/subuiroute.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:boxplatform/sheet/BottomSheet/AddContent.dart';
import 'package:boxplatform/sheet/BottomSheet/AddContentWithBtn.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Tool/BGColor.dart';
import '../../BACKENDPART/Getx/linkspacesetting.dart';
import '../../../Tool/TextSize.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../BACKENDPART/Getx/UserInfo.dart';
import '../../BACKENDPART/Getx/uisetting.dart';

final uiset = Get.put(uisetting());
final linkspaceset = Get.put(linkspacesetting());
final peopleadd = Get.put(UserInfo());
final navi = Get.put(navibool());
final box = GetStorage();

///UI
///
///SettingPage의 UI
UI(controller, searchnode, scrollcontroller, maxWidth) {
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
                  OptionChoice(context, maxWidth, searchnode, controller),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ));
        }));
  });
}

///OptionChoice
///
///ProfilePage의 기본UI
///각종 옵션들을 Opt_body에서 보여줌.
OptionChoice(context, maxWidth, searchnode, controller) {
  return GestureDetector(
    onTap: () {
      FocusManager.instance.primaryFocus?.unfocus();
    },
    child: SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [optview(context, maxWidth, searchnode, controller)],
      ),
    ),
  );
}

optview(context, maxWidth, searchnode, controller) {
  return Column(
    children: List.generate(3, (index) {
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
                          backgroundColor: navi.backgroundcolor,
                          foregroundColor: navi.backgroundcolor,
                          child: Icon(
                            uiset.profilescreen[index].icondata,
                            color: navi.color_textstatus,
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
                          color: navi.color_textstatus),
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
            color: navi.backgroundcolor,
          ),
          const SizedBox(
            height: 20,
          )
        ],
      );
    }),
  );
}

///Opt_body
///
///uiset.profilescreen으로 옵션들을 기입받았고 이를 인덱스별로 보여줌.
Opt_body(index, searchnode, controller) {
  Widget title;
  Widget content;
  Widget btn;

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
                        if (index2 == 0) {
                          uiset.checkprofilepageindex(0);
                          GoToSettingSubPage(uiset
                              .profilescreen[index].subtitles[index2]
                              .toString()
                              .tr);
                        } else {
                          uiset.checkprofilepageindex(1);
                          GoToSettingSubPage(uiset
                              .profilescreen[index].subtitles[index2]
                              .toString()
                              .tr);
                        }
                      } else {
                        if (index2 == 0) {
                          var url = Uri.parse(
                              'https://linkaiteam.github.io/LINKAITEAM/개인정보처리방침');
                          launchUrl(url);
                        } else if (index2 == 1) {
                          uiset.checkprofilepageindex(2);
                          GoToSettingSubPage(uiset
                              .profilescreen[index].subtitles[index2]
                              .toString()
                              .tr);
                        } else if (index2 == 2) {
                          controller.clear();
                          title = Widgets_tocompany(
                              context, controller, searchnode)[0];
                          content = Widgets_tocompany(
                              context, controller, searchnode)[1];
                          AddContent(context, title, content, searchnode);
                        } else {
                          title = Widgets_settingpagedeleteuser(
                              context, controller, searchnode)[0];
                          content = Widgets_settingpagedeleteuser(
                              context, controller, searchnode)[1];
                          btn = Widgets_settingpagedeleteuser(
                              context, controller, searchnode)[2];
                          AddContentWithBtn(
                              context, title, content, btn, searchnode);
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
                              maxLines: 3,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize(),
                                  color: navi.color_textstatus),
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          index == 0
                              ? SizedBox(
                                  height: 30,
                                  width: 150,
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
                                                        } else if (index2 ==
                                                            1) {
                                                          navi.changeappbox();
                                                        } else if (index2 ==
                                                            2) {
                                                          navi.setts(0);
                                                        } else if (index2 ==
                                                            3) {
                                                          navi.setnavi(0);
                                                        } else {
                                                          //draw.setclose();
                                                          navi.setmenushowing(
                                                              true);
                                                        }
                                                      },
                                                    );
                                                  },
                                                  child: index2 == 0
                                                      ? GetBuilder<UserInfo>(
                                                          builder: (_) {
                                                          return Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            0.0),
                                                                border: Border.all(
                                                                    color: navi
                                                                        .color_textstatus,
                                                                    style: BorderStyle
                                                                        .solid,
                                                                    width: 1),
                                                              ),
                                                              child:
                                                                  DropdownButtonHideUnderline(
                                                                      child:
                                                                          DropdownButton(
                                                                value: peopleadd
                                                                    .locale,
                                                                onChanged: (Locale?
                                                                    newLocale) {
                                                                  if (newLocale !=
                                                                      null) {
                                                                    peopleadd.changeLocale(
                                                                        context,
                                                                        newLocale);
                                                                    Get.updateLocale(
                                                                        newLocale);
                                                                  }
                                                                },
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        contentsmallTextsize(),
                                                                    color: navi
                                                                        .color_textstatus),
                                                                dropdownColor: navi
                                                                    .backgroundcolor,
                                                                items: [
                                                                  DropdownMenuItem(
                                                                    value:
                                                                        const Locale(
                                                                            'en',
                                                                            ''),
                                                                    child: Text(
                                                                      'localeeng'
                                                                          .tr,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              contentsmallTextsize(),
                                                                          color:
                                                                              navi.color_textstatus),
                                                                    ),
                                                                  ),
                                                                  DropdownMenuItem(
                                                                    value:
                                                                        const Locale(
                                                                            'ko',
                                                                            ''),
                                                                    child: Text(
                                                                      'localekor'
                                                                          .tr,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              contentsmallTextsize(),
                                                                          color:
                                                                              navi.color_textstatus),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )));
                                                        })
                                                      : (index2 == 1
                                                          ? CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              child: box.read('backgroundcolor') ==
                                                                          MyTheme
                                                                              .colorWhite
                                                                              .value ||
                                                                      box.read(
                                                                              'backgroundcolor') ==
                                                                          null
                                                                  ? Container(
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          border: Border.all(
                                                                              width: 2,
                                                                              color: box.read('backgroundcolor') == MyTheme.colorWhite.value || box.read('backgroundcolor') == null ? Colors.blue.shade400 : BGColor_shadowcolor())),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          NeumorphicIcon(
                                                                        Icons
                                                                            .check,
                                                                        size:
                                                                            25,
                                                                        style: NeumorphicStyle(
                                                                            shape: NeumorphicShape
                                                                                .convex,
                                                                            depth:
                                                                                2,
                                                                            color:
                                                                                Colors.blue.shade300,
                                                                            lightSource: LightSource.topLeft),
                                                                      ),
                                                                    )
                                                                  : null,
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
                                                                            color: navi.textsize == 0
                                                                                ? Colors.blue.shade400
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
                                                              : (index2 == 3
                                                                  ? CircleAvatar(
                                                                      backgroundColor:
                                                                          BGColor_shadowcolor(),
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            border: Border.all(width: 2, color: navi.navi == 0 ? Colors.blue.shade400 : BGColor_shadowcolor())),
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            NeumorphicIcon(
                                                                          Icons
                                                                              .align_horizontal_left,
                                                                          size:
                                                                              25,
                                                                          style: NeumorphicStyle(
                                                                              shape: NeumorphicShape.convex,
                                                                              depth: 2,
                                                                              color: Colors.blue.shade300,
                                                                              lightSource: LightSource.topLeft),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : CircleAvatar(
                                                                      backgroundColor:
                                                                          BGColor_shadowcolor(),
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            border: Border.all(width: 2, color: Hive.box('user_setting').get('menushowing') == true || Hive.box('user_setting').get('menushowing') == null ? Colors.blue.shade400 : BGColor_shadowcolor())),
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            NeumorphicIcon(
                                                                          Ionicons
                                                                              .eye,
                                                                          size:
                                                                              25,
                                                                          style: NeumorphicStyle(
                                                                              shape: NeumorphicShape.convex,
                                                                              depth: 2,
                                                                              color: Colors.blue.shade300,
                                                                              lightSource: LightSource.topLeft),
                                                                        ),
                                                                      ),
                                                                    ))))))),
                                      const SizedBox(
                                        width: 5,
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
                                                      } else if (index2 == 1) {
                                                        navi.changeappbox();
                                                      } else if (index2 == 2) {
                                                        navi.setts(1);
                                                      } else if (index2 == 3) {
                                                        navi.setnavi(1);
                                                      } else {
                                                        navi.setmenushowing(
                                                            false);
                                                      }
                                                    },
                                                  );
                                                },
                                                child: index2 == 0
                                                    ? const SizedBox()
                                                    : (index2 == 1
                                                        ? CircleAvatar(
                                                            backgroundColor:
                                                                Colors.black,
                                                            child: box.read(
                                                                        'backgroundcolor') ==
                                                                    MyTheme
                                                                        .colorblack
                                                                        .value
                                                                ? Container(
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        border: Border.all(
                                                                            width:
                                                                                2,
                                                                            color: box.read('backgroundcolor') == MyTheme.colorblack.value
                                                                                ? Colors.blue.shade400
                                                                                : BGColor_shadowcolor())),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child:
                                                                        NeumorphicIcon(
                                                                      Icons
                                                                          .check,
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
                                                                  )
                                                                : null,
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
                                                                          color: navi.textsize == 1
                                                                              ? Colors.blue.shade400
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
                                                            : (index2 == 3
                                                                ? CircleAvatar(
                                                                    backgroundColor:
                                                                        BGColor_shadowcolor(),
                                                                    child:
                                                                        Container(
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          border: Border.all(
                                                                              width: 2,
                                                                              color: navi.navi == 1 ? Colors.blue.shade400 : BGColor_shadowcolor())),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          NeumorphicIcon(
                                                                        Icons
                                                                            .align_horizontal_right,
                                                                        size:
                                                                            25,
                                                                        style: NeumorphicStyle(
                                                                            shape: NeumorphicShape
                                                                                .convex,
                                                                            depth:
                                                                                2,
                                                                            color:
                                                                                Colors.blue.shade300,
                                                                            lightSource: LightSource.topLeft),
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
                                                                              width: 2,
                                                                              color: Hive.box('user_setting').get('menushowing') == false ? Colors.blue.shade400 : BGColor_shadowcolor())),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          NeumorphicIcon(
                                                                        Ionicons
                                                                            .eye_off,
                                                                        size:
                                                                            25,
                                                                        style: NeumorphicStyle(
                                                                            shape: NeumorphicShape
                                                                                .convex,
                                                                            depth:
                                                                                2,
                                                                            color:
                                                                                Colors.blue.shade300,
                                                                            lightSource: LightSource.topLeft),
                                                                      ),
                                                                    ),
                                                                  )))),
                                              ))),
                                    ],
                                  ),
                                )
                              : Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 30,
                                  color: navi.color_textstatus,
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
