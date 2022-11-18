// ignore_for_file: non_constant_identifier_names, prefer_final_fields, prefer_typing_uninitialized_variables, prefer_const_constructors

import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/Getx/uisetting.dart';
import 'package:clickbyme/Tool/AppBarCustom.dart';
import 'package:clickbyme/UI/Home/UI_folder/SearchUI.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import '../Enums/Variables.dart';
import '../Tool/Getx/navibool.dart';
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
  ScrollController scrollController = ScrollController();
  final uiset = Get.put(uisetting());

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller2 = TextEditingController();
    Hive.box('user_setting').put('page_index', 1);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    controller2.dispose();
    searchNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: BGColor(),
      body: GetBuilder<navibool>(
        init: navibool(),
        builder: (_) => draw.navi == 0
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
                                    iconname: Icons.notifications_none,
                                  )
                                : GetBuilder<uisetting>(
                                    builder: (_) => FutureBuilder(
                                        future: firestore
                                            .collection('Favorplace')
                                            .get()
                                            .then((value) {
                                          checkid = '';
                                          if (value.docs.isEmpty) {
                                            checkid = '';
                                          } else {
                                            final valuespace = value.docs;

                                            for (int i = 0;
                                                i < valuespace.length;
                                                i++) {
                                              if (valuespace[i]
                                                      ['favoradduser'] ==
                                                  usercode) {
                                                if (valuespace[i]['title'] ==
                                                    (Hive.box('user_setting').get(
                                                            'currenteditpage') ??
                                                        '')) {
                                                  checkid = valuespace[i].id;
                                                }
                                              }
                                            }
                                          }
                                        }),
                                        builder: ((context, snapshot) {
                                          if (checkid != '') {
                                            return Column(
                                              children: [
                                                AppBarCustom(
                                                  title: uiset.searchpagemove,
                                                  righticon: true,
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
                                                  iconname: Icons.star_border,
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                              ],
                                            );
                                          }
                                        }))),
                            SearchUI(scrollController, controller, height,
                                controller2)
                          ],
                        ),
                      )),
                ),
              ),
            ));
  }
}
