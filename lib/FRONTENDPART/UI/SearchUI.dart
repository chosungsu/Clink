// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:clickbyme/BACKENDPART/ViewPoints/PersonalVP.dart';
import 'package:clickbyme/BACKENDPART/ViewPoints/SearchVP.dart';
import 'package:clickbyme/FRONTENDPART/UI/MYPageUI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../BACKENDPART/Enums/Variables.dart';
import '../../../Tool/ContainerDesign.dart';
import '../../BACKENDPART/Getx/uisetting.dart';
import '../../../Tool/TextSize.dart';

final uiset = Get.put(uisetting());

SearchUI(context, scrollController, TextEditingController controller,
    double width, TextEditingController controller2, searchNode, controller3) {
  return uiset.searchpagemove == ''
      ? SingleChildScrollView(
          controller: scrollController,
          child: GetBuilder<uisetting>(
              builder: (_) => Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Se_Container0(width, controller, searchNode),
                      SizedBox(
                        height: 20,
                      ),
                      Se_Container01(width, controller, searchNode),
                      SizedBox(
                        height: 20,
                      ),
                      Se_Container1(width),
                      SizedBox(
                        height: 20,
                      ),
                      Se_Container11(width, controller, searchNode),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  )))
      : Se_Container2(context, uiset.editpagelist[0].id.toString(), controller3,
          searchNode);
}

Se_Container0(double height, controller, searchNode) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContainerDesign(
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
                    focusNode: searchNode,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(
                        color: draw.color_textstatus,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: draw.backgroundcolor,
                      border: InputBorder.none,
                      hintMaxLines: 2,
                      hintText: 'search'.tr,
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: draw.color_textstatus),
                      isCollapsed: true,
                      prefixIcon: Icon(
                        Icons.search,
                        color: draw.color_textstatus,
                      ),
                    ),
                  );
                }),
              ))
        ],
      ),
    ),
  );
}

Se_Container01(double height, controller, searchNode) {
  return GetBuilder<uisetting>(
      builder: (_) => Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: StreamBuilder<QuerySnapshot>(
              stream: SpacepageStreamParent(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  SearchpageChild1(snapshot);

                  return uiset.searchpagelist.isEmpty
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ContainerDesign(
                                child: SizedBox(
                                  height: 40.h,
                                  child: Center(
                                    child: NeumorphicText(
                                      'result_search'.tr,
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
                                  ),
                                ),
                                color: draw.backgroundcolor)
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ContainerDesign(
                                color: draw.backgroundcolor,
                                child: GetBuilder<uisetting>(
                                  builder: (_) => ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: uiset.searchpagelist.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            GestureDetector(
                                                onTap: () {
                                                  searchNode.unfocus();
                                                  controller.clear();
                                                  uiset.setsearchpageindex(
                                                      index);
                                                  uiset.seteditpage(
                                                      uiset
                                                          .searchpagelist[index]
                                                          .title,
                                                      uiset
                                                          .searchpagelist[index]
                                                          .username
                                                          .toString(),
                                                      uiset
                                                          .searchpagelist[index]
                                                          .id
                                                          .toString(),
                                                      uiset
                                                          .searchpagelist[index]
                                                          .setting
                                                          .toString());
                                                },
                                                child: ContainerDesign(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Flexible(
                                                          fit: FlexFit.tight,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                uiset
                                                                    .searchpagelist[
                                                                        index]
                                                                    .title,
                                                                softWrap: true,
                                                                maxLines: 2,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: TextStyle(
                                                                    color: draw
                                                                        .color_textstatus,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        contentTextsize()),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              Text(
                                                                uiset
                                                                    .searchpagelist[
                                                                        index]
                                                                    .username
                                                                    .toString(),
                                                                softWrap: true,
                                                                maxLines: 2,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: TextStyle(
                                                                    color: draw
                                                                        .color_textstatus,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        contentTextsize()),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              )
                                                            ],
                                                          )),
                                                      Icon(
                                                        Icons.chevron_right,
                                                        color: draw
                                                            .color_textstatus,
                                                      ),
                                                    ],
                                                  ),
                                                  color: draw.backgroundcolor,
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        );
                                      }),
                                ))
                          ],
                        );
                }
                return ContainerDesign(
                    child: SizedBox(
                      height: 40.h,
                      child: Center(
                        child: NeumorphicText(
                          'result_search'.tr,
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
                      ),
                    ),
                    color: draw.backgroundcolor);
              },
            ),
          ));
}

Se_Container1(
  double height,
) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Text(
                  'favoritetitle'.tr,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTitleTextsize(),
                      color: draw.color_textstatus),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Se_Container11(double height, TextEditingController controller, searchNode) {
  return GetBuilder<uisetting>(
      builder: (_) => Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: StreamBuilder<QuerySnapshot>(
              stream: SearchpageStreamParent(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  SearchpageChild2(snapshot);

                  return uiset.favorpagelist.isEmpty
                      ? ContainerDesign(
                          child: SizedBox(
                            height: 40.h,
                            child: Center(
                              child: NeumorphicText(
                                'result_search'.tr,
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
                            ),
                          ),
                          color: draw.backgroundcolor)
                      : ContainerDesign(
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: uiset.favorpagelist.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        searchNode.unfocus();
                                        controller.clear();
                                        uiset.setfavorpageindex(index);
                                        uiset.removeeditpage();
                                        uiset.seteditpage(
                                            uiset.favorpagelist[index].title,
                                            uiset.favorpagelist[index].username
                                                .toString(),
                                            uiset.favorpagelist[index].id
                                                .toString(),
                                            uiset.favorpagelist[index].setting
                                                .toString());
                                      },
                                      child: ContainerDesign(
                                        color: draw.backgroundcolor,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Flexible(
                                                fit: FlexFit.tight,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      uiset.favorpagelist[index]
                                                          .title,
                                                      softWrap: true,
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: draw
                                                              .color_textstatus,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              contentTextsize()),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      uiset.favorpagelist[index]
                                                          .username
                                                          .toString(),
                                                      softWrap: true,
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: draw
                                                              .color_textstatus,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              contentTextsize()),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )
                                                  ],
                                                )),
                                            Icon(
                                              Icons.chevron_right,
                                              color: draw.color_textstatus,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                );
                              }),
                          color: draw.backgroundcolor,
                        );
                }
                return ContainerDesign(
                    child: SizedBox(
                      height: 40.h,
                      child: Center(
                        child: NeumorphicText(
                          'result_search'.tr,
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
                      ),
                    ),
                    color: draw.backgroundcolor);
              },
            ),
          ));
}

Se_Container2(context, id, controller, searchNode) {
  return LayoutBuilder(
    builder: ((context, constraint) {
      return SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: UI(id, controller, searchNode, constraint.maxWidth,
              constraint.maxHeight));
    }),
  );
}
