// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names, file_names

import 'dart:io';
import 'package:clickbyme/BACKENDPART/Api/BoxApi.dart';
import 'package:clickbyme/BACKENDPART/Enums/Variables.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:clickbyme/sheets/BSContents/appbarplusbtn.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../BACKENDPART/Getx/linkspacesetting.dart';
import '../../../Tool/TextSize.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../BACKENDPART/Getx/UserInfo.dart';
import '../../BACKENDPART/Getx/uisetting.dart';
import '../../Tool/AndroidIOS.dart';
import '../../Tool/FlushbarStyle.dart';
import '../../sheets/BottomSheet/AddContent.dart';
import '../Route/subuiroute.dart';

final uiset = Get.put(uisetting());
final linkspaceset = Get.put(linkspacesetting());
final peopleadd = Get.put(UserInfo());
final draw = Get.put(navibool());

///UI
///
///AddPage의 UI
UI(controller, searchnode, pagecontroller, scrollcontroller, maxWidth,
    maxHeight) {
  return GetBuilder<linkspacesetting>(builder: (_) {
    return SingleChildScrollView(
        controller: scrollcontroller,
        child: StatefulBuilder(builder: (context, StateSetter setState) {
          return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  uiset.addpagecontroll == 0
                      ? Responsivelayout(
                          PageUI0(context, maxWidth - 40, maxHeight, searchnode,
                              controller, pagecontroller),
                          PageUI1(context, maxWidth - 40, maxHeight, searchnode,
                              controller, pagecontroller))
                      : Responsivelayout(
                          PageUI2(context, maxWidth - 40, maxHeight, searchnode,
                              controller, pagecontroller),
                          PageUI3(context, maxWidth - 40, maxHeight, searchnode,
                              controller, pagecontroller))
                ],
              ));
        }));
  });
}

PageUI0(context, maxWidth, maxHeight, searchnode, controller, pagecontroller) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      StepView(context, maxWidth, maxHeight, 'ls', pagecontroller),
      const SizedBox(
        width: 20,
      ),
      Flexible(
          fit: FlexFit.tight,
          child: View1(context, maxWidth - 120, maxHeight, searchnode,
              controller, pagecontroller, 'ls'))
    ],
  );
}

PageUI1(context, maxWidth, maxHeight, searchnode, controller, pagecontroller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      StepView(context, maxWidth, maxHeight, 'pr', pagecontroller),
      const SizedBox(
        height: 20,
      ),
      View1(context, maxWidth, maxHeight - 70, searchnode, controller,
          pagecontroller, 'pr')
    ],
  );
}

PageUI2(context, maxWidth, maxHeight, searchnode, controller, pagecontroller) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      StepView(context, maxWidth, maxHeight, 'ls', pagecontroller),
      const SizedBox(
        width: 20,
      ),
      Flexible(
          fit: FlexFit.tight,
          child: View2(context, maxWidth - 120, maxHeight, searchnode,
              controller, pagecontroller, 'ls'))
    ],
  );
}

PageUI3(context, maxWidth, maxHeight, searchnode, controller, pagecontroller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      StepView(context, maxWidth, maxHeight, 'pr', pagecontroller),
      const SizedBox(
        height: 20,
      ),
      View2(context, maxWidth, maxHeight - 70, searchnode, controller,
          pagecontroller, 'pr')
    ],
  );
}

///View
///
///ProfilePage의 기본UI
StepView(context, maxWidth, maxHeight, pageoption, pagecontroller) {
  return pageoption == 'ls'
      ? GetBuilder<linkspacesetting>(
          builder: (_) {
            return SizedBox(
              height: maxHeight,
              width: 100,
              child: ListView.builder(
                  physics: const ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: false,
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            pagecontroller[0].animateToPage(
                              index,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Container(
                            height: 50,
                            width: 100,
                            alignment: Alignment.topCenter,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              pageviewoptionname[index].toString().tr,
                              softWrap: true,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: index == linkspaceset.pageviewnum
                                      ? MyTheme.colororigblue
                                      : MyTheme.colorgrey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize()),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    );
                  }),
            );
          },
        )
      : GetBuilder<linkspacesetting>(builder: (_) {
          return SizedBox(
            height: 50,
            width: maxWidth,
            child: ListView.builder(
                physics: const ScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: false,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          pagecontroller[0].animateToPage(
                            index,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          height: 50,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            pageviewoptionname[index].toString().tr,
                            softWrap: true,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: index == linkspaceset.pageviewnum
                                    ? MyTheme.colororigblue
                                    : MyTheme.colorgrey,
                                fontWeight: FontWeight.bold,
                                fontSize: contentTextsize()),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  );
                }),
          );
        });
}

