// ignore_for_file: non_constant_identifier_names, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:clickbyme/BACKENDPART/FIREBASE/PersonalVP.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/Getx/linkspacesetting.dart';
import 'package:clickbyme/Tool/Getx/notishow.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:status_bar_control/status_bar_control.dart';
import '../DB/PageList.dart';
import '../Enums/Variables.dart';
import '../Route/subuiroute.dart';
import '../Tool/AppBarCustom.dart';
import '../Tool/FlushbarStyle.dart';
import '../Tool/Getx/category.dart';
import '../Tool/Getx/navibool.dart';
import '../Tool/Getx/uisetting.dart';
import '../Tool/NoBehavior.dart';
import '../Tool/TextSize.dart';
import '../sheets/linksettingsheet.dart';

class AddTemplate extends StatefulWidget {
  AddTemplate({Key? key, required this.id, indexcnt}) : super(key: key);
  final String id;
  int indexcnt = linkspaceset.indexcnt.length;
  @override
  State<StatefulWidget> createState() => _AddTemplateState();
}

class _AddTemplateState extends State<AddTemplate>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final notilist = Get.put(notishow());
  final uiset = Get.put(uisetting());
  final draw = Get.put(navibool());
  final cg = Get.put(category());
  final linkspaceset = Get.put(linkspacesetting());
  var _controller = TextEditingController();
  final searchNode = FocusNode();
  List spaceindata = [];

  @override
  void initState() {
    super.initState();
    draw.navi = 1;
    uiset.currentstepper = 0;
    cg.categorypicknumber = 99;
    Hive.box('user_setting').put('page_index', 4);
    WidgetsBinding.instance.addObserver(this);
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    //notilist.noticontroller.dispose();
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: draw.backgroundcolor,
        body: SafeArea(
          child: WillPopScope(
            onWillPop: _onWillPop,
            child: UI(),
          ),
        ));
  }

  UI() {
    double height = MediaQuery.of(context).size.height;
    return GetBuilder<navibool>(
        builder: (_) => AnimatedContainer(
            transform: Matrix4.translationValues(draw.xoffset, draw.yoffset, 0)
              ..scale(draw.scalefactor),
            duration: const Duration(milliseconds: 250),
            child: GetBuilder<navibool>(
              builder: (_) => GestureDetector(
                onTap: () {
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppBarCustom(
                            title: '스페이스 리스트',
                            righticon: false,
                            doubleicon: false,
                            iconname: Icons.add_box,
                          ),
                          GetBuilder<uisetting>(
                            builder: (_) => Flexible(
                                fit: FlexFit.tight,
                                child: SizedBox(
                                  child: ScrollConfiguration(
                                      behavior: NoBehavior(),
                                      child: SingleChildScrollView(
                                        physics: const ScrollPhysics(),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 0, 20, 0),
                                          child: GetBuilder<category>(
                                              builder: (_) => Pagination()),
                                        ),
                                      )),
                                )),
                          ),
                          ADSHOW(),
                        ],
                      )),
                ),
              ),
            )));
  }

  Pagination() {
    return GetBuilder<navibool>(
        builder: (_) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  '아래 스페이스 중 원하시는 스페이스를 선택하시면 됩니다.',
                  style: TextStyle(
                    fontSize: contentTextsize(),
                    color: draw.color_textstatus,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Page1(),
                const SizedBox(
                  height: 50,
                ),
                moveaction(),
                const SizedBox(
                  height: 50,
                )
              ],
            ));
  }

  moveaction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                if (cg.categorypicknumber == 99) {
                  Snack.snackbars(
                      context: context,
                      title: '스페이스 선택해주세요!',
                      backgroundcolor: Colors.black,
                      bordercolor: draw.backgroundcolor);
                } else {
                  func6(context, _controller, searchNode, 'addtemplate',
                      widget.id, cg.categorypicknumber, widget.indexcnt);
                }
              },
              child: ContainerDesign(
                  color: draw.backgroundcolor,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '완료',
                        style: TextStyle(
                          fontSize: contentTextsize(),
                          color: TextColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )),
            ))
      ],
    );
  }

  Page1() {
    List<String> listdata = [
      'URL, 파일, 사진 등을 담을 수 있는 스페이스',
      '일정정리를 도와주는 캘린더 스페이스',
      'Todo 리스트 스페이스',
      '메모 스페이스'
    ];
    return Column(
      children: [
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            primary: false,
            physics: const ScrollPhysics(),
            itemCount: listdata.length,
            itemBuilder: ((context, index) {
              return Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  GetBuilder<category>(
                      builder: (_) => GestureDetector(
                            onTap: () {
                              if (cg.categorypicknumber == index) {
                                cg.setcategorypicknumber(99);
                              } else {
                                cg.setcategorypicknumber(index);
                              }
                            },
                            child: ContainerDesign(
                                color: cg.categorypicknumber == index
                                    ? Colors.blue.shade200
                                    : draw.backgroundcolor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    cg.categorypicknumber == index
                                        ? const Icon(
                                            Icons.done_all,
                                            color: Colors.white,
                                            size: 25,
                                          )
                                        : Icon(
                                            Icons.ads_click,
                                            color: draw.color_textstatus,
                                            size: 25,
                                          ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Text(
                                        listdata[index],
                                        maxLines: 2,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: contentTextsize(),
                                          color: draw.color_textstatus,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.clip,
                                      ),
                                    )
                                  ],
                                )),
                          )),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );
            }))
      ],
    );
  }

  Future<bool> _onWillPop() async {
    Future.delayed(const Duration(seconds: 0), () {
      StatusBarControl.setColor(draw.backgroundcolor, animated: true);
      draw.setnavi();
      if (Hive.box('user_setting').get('page_index') == 11) {
        Hive.box('user_setting').put('page_index', 1);
      } else if (Hive.box('user_setting').get('page_index') == 12) {
        Hive.box('user_setting').put('page_index', 1);
      } else {
        Hive.box('user_setting').put('page_index', 0);
      }

      Get.back();
    });
    return false;
  }
}
