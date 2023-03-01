// ignore_for_file: non_constant_identifier_names, prefer_final_fields, prefer_typing_uninitialized_variables, prefer_const_constructors

import 'package:clickbyme/BACKENDPART/FIREBASE/SearchVP.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/BACKENDPART/Getx/uisetting.dart';
import 'package:clickbyme/Tool/AppBarCustom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import '../../BACKENDPART/Enums/Variables.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../Tool/Loader.dart';
import '../UI(Widget/SearchUI.dart';
import 'DrawerScreen.dart';
import 'NotiAlarm.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  var controller;
  var controller2;
  var controller3;
  final searchNode = FocusNode();
  ScrollController scrollController = ScrollController();
  final uiset = Get.put(uisetting());
  final draw = Get.put(navibool());

  @override
  void initState() {
    super.initState();
    uiset.searchpagemove = '';
    uiset.textrecognizer = '';
    controller = TextEditingController();
    controller2 = TextEditingController();
    controller3 = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    controller2.dispose();
    controller3.dispose();
    searchNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = Get.width < 1000 ? Get.width * 0.7 : Get.width * 0.5;
    double height = Get.height > 1500 ? Get.height * 0.5 : Get.height;
    return SafeArea(
        child: Scaffold(
      backgroundColor: BGColor(),
      body: GetBuilder<navibool>(
          init: navibool(),
          builder: (_) => draw.drawopen == true
              ? Stack(
                  children: [
                    draw.navi == 0
                        ? Positioned(
                            left: 0,
                            child: SizedBox(
                              width: 120,
                              child: DrawerScreen(),
                            ),
                          )
                        : Positioned(
                            right: 0,
                            child: SizedBox(
                              width: 120,
                              child: DrawerScreen(),
                            ),
                          ),
                    HomeUi(),
                  ],
                )
              : (draw.drawnoticeopen == true
                  ? Stack(
                      children: [
                        HomeUi(),
                        const Barrier(),
                        Positioned(
                          right: 0,
                          child: SizedBox(
                            width: width,
                            height: height,
                            child: const NotiAlarm(),
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      children: [
                        HomeUi(),
                      ],
                    ))),
    ));
  }

  HomeUi() {
    return GetBuilder<navibool>(
        builder: (_) => AnimatedContainer(
              transform:
                  Matrix4.translationValues(draw.xoffset, draw.yoffset, 0)
                    ..scale(draw.scalefactor),
              duration: const Duration(milliseconds: 250),
              child: GestureDetector(
                onTap: () {
                  searchNode.unfocus();
                  draw.drawopen == true && draw.navishow == false
                      ? setState(() {
                          draw.drawopen = false;
                          draw.setclose();
                          draw.setclosenoti();
                          Hive.box('user_setting').put('page_opened', false);
                        })
                      : null;
                },
                child: SizedBox(
                  height: Get.height,
                  width: Get.width,
                  child: Container(
                      color: draw.backgroundcolor,
                      //decoration: BoxDecoration(color: colorselection),
                      child: GetBuilder<uisetting>(builder: (_) {
                        return Row(
                          children: [
                            draw.navi == 0 && draw.navishow == true
                                ? const SizedBox(
                                    width: 120,
                                    child: DrawerScreen(),
                                  )
                                : const SizedBox(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                uiset.searchpagemove == ''
                                    ? AppBarCustom(
                                        title: '',
                                        lefticon: false,
                                        lefticonname: Icons.add,
                                        righticon: false,
                                        doubleicon: false,
                                        righticonname: Icons.notifications_none,
                                      )
                                    : GetBuilder<uisetting>(
                                        builder: (_) => StreamBuilder<
                                                QuerySnapshot>(
                                            stream: SearchpageStreamParent(),
                                            builder: ((context, snapshot) {
                                              if (snapshot.hasData) {
                                                SearchpageChild0(snapshot);
                                                if (checkid != '') {
                                                  return Column(
                                                    children: [
                                                      AppBarCustom(
                                                        title: uiset
                                                            .searchpagemove,
                                                        lefticon: false,
                                                        lefticonname: Icons.add,
                                                        righticon: true,
                                                        doubleicon: true,
                                                        righticonname:
                                                            Icons.star,
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                    ],
                                                  );
                                                } else {
                                                  return Column(
                                                    children: [
                                                      AppBarCustom(
                                                        title: uiset
                                                            .searchpagemove,
                                                        righticon: true,
                                                        lefticon: false,
                                                        lefticonname: Icons.add,
                                                        doubleicon: true,
                                                        righticonname:
                                                            Icons.star_border,
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                    ],
                                                  );
                                                }
                                              } else {
                                                return AppBarCustom(
                                                  title: '',
                                                  righticon: false,
                                                  lefticon: false,
                                                  lefticonname: Icons.add,
                                                  doubleicon: false,
                                                  righticonname:
                                                      Icons.notifications_none,
                                                );
                                              }
                                            }))),
                                SearchUI(
                                    context,
                                    scrollController,
                                    controller,
                                    draw.navishow == true
                                        ? Get.width - 120
                                        : Get.width,
                                    controller2,
                                    searchNode,
                                    controller3)
                              ],
                            ),
                            draw.navi == 1 && draw.navishow == true
                                ? const SizedBox(
                                    width: 120,
                                    child: DrawerScreen(),
                                  )
                                : const SizedBox(),
                          ],
                        );
                      })),
                ),
              ),
            ));
  }
}
/**
 * Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            uiset.searchpagemove == ''
                                ? AppBarCustom(
                                    title: '',
                                    lefticon: false,
                                    lefticonname: Icons.add,
                                    righticon: false,
                                    doubleicon: false,
                                    righticonname: Icons.notifications_none,
                                  )
                                : GetBuilder<uisetting>(
                                    builder: (_) => StreamBuilder<
                                            QuerySnapshot>(
                                        stream: SearchpageStreamParent(),
                                        builder: ((context, snapshot) {
                                          if (snapshot.hasData) {
                                            SearchpageChild0(snapshot);
                                            if (checkid != '') {
                                              return Column(
                                                children: [
                                                  AppBarCustom(
                                                    title: uiset.searchpagemove,
                                                    lefticon: false,
                                                    lefticonname: Icons.add,
                                                    righticon: true,
                                                    doubleicon: true,
                                                    righticonname: Icons.star,
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return Column(
                                                children: [
                                                  AppBarCustom(
                                                    title: uiset.searchpagemove,
                                                    righticon: true,
                                                    lefticon: false,
                                                    lefticonname: Icons.add,
                                                    doubleicon: true,
                                                    righticonname:
                                                        Icons.star_border,
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                ],
                                              );
                                            }
                                          } else {
                                            return AppBarCustom(
                                              title: '',
                                              righticon: false,
                                              lefticon: false,
                                              lefticonname: Icons.add,
                                              doubleicon: false,
                                              righticonname:
                                                  Icons.notifications_none,
                                            );
                                          }
                                        }))),
                            SearchUI(context, scrollController, controller,
                                height, controller2, searchNode, controller3)
                          ],
                        ),
 */