///View
///
///AddPage의 기본UI
View1(context, maxWidth, maxHeight, searchnode, controller, pagecontroller,
    pageoption) {
  return SizedBox(
      width: maxWidth,
      height: maxHeight,
      child: PageView(
        controller: pagecontroller[0],
        scrollDirection: Axis.horizontal,
        onPageChanged: (int pageIndex) {
          linkspaceset.setpageviewnum(pageIndex);
        },
        children: [
          Form1(context, searchnode, controller),
          Upload1(context, controller, pagecontroller, maxHeight, maxWidth)
        ],
      ));
}

///View
///
///AddPage의 기본UI
View2(context, maxWidth, maxHeight, searchnode, controller, pagecontroller,
    pageoption) {
  return SizedBox(
      width: maxWidth,
      height: maxHeight,
      child: PageView(
        controller: pagecontroller[0],
        scrollDirection: Axis.horizontal,
        onPageChanged: (int pageIndex) {
          linkspaceset.setpageviewnum(pageIndex);
        },
        children: [
          Form2(context, searchnode, pagecontroller, controller, maxHeight,
              maxWidth),
          Upload2(context, controller, pagecontroller, maxHeight, maxWidth)
        ],
      ));
}

Form1(context, searchnode, controller) {
  return SingleChildScrollView(
      child: Column(
    children: [
      TitleSpace(searchnode[0], controller[0]),
      ThumbnailSpace(context, searchnode[2]),
      AvailablecheckSpace(),
      MakeUrlSpace(searchnode[1], controller[1], 'page'),
    ],
  ));
}

Form2(context, searchnode, pagecontroller, controller, maxHeight, maxWidth) {
  return SingleChildScrollView(
      child: SizedBox(
    height: maxHeight,
    child: Column(
      children: [
        PreviewSpace(pagecontroller, maxHeight, maxWidth),
        //MakeUrlSpace(searchnode[1], controller[1], 'box'),
      ],
    ),
  ));
}

