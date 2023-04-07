// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names, file_names

import 'dart:io';
import 'package:clickbyme/BACKENDPART/Enums/Variables.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:clickbyme/Tool/datecheck.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../BACKENDPART/Api/PageApi.dart';
import '../../BACKENDPART/Getx/linkspacesetting.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../BACKENDPART/Getx/uisetting.dart';
import '../../Tool/AndroidIOS.dart';
import '../../Tool/TextSize.dart';

final uiset = Get.put(uisetting());
final draw = Get.put(navibool());
final linkspaceset = Get.put(linkspacesetting());

///UI
///
///MYPage의 UI
UI(context, id, controller, searchnode, maxWidth, maxHeight) {
  return GetBuilder<uisetting>(builder: (_) {
    return GetBuilder<linkspacesetting>(builder: (_) {
      return Container(
        height: maxHeight,
        width: maxWidth,
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Responsivelayout(
            PageUI0(
                context, id, controller, searchnode, maxHeight, maxWidth - 40),
            PageUI1(
                context, id, controller, searchnode, maxHeight, maxWidth - 40)),
      );
    });
  });
}

PageUI0(context, id, controller, searchnode, maxHeight, maxWidth) {
  //landscape
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      OptionBox(maxWidth, maxHeight, 'ls'),
      const SizedBox(
        width: 20,
      ),
      View(maxHeight, maxWidth - 120, 'ls')
    ],
  );
}

PageUI1(context, id, controller, searchnode, maxHeight, maxWidth) {
  //portrait
  return Column(
    children: [
      OptionBox(maxWidth, maxHeight, 'pr'),
      const SizedBox(
        height: 20,
      ),
      View(maxHeight - 80, maxWidth, 'pr')
    ],
  );
}

SearchBox(controller, searchnode) {
  return SizedBox(
      height: 50,
      width: 50.w,
      child: ContainerDesign(
          color: draw.backgroundcolor,
          child: StatefulBuilder(
            builder: ((context, setState) {
              return TextField(
                onChanged: ((value) {
                  uiset.settextrecognizer(value);
                }),
                autofocus: false,
                controller: controller,
                maxLines: 1,
                focusNode: searchnode,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                    color: draw.color_textstatus,
                    fontWeight: FontWeight.bold,
                    fontSize: contentsmallTextsize()),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: draw.backgroundcolor,
                  border: InputBorder.none,
                  hintMaxLines: 2,
                  hintText: 'search'.tr,
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentsmallTextsize(),
                      color: MyTheme.colorgrey),
                  isCollapsed: true,
                  prefixIcon: Icon(
                    Icons.search,
                    color: draw.color_textstatus,
                  ),
                ),
              );
            }),
          )));
}

