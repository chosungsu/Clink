// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:math';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/Getx/linkspacesetting.dart';
import 'package:clickbyme/Tool/Getx/uisetting.dart';
import 'package:clickbyme/Tool/IconBtn.dart';
import 'package:clickbyme/Tool/NoBehavior.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/sheets/linksettingsheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:status_bar_control/status_bar_control.dart';
import '../DB/Linkpage.dart';
import '../Route/subuiroute.dart';
import '../../../Tool/Getx/memosetting.dart';
import '../../../Tool/Getx/selectcollection.dart';
import '../mongoDB/mongodatabase.dart';

class Linkin extends StatefulWidget {
  const Linkin({
    Key? key,
    required this.isfromwhere,
    required this.name,
  }) : super(key: key);
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
  final controll_memo = Get.put(memosetting());
  final uiset = Get.put(uisetting());
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final searchNode = FocusNode();
  final changenamenode = FocusNode();
  String username = Hive.box('user_info').get(
    'id',
  );
  List<FocusNode> nodes = [];
  String usercode = Hive.box('user_setting').get('usercode');
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isresponsive = false;
  late FToast fToast;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  final List<Linkspacepage> listspacepageset = [];
  final chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random rnd = Random();
  bool serverstatus = Hive.box('user_info').get('server_status');

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
        if (scrollController.offset >= 50) {
          uiset.settopbutton(true); // show the back-to-top button
        } else {
          uiset.settopbutton(false); // hide the back-to-top button
        }
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
    return GetBuilder<linkspacesetting>(
      builder: (_) => Scaffold(
          backgroundColor: linkspaceset.color,
          body: SafeArea(
            child: WillPopScope(
              onWillPop: _onWillPop,
              child: UI(),
            ),
          ),
          floatingActionButton: Speeddialmemo(
              context,
              usercode,
              controller,
              searchNode,
              scollection,
              scrollController,
              isresponsive,
              isDialOpen,
              widget.name)),
    );
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
                                    Flexible(
                                        child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            fit: FlexFit.tight,
                                            child: Text('',
                                                style: TextStyle(
                                                  fontSize: mainTitleTextsize(),
                                                  color: linkspaceset.color ==
                                                          Colors.black
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              linkmadeplace(context, usercode,
                                                  widget.name, 'add', -1);
                                            },
                                            child: IconBtn(
                                              child: Container(
                                                alignment: Alignment.center,
                                                width: 30,
                                                height: 30,
                                                margin:
                                                    const EdgeInsets.all(10),
                                                child: NeumorphicIcon(
                                                  Icons.add,
                                                  size: 30,
                                                  style: NeumorphicStyle(
                                                      shape: NeumorphicShape
                                                          .convex,
                                                      depth: 2,
                                                      surfaceIntensity: 0.5,
                                                      color:
                                                          linkspaceset.color ==
                                                                  Colors.black
                                                              ? Colors.white
                                                              : Colors.black,
                                                      lightSource:
                                                          LightSource.topLeft),
                                                ),
                                              ),
                                              color: linkspaceset.color ==
                                                      Colors.black
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              linksetting(
                                                context,
                                                widget.name,
                                              );
                                            },
                                            child: IconBtn(
                                              child: Container(
                                                alignment: Alignment.center,
                                                width: 30,
                                                height: 30,
                                                margin:
                                                    const EdgeInsets.all(10),
                                                child: NeumorphicIcon(
                                                  Icons.settings,
                                                  size: 30,
                                                  style: NeumorphicStyle(
                                                      shape: NeumorphicShape
                                                          .convex,
                                                      depth: 2,
                                                      surfaceIntensity: 0.5,
                                                      color:
                                                          linkspaceset.color ==
                                                                  Colors.black
                                                              ? Colors.white
                                                              : Colors.black,
                                                      lightSource:
                                                          LightSource.topLeft),
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
                  ScrollConfiguration(
                    behavior: NoBehavior(),
                    child: Flexible(
                      fit: FlexFit.tight,
                      child: GetBuilder<linkspacesetting>(
                          builder: (_) => listy_My()),
                    ),
                  )
                ],
              )),
        ));
  }

  listy_My() {
    var user, linkname;

    return GetBuilder<linkspacesetting>(
        builder: (_) => serverstatus == true
            ? FutureBuilder(
                future: MongoDB.getData(collectionname: 'pinchannelin')
                    .then((value) {
                  linkspaceset.indexcnt.clear();

                  //listspacepageset.clear();
                  if (value.isEmpty) {
                  } else {
                    for (var sp in value) {
                      user = sp['username'];
                      linkname = sp['linkname'];
                      if (usercode == user && widget.name == linkname) {
                        linkspaceset.indexcnt.add(Linkspacepage(
                            index: int.parse(sp['index'].toString()),
                            placestr: sp['placestr']));
                      }
                    }
                    linkspaceset.indexcnt.sort(((a, b) {
                      return a.index.compareTo(b.index);
                    }));
                  }
                }),
                builder: (context, snapshot) {
                  return linkspaceset.indexcnt.isEmpty
                      ? SizedBox(
                          child: Center(
                          child: NeumorphicText(
                            '텅! 비어있어요~',
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.flat,
                              depth: 3,
                              color: TextColor_shadowcolor(),
                            ),
                            textStyle: NeumorphicTextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: contentTitleTextsize(),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ))
                      : GridView.builder(
                          controller: scrollController,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          physics: const ScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  childAspectRatio: 5 / 4,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20),
                          itemCount: linkspaceset.indexcnt.length,
                          itemBuilder: ((context, index) {
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: GestureDetector(
                                      onTap: () async {},
                                      child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.grey.shade200,
                                          ),
                                          child: SizedBox(
                                              child: Column(
                                            children: [
                                              Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Flexible(
                                                      fit: FlexFit.tight,
                                                      child: Text(
                                                        linkspaceset
                                                            .indexcnt[index]
                                                            .placestr
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black45,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                contentTextsize()),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {},
                                                      child: const Icon(
                                                        Icons
                                                            .add_circle_outline,
                                                        color: Colors.black45,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        controller.text = '';
                                                        linkplacechangeoptions(
                                                            context,
                                                            usercode,
                                                            widget.name,
                                                            index,
                                                            changenamenode,
                                                            controller);
                                                      },
                                                      child: const Icon(
                                                        Icons.more_horiz,
                                                        color: Colors.black45,
                                                      ),
                                                    )
                                                  ])
                                            ],
                                          )))),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            );
                          }));
                },
              )
            : StreamBuilder<QuerySnapshot>(
                stream: firestore.collection('Pinchannelin').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    //listspacepageset.clear();
                    linkspaceset.indexcnt.clear();
                    final valuespace = snapshot.data!.docs;
                    for (var sp in valuespace) {
                      user = sp.get('username');
                      linkname = sp.get('linkname');
                      if (user == usercode && linkname == widget.name) {
                        linkspaceset.indexcnt.add(Linkspacepage(
                            index: int.parse(sp.get('index').toString()),
                            placestr: sp.get('placestr')));
                      }
                    }
                    linkspaceset.indexcnt.sort(((a, b) {
                      return a.index.compareTo(b.index);
                    }));
                    return linkspaceset.indexcnt.isEmpty
                        ? SizedBox(
                            child: Center(
                            child: NeumorphicText(
                              '텅! 비어있어요~',
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                depth: 3,
                                color: TextColor_shadowcolor(),
                              ),
                              textStyle: NeumorphicTextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: contentTitleTextsize(),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ))
                        : GridView.builder(
                            controller: scrollController,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            physics: const ScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1,
                                    childAspectRatio: 5 / 4,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20),
                            itemCount: linkspaceset.indexcnt.length,
                            itemBuilder: ((context, index) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                      onTap: () async {},
                                      child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.grey.shade200,
                                          ),
                                          child: SizedBox(
                                              child: Column(
                                            children: [
                                              Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Flexible(
                                                      fit: FlexFit.tight,
                                                      child: Text(
                                                        linkspaceset
                                                            .indexcnt[index]
                                                            .placestr
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black45,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                contentTextsize()),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {},
                                                      child: const Icon(
                                                        Icons
                                                            .add_circle_outline,
                                                        color: Colors.black45,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        controller.text = '';
                                                        linkplacechangeoptions(
                                                            context,
                                                            usercode,
                                                            widget.name,
                                                            index,
                                                            changenamenode,
                                                            controller);
                                                      },
                                                      child: const Icon(
                                                        Icons.more_horiz,
                                                        color: Colors.black45,
                                                      ),
                                                    )
                                                  ]),
                                              linkspaceset.indexcnt[index]
                                                          .placestr ==
                                                      'board'
                                                  ? Row()
                                                  : (linkspaceset
                                                              .indexcnt[index]
                                                              .placestr ==
                                                          'card'
                                                      ? Row()
                                                      : Row())
                                            ],
                                          )))),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              );
                            }));
                  }
                  return LinearProgressIndicator(
                    backgroundColor: BGColor(),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blue),
                  );
                },
              ));
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