PreviewSpace(pagecontroller, maxHeight, maxWidth) {
  return SizedBox(
    height: maxHeight,
    child: SingleChildScrollView(
      child: Column(
        children: [
          GetBuilder<uisetting>(builder: (_) {
            return Row(
              children: [
                Flexible(
                    fit: FlexFit.tight,
                    child: SizedBox(
                      height: 50,
                      child: InfoContainerDesign(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'pagetype'.tr,
                                softWrap: true,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: contentsmallTextsize()),
                              ),
                              GetBuilder<linkspacesetting>(builder: (_) {
                                return Text(
                                  linkspaceset.pageboxtype == ''
                                      ? 'nothing'
                                      : linkspaceset.pageboxtype,
                                  softWrap: true,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentsmallTextsize()),
                                );
                              }),
                            ],
                          ),
                          color: MyTheme.colorpastelpurple,
                          borderwhere: 'left',
                          borderok: 'no'),
                    )),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                    onTap: () {
                      uiset.changeshowboxtype(!uiset.showboxlist);
                    },
                    child: SizedBox(
                      height: 50,
                      child: InfoContainerDesign(
                        child: Center(
                            child: Icon(
                          uiset.showboxlist == false
                              ? Entypo.chevron_small_down
                              : Entypo.chevron_small_up,
                          size: 30,
                          color: Colors.white,
                        )),
                        color: MyTheme.colorpastelblue,
                        borderwhere: 'right',
                        borderok: 'no',
                      ),
                    )),
              ],
            );
          }),
          GetBuilder<uisetting>(builder: (_) {
            return uiset.showboxlist == false
                ? const SizedBox()
                : FutureBuilder(
                    future: BoxApiProvider().getTasks(),
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          GetBuilder<linkspacesetting>(builder: (_) {
                            return SizedBox(
                              height: 200,
                              child: InfoContainerDesign(
                                child: SingleChildScrollView(
                                    child: snapshot.hasError
                                        ? Column(
                                            children: [
                                              SpinKitThreeBounce(
                                                size: 30,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return const DecoratedBox(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle),
                                                  );
                                                },
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                'pagetypeerror'.tr,
                                                softWrap: true,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        contentsmallTextsize()),
                                              )
                                            ],
                                          )
                                        : Column(
                                            children: List.generate(
                                                linkspaceset.boxtypelist.length,
                                                (index) {
                                              return linkspaceset
                                                          .boxtypelist[index]
                                                          .isavailable ==
                                                      'open'
                                                  ? ListTile(
                                                      onTap: () {
                                                        linkspaceset
                                                            .setpageboxtype(
                                                                linkspaceset
                                                                    .boxtypelist[
                                                                        index]
                                                                    .title);
                                                        uiset.changeshowboxtype(
                                                            !uiset.showboxlist);
                                                      },
                                                      trailing: const Icon(
                                                        Ionicons.enter_outline,
                                                        color: Colors.white,
                                                      ),
                                                      title: Text(
                                                        linkspaceset
                                                            .boxtypelist[index]
                                                            .title,
                                                        softWrap: true,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                contentTextsize()),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    )
                                                  : const SizedBox();
                                            }),
                                          )),
                                color: MyTheme.colorpastelblue,
                                borderwhere: 'all',
                                borderok: 'no',
                              ),
                            );
                          })
                        ],
                      );
                    },
                  );
          }),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: Get.height > 800 ? 600 : 400,
            child: ContainerDesign(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return PageView(
                    controller: pagecontroller[1],
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (int pageIndex) {
                      linkspaceset.boxpreviewnumset(pageIndex);
                    },
                    children:
                        List.generate(linkspaceset.pageboxtotalnum, (index) {
                      return SizedBox(
                        width: maxWidth - 40,
                        height: Get.height > 800 ? 600 : 400,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(
                              AntDesign.minus,
                              size: 30,
                              color: Colors.black,
                            )
                          ],
                        ),
                      );
                    }),
                  );
                },
              ),
              color: draw.backgroundcolor,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    linkspaceset
                        .setpagetotalviewnum(linkspaceset.pageboxtotalnum - 1);
                  },
                  child: InfoContainerDesign(
                      child: const Center(
                          child: Icon(
                        AntDesign.minus,
                        size: 30,
                        color: Colors.white,
                      )),
                      color: MyTheme.colorpastelred,
                      borderwhere: 'left',
                      borderok: 'no'),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                  fit: FlexFit.tight,
                  child: SizedBox(
                    height: 50,
                    child: InfoContainerDesign(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                linkspaceset.boxpreviewnumset('minus');
                                pagecontroller[1].animateToPage(
                                  linkspaceset.boxpreviewnum,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: const Center(
                                  child: Icon(
                                Entypo.chevron_small_left,
                                size: 30,
                                color: Colors.white,
                              )),
                            ),
                            GetBuilder<linkspacesetting>(builder: (_) {
                              return Text(
                                '${linkspaceset.boxpreviewnum + 1}/${linkspaceset.pageboxtotalnum}',
                                softWrap: true,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: contentsmallTextsize()),
                              );
                            }),
                            GestureDetector(
                              onTap: () {
                                linkspaceset.boxpreviewnumset('plus');
                                pagecontroller[1].animateToPage(
                                  linkspaceset.boxpreviewnum,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: const Center(
                                  child: Icon(
                                Entypo.chevron_small_right,
                                size: 30,
                                color: Colors.white,
                              )),
                            )
                          ],
                        ),
                        color: MyTheme.colorpastelpurple,
                        borderwhere: 'nothing',
                        borderok: 'no'),
                  )),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    linkspaceset
                        .setpagetotalviewnum(linkspaceset.pageboxtotalnum + 1);
                  },
                  child: InfoContainerDesign(
                    child: const Center(
                        child: Icon(
                      Ionicons.add,
                      size: 30,
                      color: Colors.white,
                    )),
                    color: MyTheme.colorpastelblue,
                    borderwhere: 'right',
                    borderok: 'no',
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    ),
  );
}