OptionBox(maxWidth, maxHeight, position) {
  List optionname = [
    'MYPageOption1'.tr,
    'MYPageOption2'.tr,
    'MYPageOption3'.tr,
  ];

  return position == 'pr'
      ? SizedBox(
          height: 30,
          width: maxWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              uiset.pageshowoption == 0
                  ? GestureDetector(
                      onTap: () {
                        //linkspaceset.setmainoption(index);
                        //PageApiProvider().getTasks();
                        uiset.changehomeviewoption();
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 30,
                            width: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: MyTheme.colorpastelpurple,
                                    width: 1)),
                            child: Text(
                              uiset.pageshowtitle,
                              softWrap: true,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: draw.color_textstatus,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize()),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Entypo.chevron_small_right,
                            color: draw.color_textstatus,
                            size: 30,
                          ),
                        ],
                      ))
                  : SizedBox(
                      width: maxWidth - 40,
                      child: ListView.builder(
                          physics: const ScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: false,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    //linkspaceset.setmainoption(index);
                                    //PageApiProvider().getTasks();
                                    uiset.changehomeviewoption();
                                    uiset.homeviewname(optionname[index]);
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 100,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: uiset.pageshowtitle ==
                                                    optionname[index]
                                                ? MyTheme.colorpastelpurple
                                                : draw.color_textstatus,
                                            width: 1)),
                                    child: Text(
                                      optionname[index],
                                      softWrap: true,
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: draw.color_textstatus,
                                          fontWeight: FontWeight.bold,
                                          fontSize: contentTextsize()),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                index == 2
                                    ? GestureDetector(
                                        onTap: () {
                                          uiset.changehomeviewoption();
                                        },
                                        child: Icon(
                                          Entypo.chevron_small_left,
                                          color: draw.color_textstatus,
                                          size: 30,
                                        ),
                                      )
                                    : const SizedBox()
                              ],
                            );
                          }),
                    ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  uiset.changesortoption();
                },
                child: Icon(
                  uiset.pagesortoption == 0
                      ? MaterialCommunityIcons.sort_clock_descending_outline
                      : MaterialCommunityIcons.sort_clock_ascending_outline,
                  color: draw.color_textstatus,
                  size: 30,
                ),
              ),
            ],
          ),
        )
      : SizedBox(
          height: maxHeight,
          width: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () {
                    uiset.changesortoption();
                  },
                  child: Container(
                    height: 30,
                    width: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: MyTheme.colorpastelpurple, width: 1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          uiset.pagesortoption == 0
                              ? MaterialCommunityIcons
                                  .sort_clock_descending_outline
                              : MaterialCommunityIcons
                                  .sort_clock_ascending_outline,
                          color: draw.color_textstatus,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'MYPageOption4'.tr,
                          softWrap: true,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: draw.color_textstatus,
                              fontWeight: FontWeight.bold,
                              fontSize: contentTextsize()),
                        )
                      ],
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              uiset.pageshowoption == 0
                  ? GestureDetector(
                      onTap: () {
                        //linkspaceset.setmainoption(index);
                        //PageApiProvider().getTasks();
                        uiset.changehomeviewoption();
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 30,
                            width: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: MyTheme.colorpastelpurple,
                                    width: 1)),
                            child: Text(
                              uiset.pageshowtitle,
                              softWrap: true,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: draw.color_textstatus,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize()),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Icon(
                            Entypo.chevron_small_down,
                            color: draw.color_textstatus,
                            size: 30,
                          ),
                        ],
                      ))
                  : SizedBox(
                      height: maxHeight - 60,
                      child: ListView.builder(
                          physics: const ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: false,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    //linkspaceset.setmainoption(index);
                                    //PageApiProvider().getTasks();
                                    uiset.changehomeviewoption();
                                    uiset.homeviewname(optionname[index]);
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 100,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: uiset.pageshowtitle ==
                                                    optionname[index]
                                                ? MyTheme.colorpastelpurple
                                                : draw.color_textstatus,
                                            width: 1)),
                                    child: Text(
                                      optionname[index],
                                      softWrap: true,
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: draw.color_textstatus,
                                          fontWeight: FontWeight.bold,
                                          fontSize: contentTextsize()),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                index == 2
                                    ? GestureDetector(
                                        onTap: () {
                                          uiset.changehomeviewoption();
                                        },
                                        child: Icon(
                                          Entypo.chevron_small_up,
                                          color: draw.color_textstatus,
                                          size: 30,
                                        ),
                                      )
                                    : const SizedBox()
                              ],
                            );
                          }),
                    )
            ],
          ),
        );
}

