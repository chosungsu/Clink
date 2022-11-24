// ignore_for_file: non_constant_identifier_names, prefer_final_fields, prefer_typing_uninitialized_variables, prefer_const_constructors

import 'package:clickbyme/BACKENDPART/FIREBASE/SearchVP.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/Getx/uisetting.dart';
import 'package:clickbyme/Tool/AppBarCustom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../Enums/Variables.dart';
import '../Tool/Getx/navibool.dart';
import '../UI/SearchUI.dart';
import 'DrawerScreen.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.secondname}) : super(key: key);
  final String secondname;
  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  var controller;
  var controller2;
  final searchNode = FocusNode();
  ScrollController scrollController = ScrollController();
  final uiset = Get.put(uisetting());
  final draw = Get.put(navibool());

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller2 = TextEditingController();
    Hive.box('user_setting').put('page_index', 1);
    draw.navi = Hive.box('user_setting').get('which_menu_pick');
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    controller2.dispose();
    searchNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: BGColor(),
      body: GetBuilder<navibool>(
        init: navibool(),
        builder: (_) => draw.navi == 0 ||
                MediaQuery.of(context).orientation == Orientation.landscape
            ? (draw.drawopen == true
                ? Stack(
                    children: [
                      SizedBox(
                        width: 80,
                        child: DrawerScreen(
                            index: Hive.box('user_setting').get('page_index')),
                      ),
                      HomeUi(),
                    ],
                  )
                : Stack(
                    children: [
                      HomeUi(),
                    ],
                  ))
            : Stack(
                children: [
                  HomeUi(),
                ],
              ),
      ),
    ));
  }

  HomeUi() {
    double height = MediaQuery.of(context).size.height;

    return GetBuilder<navibool>(
        builder: (_) => AnimatedContainer(
              transform:
                  Matrix4.translationValues(draw.xoffset, draw.yoffset, 0)
                    ..scale(draw.scalefactor),
              duration: const Duration(milliseconds: 250),
              child: GestureDetector(
                onTap: () {
                  searchNode.unfocus();
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
                      //decoration: BoxDecoration(color: colorselection),
                      child: GetBuilder<uisetting>(
                        builder: (_) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            uiset.searchpagemove == ''
                                ? AppBarCustom(
                                    title: '',
                                    righticon: false,
                                    doubleicon: false,
                                    iconname: Icons.notifications_none,
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
                                                    righticon: true,
                                                    doubleicon: true,
                                                    iconname: Icons.star,
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
                                                    doubleicon: true,
                                                    iconname: Icons.star_border,
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
                                              doubleicon: false,
                                              iconname:
                                                  Icons.notifications_none,
                                            );
                                          }
                                        }))),
                            SearchUI(scrollController, controller, height,
                                controller2, searchNode)
                          ],
                        ),
                      )),
                ),
              ),
            ));
  }
}