Upload1(context, textcontroller, pagecontroller, maxHeight, maxWidth) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: SizedBox(
        height: maxHeight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: maxWidth * 0.6,
              child: ContainerDesign(
                  child: SingleChildScrollView(
                    child: Text(
                      textcontroller[1].text.length > 10
                          ? 'http://pinset.co.kr/${textcontroller[1].text.toString().substring(0, 5)}...'
                          : 'http://pinset.co.kr/${textcontroller[1].text}',
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: draw.color_textstatus,
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize()),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  color: draw.backgroundcolor),
            ),
            const SizedBox(
              height: 50,
            ),
            Get.height > 800
                ? Column(
                    children: [
                      SizedBox(
                          height: 50,
                          width: 50.w,
                          child: GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(
                                      text:
                                          'http://pinset.co.kr/${textcontroller[1].text}'))
                                  .whenComplete(() {
                                Snack.snackbars(
                                    context: context,
                                    title: 'clipboard'.tr,
                                    backgroundcolor: Colors.green,
                                    bordercolor: draw.backgroundcolor);
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: MyTheme.colororiggreen),
                                child: Center(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: NeumorphicText(
                                          'addresscopy'.tr,
                                          style: const NeumorphicStyle(
                                            shape: NeumorphicShape.flat,
                                            depth: 3,
                                            color: Colors.white,
                                          ),
                                          textStyle: NeumorphicTextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: contentTextsize(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          height: 50,
                          width: 50.w,
                          child: GestureDetector(
                            onTap: () {
                              clickbtn1(
                                  context, textcontroller, pagecontroller[0]);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: MyTheme.colororigblue),
                              child: Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: NeumorphicText(
                                        'uploadok'.tr,
                                        style: const NeumorphicStyle(
                                          shape: NeumorphicShape.flat,
                                          depth: 3,
                                          color: Colors.white,
                                        ),
                                        textStyle: NeumorphicTextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: contentTextsize(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                    ],
                  )
                : Column(
                    children: [
                      SizedBox(
                          height: 50,
                          width: 50.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                          text:
                                              'http://pinset.co.kr/${textcontroller[1].text}'))
                                      .whenComplete(() {
                                    Snack.snackbars(
                                        context: context,
                                        title: 'clipboard'.tr,
                                        backgroundcolor: Colors.green,
                                        bordercolor: draw.backgroundcolor);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: MyTheme.colororiggreen),
                                  child: const Center(
                                      child: Icon(
                                    Ionicons.copy_outline,
                                    size: 30,
                                    color: Colors.white,
                                  )),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  clickbtn1(context, textcontroller,
                                      pagecontroller[0]);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: MyTheme.colororigblue),
                                  child: const Center(
                                      child: Icon(
                                    AntDesign.upload,
                                    size: 30,
                                    color: Colors.white,
                                  )),
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
          ],
        ),
      ),
    ),
  );
}

Upload2(context, textcontroller, pagecontroller, maxHeight, maxWidth) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: SizedBox(
        height: maxHeight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: maxWidth * 0.6,
              child: ContainerDesign(
                  child: SingleChildScrollView(
                    child: Text(
                      textcontroller[1].text.length > 10
                          ? 'http://pinset.co.kr/${textcontroller[1].text.toString().substring(0, 5)}...'
                          : 'http://pinset.co.kr/${textcontroller[1].text}',
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: draw.color_textstatus,
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize()),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  color: draw.backgroundcolor),
            ),
            const SizedBox(
              height: 50,
            ),
            Get.height > 800
                ? Column(
                    children: [
                      SizedBox(
                          height: 50,
                          width: 50.w,
                          child: GestureDetector(
                            onTap: () {
                              clickbtn1(
                                  context, textcontroller, pagecontroller[0]);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: MyTheme.colororigblue),
                              child: Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: NeumorphicText(
                                        'uploadok'.tr,
                                        style: const NeumorphicStyle(
                                          shape: NeumorphicShape.flat,
                                          depth: 3,
                                          color: Colors.white,
                                        ),
                                        textStyle: NeumorphicTextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: contentTextsize(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                    ],
                  )
                : Column(
                    children: [
                      SizedBox(
                          height: 50,
                          width: 50.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  clickbtn1(context, textcontroller,
                                      pagecontroller[0]);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: MyTheme.colororigblue),
                                  child: const Center(
                                      child: Icon(
                                    AntDesign.upload,
                                    size: 30,
                                    color: Colors.white,
                                  )),
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
          ],
        ),
      ),
    ),
  );
}

TitleSpace(searchnode, controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'pagetitle'.tr,
        softWrap: true,
        maxLines: 1,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: draw.color_textstatus,
            fontWeight: FontWeight.bold,
            fontSize: contentTextsize()),
      ),
      const SizedBox(
        height: 20,
      ),
      ContainerTextFieldDesign(
        searchNodeAddSection: searchnode,
        string: 'pagetitlehint'.tr,
        textEditingControllerAddSheet: controller,
        section: 0,
      ),
      uiset.isfilledtextfield == false && controller.text == ''
          ? Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'pagetitlenothing'.tr,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: contentsmallTextsize(),
                      color: Colors.red),
                  overflow: TextOverflow.fade,
                )
              ],
            )
          : const SizedBox(
              height: 0,
            ),
      const SizedBox(
        height: 20,
      ),
    ],
  );
}