View(maxHeight, maxWidth, pageoption) {
  return SizedBox(
      height: maxHeight,
      width: pageoption == 'ls' ? maxWidth * 0.6 : maxWidth,
      child: linkspaceset.alllist.isEmpty
          ? SizedBox(
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
                    '텅 비어있습니다!!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: contentTextsize(),
                        color: draw.color_textstatus),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: StaggeredGrid.extent(
                maxCrossAxisExtent: maxWidth >= 700 || pageoption == 'pr'
                    ? maxWidth
                    : maxWidth * 0.5,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                axisDirection: AxisDirection.down,
                children: List.generate(linkspaceset.alllist.length, (index) {
                  return GestureDetector(
                      onTap: () {
                        //uiset.setmainoption(index);
                      },
                      child: SizedBox(
                        height: maxHeight >= 700 ? 250 : 200,
                        child: ContainerDesign(
                          child: maxWidth < 700 && pageoption == 'ls'
                              ? Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                        flex: 3,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Image.file(
                                            File(linkspaceset
                                                        .alllist[index].image
                                                        .contains('media') ==
                                                    true
                                                ? linkspaceset
                                                    .alllist[index].image
                                                    .toString()
                                                    .substring(6)
                                                : linkspaceset
                                                    .alllist[index].image),
                                            fit: BoxFit.cover,
                                            width: maxWidth * 0.5,
                                          ),
                                        )),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: SingleChildScrollView(
                                        physics: const ScrollPhysics(),
                                        child: Text(
                                          linkspaceset.alllist[index].title,
                                          softWrap: true,
                                          maxLines: 2,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: draw.color_textstatus,
                                              fontWeight: FontWeight.bold,
                                              fontSize: contentTitleTextsize(),
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 5,
                                              bottom: 5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: peopleadd.usrcode ==
                                                    linkspaceset
                                                        .alllist[index].owner
                                                ? MyTheme.colororiggreen
                                                : MyTheme.colororigorange,
                                          ),
                                          child: SingleChildScrollView(
                                            child: Text(
                                              peopleadd.usrcode ==
                                                      linkspaceset
                                                          .alllist[index].owner
                                                  ? 'my'
                                                  : (linkspaceset.alllist[index]
                                                              .owner
                                                              .toString()
                                                              .length >
                                                          5
                                                      ? linkspaceset
                                                              .alllist[index]
                                                              .owner
                                                              .toString()
                                                              .substring(0, 5) +
                                                          '...'
                                                      : linkspaceset
                                                          .alllist[index]
                                                          .owner),
                                              softWrap: true,
                                              maxLines: 2,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: draw.backgroundcolor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize()),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          datecheck(DateTime.parse(linkspaceset
                                              .alllist[index].date)),
                                          softWrap: true,
                                          maxLines: 2,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: draw.color_textstatus,
                                              fontWeight: FontWeight.bold,
                                              fontSize: contentTextsize()),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: maxWidth * 0.3,
                                      child: Image.file(
                                        File(linkspaceset.alllist[index].image
                                                    .contains('media') ==
                                                true
                                            ? linkspaceset.alllist[index].image
                                                .toString()
                                                .substring(6)
                                            : linkspaceset
                                                .alllist[index].image),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SingleChildScrollView(
                                            physics: const ScrollPhysics(),
                                            child: Text(
                                              linkspaceset.alllist[index].title,
                                              softWrap: true,
                                              maxLines: 2,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: draw.color_textstatus,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      contentTitleTextsize(),
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 5,
                                                    bottom: 5),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: peopleadd.usrcode ==
                                                          linkspaceset
                                                              .alllist[index]
                                                              .owner
                                                      ? MyTheme.colororiggreen
                                                      : MyTheme.colororigorange,
                                                ),
                                                child: Text(
                                                  peopleadd.usrcode ==
                                                          linkspaceset
                                                              .alllist[index]
                                                              .owner
                                                      ? 'my'
                                                      : (linkspaceset
                                                                  .alllist[
                                                                      index]
                                                                  .owner
                                                                  .toString()
                                                                  .length >
                                                              5
                                                          ? linkspaceset
                                                                  .alllist[
                                                                      index]
                                                                  .owner
                                                                  .toString()
                                                                  .substring(
                                                                      0, 5) +
                                                              '...'
                                                          : linkspaceset
                                                              .alllist[index]
                                                              .owner),
                                                  softWrap: true,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      color:
                                                          draw.backgroundcolor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          contentTextsize()),
                                                ),
                                              ),
                                              Text(
                                                datecheck(DateTime.parse(
                                                    linkspaceset
                                                        .alllist[index].date)),
                                                softWrap: true,
                                                maxLines: 2,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color:
                                                        draw.color_textstatus,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        contentTextsize()),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                          color: draw.backgroundcolor,
                        ),
                      ));
                }),
              ),
            ));
}
