import 'dart:async';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/Getx/linkspacesetting.dart';
import 'package:clickbyme/Tool/Getx/uisetting.dart';
import 'package:clickbyme/Tool/IconBtn.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/sheets/linksettingsheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:local_auth/local_auth.dart';
import 'package:status_bar_control/status_bar_control.dart';
import '../Route/subuiroute.dart';
import '../../../Tool/Getx/memosetting.dart';
import '../../../Tool/Getx/selectcollection.dart';
import '../../../Tool/NoBehavior.dart';

class Linkin extends StatefulWidget {
  const Linkin({Key? key, required this.isfromwhere, required this.name})
      : super(key: key);
  final String isfromwhere;
  final String name;

  @override
  State<StatefulWidget> createState() => _LinkinState();
}

class _LinkinState extends State<Linkin> with WidgetsBindingObserver {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  final linkspaceset = Get.put(linkspacesetting());
  final scollection = Get.put(selectcollection());
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final searchNode = FocusNode();
  final changenamenode = FocusNode();
  String username = Hive.box('user_info').get(
    'id',
  );
  String usercode = Hive.box('user_setting').get('usercode');
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isresponsive = false;
  late FToast fToast;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    WidgetsBinding.instance.addObserver(this);
    StatusBarControl.setColor(linkspaceset.color, animated: true);
    Hive.box('user_setting').put('sort_memo_card', 0);
    controller = TextEditingController();
    scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (scrollController.offset >= 150) {
            uisetting().showtopbutton = true; // show the back-to-top button
          } else {
            uisetting().showtopbutton = false; // hide the back-to-top button
          }
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).size.height > 900
        ? isresponsive = true
        : isresponsive = false;
    return SafeArea(
        child: GetBuilder<linkspacesetting>(
      builder: (_) => Scaffold(
          backgroundColor: linkspaceset.color,
          body: WillPopScope(
            onWillPop: _onWillPop,
            child: UI(),
          ),
          floatingActionButton: Speeddialmemo(
              context,
              uisetting().showtopbutton,
              usercode,
              controller,
              searchNode,
              scollection,
              scrollController,
              isresponsive,
              isDialOpen)),
    ));
  }

  UI() {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
        height: height,
        child: GetBuilder<linkspacesetting>(
          builder: (_) => Container(
              decoration: BoxDecoration(color: linkspaceset.color),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 10, top: 5, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                                fit: FlexFit.tight,
                                child: Row(
                                  children: [
                                    IconBtn(
                                      child: IconButton(
                                          onPressed: () {
                                            Future.delayed(
                                                const Duration(seconds: 0), () {
                                              if (widget.isfromwhere ==
                                                  'home') {
                                                GoToMain(context);
                                              } else {
                                                Get.back();
                                              }
                                            });
                                          },
                                          icon: Container(
                                            alignment: Alignment.center,
                                            width: 30,
                                            height: 30,
                                            child: NeumorphicIcon(
                                              Icons.keyboard_arrow_left,
                                              size: 30,
                                              style: NeumorphicStyle(
                                                  shape: NeumorphicShape.convex,
                                                  depth: 2,
                                                  surfaceIntensity: 0.5,
                                                  color: linkspaceset.color ==
                                                          Colors.black
                                                      ? Colors.white
                                                      : Colors.black,
                                                  lightSource:
                                                      LightSource.topLeft),
                                            ),
                                          )),
                                      color: linkspaceset.color == Colors.black
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                80,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Text('',
                                                    style: TextStyle(
                                                      fontSize:
                                                          mainTitleTextsize(),
                                                      color:
                                                          linkspaceset.color ==
                                                                  Colors.black
                                                              ? Colors.white
                                                              : Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                              ),
                                              FocusedMenuHolder(
                                                menuItems: [
                                                  FocusedMenuItem(
                                                      trailingIcon: const Icon(
                                                        Icons.palette,
                                                        size: 30,
                                                        color: Colors.black,
                                                      ),
                                                      title: Text('배경색 설정',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  contentTextsize())),
                                                      onPressed: () async {
                                                        linksetting(
                                                          context,
                                                          widget.name,
                                                        );
                                                      }),
                                                ],
                                                duration:
                                                    const Duration(seconds: 0),
                                                animateMenuItems: true,
                                                menuOffset: 20,
                                                bottomOffsetHeight: 10,
                                                menuWidth:
                                                    (MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            40) /
                                                        1.5,
                                                openWithTap: true,
                                                onPressed: () {},
                                                child: IconBtn(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    width: 30,
                                                    height: 30,
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: NeumorphicIcon(
                                                      Icons.more_horiz,
                                                      size: 30,
                                                      style: NeumorphicStyle(
                                                          shape: NeumorphicShape
                                                              .convex,
                                                          depth: 2,
                                                          surfaceIntensity: 0.5,
                                                          color: linkspaceset
                                                                      .color ==
                                                                  Colors.black
                                                              ? Colors.white
                                                              : Colors.black,
                                                          lightSource:
                                                              LightSource
                                                                  .topLeft),
                                                    ),
                                                  ),
                                                  color: linkspaceset.color ==
                                                          Colors.black
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                        )),
                                  ],
                                )),
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  ADSHOW(height),
                  const SizedBox(
                    height: 10,
                  ),
                  Flexible(
                      fit: FlexFit.tight,
                      child: SizedBox(
                        child: ScrollConfiguration(
                          behavior: NoBehavior(),
                          child: SingleChildScrollView(
                              controller: scrollController,
                              physics: const ScrollPhysics(),
                              child: StatefulBuilder(
                                  builder: (_, StateSetter setState) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      listy_My(),
                                    ],
                                  ),
                                );
                              })),
                        ),
                      )),
                ],
              )),
        ));
  }

  listy_My() {
    String realusername = '';
    return StatefulBuilder(builder: (_, StateSetter setState) {
      return Column(
        children: [],
      );
    });
  }

  Future<bool> _onWillPop() async {
    Future.delayed(const Duration(seconds: 0), () {
      if (isDialOpen.value == true) {
        isDialOpen.value = false;
      } else {
        StatusBarControl.setColor(BGColor(), animated: true);
        if (widget.isfromwhere == 'home') {
          GoToMain(context);
        } else {
          Get.back();
        }
      }
    });
    return false;
  }
}