AvailablecheckSpace() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        uiset.addpagecontroll == 0 ? 'pagecanshow'.tr : 'pageshare'.tr,
        softWrap: true,
        maxLines: 1,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: draw.color_textstatus,
            fontWeight: FontWeight.bold,
            fontSize: contentTextsize()),
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: GestureDetector(
              onTap: () {
                linkspaceset.setshareoption('yes');
              },
              child: ContainerDesign(
                  child: Text(
                    'Y',
                    softWrap: true,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: draw.color_textstatus,
                        fontWeight: FontWeight.bold,
                        fontSize: contentTextsize()),
                  ),
                  color: linkspaceset.shareoption == 'yes'
                      ? Colors.blue.shade200
                      : draw.backgroundcolor),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            height: 50,
            width: 50,
            child: GestureDetector(
              onTap: () {
                linkspaceset.setshareoption('no');
              },
              child: ContainerDesign(
                  child: Text(
                    'N',
                    softWrap: true,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: draw.color_textstatus,
                        fontWeight: FontWeight.bold,
                        fontSize: contentTextsize()),
                  ),
                  color: linkspaceset.shareoption == 'no'
                      ? Colors.blue.shade200
                      : draw.backgroundcolor),
            ),
          )
        ],
      ),
      const SizedBox(
        height: 20,
      ),
    ],
  );
}

MakeUrlSpace(searchnode, controller, s) {
  return s == 'page'
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'pageurl'.tr,
              softWrap: true,
              maxLines: 1,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: draw.color_textstatus,
                  fontWeight: FontWeight.bold,
                  fontSize: contentTextsize()),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 50,
              child: ContainerTextFieldDesign(
                searchNodeAddSection: searchnode,
                string: 'pageurlhint'.tr,
                textEditingControllerAddSheet: controller,
                section: 0,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              child: InfoContainerDesign(
                  child: SingleChildScrollView(
                    child: Text(
                      'pageurlinfo'.tr,
                      softWrap: true,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: contentsmallTextsize()),
                    ),
                  ),
                  color: MyTheme.colorpastelblue,
                  borderwhere: 'all',
                  borderok: 'no'),
            ),
            uiset.isfilledtextfield == false && controller.text == ''
                ? Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'pageurlnothing'.tr,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: contentsmallTextsize(),
                            color: Colors.red),
                        overflow: TextOverflow.fade,
                      )
                    ],
                  )
                : const SizedBox(
                    height: 0,
                  ),
            const SizedBox(
              height: 50,
            ),
          ],
        )
      : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'pageurl'.tr,
              softWrap: true,
              maxLines: 1,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: draw.color_textstatus,
                  fontWeight: FontWeight.bold,
                  fontSize: contentTextsize()),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 50,
              child: InfoContainerDesign(
                child: SingleChildScrollView(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'pageurlclick'.tr,
                      softWrap: true,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: draw.color_textstatus,
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize()),
                    ),
                    Center(
                        child: Icon(
                      Entypo.mouse_pointer,
                      size: 30,
                      color: draw.color_textstatus,
                    )),
                  ],
                )),
                color: draw.backgroundcolor,
                borderwhere: 'all',
                borderok: 'ok',
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        );
}

ThumbnailSpace(context, searchnode) {
  Widget title;
  Widget content;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'pagethumbnail'.tr,
        softWrap: true,
        maxLines: 1,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: draw.color_textstatus,
            fontWeight: FontWeight.bold,
            fontSize: contentTextsize()),
      ),
      const SizedBox(
        height: 20,
      ),
      GetBuilder<linkspacesetting>(builder: (_) {
        return GestureDetector(
          onTap: () {
            title = Widgets_pagethumnail(context)[0];
            content = Widgets_pagethumnail(context)[1];
            AddContent(context, title, content, searchnode);
          },
          child: SizedBox(
            height: 100,
            width: 100,
            child: linkspaceset.previewpageimgurl == ''
                ? ContainerDesign(
                    child: Icon(
                      Ionicons.add,
                      color: draw.color_textstatus,
                    ),
                    color: draw.backgroundcolor)
                : ContainerDesign(
                    child: Image.file(
                      File(linkspaceset.previewpageimgurl.contains('media') ==
                              true
                          ? linkspaceset.previewpageimgurl
                              .toString()
                              .substring(6)
                          : linkspaceset.previewpageimgurl),
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                    color: draw.backgroundcolor),
          ),
        );
      }),
      const SizedBox(
        height: 10,
      ),
      SizedBox(
        height: 50,
        child: InfoContainerDesign(
            child: SingleChildScrollView(
              child: Text(
                'pagethumbnailinfo'.tr,
                softWrap: true,
                maxLines: 2,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: contentsmallTextsize()),
              ),
            ),
            color: MyTheme.colorpastelred,
            borderwhere: 'all',
            borderok: 'no'),
      ),
      const SizedBox(
        height: 20,
      ),
    ],
  );
}
