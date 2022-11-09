// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, unused_local_variable

import 'dart:async';
import 'dart:math';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
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
import '../UI/Home/firstContentNet/ChooseCalendar.dart';
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
    uiset.showtopbutton = false;
    StatusBarControl.setColor(linkspaceset.color, animated: true);
    Hive.box('user_setting').put('sort_memo_card', 0);
    controller = TextEditingController();
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.offset >= 300) {
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
    var user, linkname, placestr;

    return GetBuilder<linkspacesetting>(
        builder: (_) => serverstatus == true
            ? FutureBuilder(
                future: MongoDB.getData(collectionname: 'pinchannelin')
                    .then((value) {
                  linkspaceset.indexcnt.clear();
                  linkspaceset.indextreetmp.clear();
                  if (value.isEmpty) {
                  } else {
                    for (var sp in value) {
                      user = sp['username'];
                      linkname = sp['linkname'];
                      if (usercode == user && widget.name == linkname) {
                        linkspaceset.indextreetmp
                            .add(List.empty(growable: true));
                        linkspaceset.indexcnt.add(Linkspacepage(
                            index: int.parse(sp['index'].toString()),
                            placestr: sp['placestr'],
                            uniquecode: sp['uniquecode']));
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
                      : ListView.builder(
                          controller: scrollController,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          physics: const ScrollPhysics(),
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
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Flexible(
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      linkspaceset
                                                                  .indexcnt[
                                                                      index]
                                                                  .placestr ==
                                                              'board'
                                                          ? '보드'
                                                          : (linkspaceset
                                                                      .indexcnt[
                                                                          index]
                                                                      .placestr ==
                                                                  'card'
                                                              ? '링크 및 파일'
                                                              : '캘린더'),
                                                      style: TextStyle(
                                                          color: Colors.black45,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              contentTextsize()),
                                                    ),
                                                  ),
                                                  linkspaceset.indexcnt[index]
                                                              .placestr ==
                                                          'calendar'
                                                      ? const SizedBox()
                                                      : InkWell(
                                                          onTap: () {
                                                            linkmadetreeplace(
                                                                context,
                                                                usercode,
                                                                widget.name,
                                                                linkspaceset
                                                                    .indexcnt[
                                                                        index]
                                                                    .placestr,
                                                                linkspaceset
                                                                    .indextreetmp[
                                                                        index]
                                                                    .length,
                                                                linkspaceset
                                                                    .indexcnt[
                                                                        index]
                                                                    .uniquecode);
                                                          },
                                                          child: const Icon(
                                                            Icons
                                                                .add_circle_outline,
                                                            color:
                                                                Colors.black45,
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
                                                          controller,
                                                          linkspaceset
                                                              .indexcnt[index]
                                                              .placestr,
                                                          linkspaceset
                                                              .indexcnt[index]
                                                              .uniquecode);
                                                    },
                                                    child: const Icon(
                                                      Icons.more_horiz,
                                                      color: Colors.black45,
                                                    ),
                                                  )
                                                ]),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            FutureBuilder(
                                                future: MongoDB.getData(
                                                  collectionname: 'linknet',
                                                ).then((value) {
                                                  linkspaceset
                                                      .indextreetmp[index]
                                                      .clear();
                                                  if (value.isEmpty) {
                                                  } else {
                                                    for (var sp in value) {
                                                      user = sp['username'];
                                                      placestr = sp['placestr'];
                                                      if (usercode == user &&
                                                          linkspaceset
                                                                  .indexcnt[
                                                                      index]
                                                                  .placestr ==
                                                              placestr) {
                                                        linkspaceset
                                                            .indextreetmp[index]
                                                            .add(Linkspacetreepage(
                                                                subindex: linkspaceset
                                                                    .indextreetmp[
                                                                        index]
                                                                    .length,
                                                                placestr: sp[
                                                                    'addname'],
                                                                uniqueid: sp[
                                                                    'uniquecode']));
                                                      }
                                                    }
                                                    linkspaceset
                                                        .indextreetmp[index]
                                                        .sort(((a, b) {
                                                      return a.subindex
                                                          .compareTo(
                                                              b.subindex);
                                                    }));
                                                  }
                                                }),
                                                builder: ((context, snapshot) {
                                                  if (linkspaceset
                                                      .indextreetmp[index]
                                                      .isNotEmpty) {
                                                    return SizedBox(
                                                        height: linkspaceset.indexcnt[index].placestr == 'board'
                                                            ? (linkspaceset
                                                                    .indextreetmp[
                                                                        index]
                                                                    .length) *
                                                                200
                                                            : (linkspaceset.indexcnt[index].placestr == 'card'
                                                                ? (linkspaceset
                                                                        .indextreetmp[
                                                                            index]
                                                                        .length) *
                                                                    130
                                                                : 130),
                                                        child: ListView.builder(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              left: 10,
                                                              right: 10,
                                                            ),
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            shrinkWrap: true,
                                                            physics:
                                                                const ScrollPhysics(),
                                                            itemCount: linkspaceset
                                                                        .indexcnt[
                                                                            index]
                                                                        .placestr ==
                                                                    'calendar'
                                                                ? 1
                                                                : linkspaceset
                                                                    .indextreetmp[index]
                                                                    .length,
                                                            itemBuilder: ((context, index2) {
                                                              return Column(
                                                                children: [
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      if (linkspaceset
                                                                              .indexcnt[index]
                                                                              .placestr ==
                                                                          'calendar') {
                                                                        Get.to(
                                                                            () =>
                                                                                const ChooseCalendar(isfromwhere: 'mypagehome', index: 0),
                                                                            transition: Transition.rightToLeft);
                                                                      } else {}
                                                                    },
                                                                    child: ContainerDesign(
                                                                        color: Colors.white,
                                                                        child: SizedBox(
                                                                          height: linkspaceset.indexcnt[index].placestr == 'board'
                                                                              ? 150
                                                                              : (linkspaceset.indexcnt[index].placestr == 'card' ? 80 : 80),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  controller.text = linkspaceset.indextreetmp[index][index2].placestr == '' ? '' : linkspaceset.indextreetmp[index][index2].placestr;
                                                                                  linkplacenamechange(context, usercode, linkspaceset.indextreetmp[index][index2].uniqueid, index2, linkspaceset.indextreetmp[index][index2].placestr, changenamenode, controller, linkspaceset.indexcnt[index].placestr);
                                                                                },
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    Flexible(
                                                                                      fit: FlexFit.tight,
                                                                                      child: Text(
                                                                                        linkspaceset.indextreetmp[index][index2].placestr == '' ? '제목없음' : linkspaceset.indextreetmp[index][index2].placestr,
                                                                                        textAlign: TextAlign.start,
                                                                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: contentTextsize()),
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    const Icon(
                                                                                      Icons.edit,
                                                                                      color: Colors.black45,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                ],
                                                              );
                                                            })));
                                                  } else {
                                                    return SizedBox(
                                                      height: 100,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Center(
                                                            child: Text(
                                                              linkspaceset
                                                                          .indexcnt[
                                                                              index]
                                                                          .placestr ==
                                                                      'board'
                                                                  ? '보드 공간은 이미지모음, 메모를 클립보드 형식으로 보여주는 공간입니다.'
                                                                  : (linkspaceset
                                                                              .indexcnt[index]
                                                                              .placestr ==
                                                                          'card'
                                                                      ? '카드 공간은 링크 및 파일을 바로가기 카드뷰로 보여주는 공간입니다.'
                                                                      : '캘린더 공간은 캘린더 형식만을 보여주는 공간입니다.'),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black45,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      contentTextsize()),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                }))
                                          ],
                                        )))),
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
                    linkspaceset.indextreetmp.clear();
                    linkspaceset.indexcnt.clear();
                    final valuespace = snapshot.data!.docs;
                    for (var sp in valuespace) {
                      user = sp.get('username');
                      linkname = sp.get('linkname');
                      if (user == usercode && linkname == widget.name) {
                        linkspaceset.indextreetmp
                            .add(List.empty(growable: true));
                        linkspaceset.indexcnt.add(Linkspacepage(
                            index: int.parse(sp.get('index').toString()),
                            placestr: sp.get('placestr'),
                            uniquecode: sp.get('uniquecode')));
                      }
                    }
                    linkspaceset.indexcnt.sort(((a, b) {
                      return a.uniqueid.compareTo(b.uniqueid);
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
                        : ListView.builder(
                            controller: scrollController,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            physics: const ScrollPhysics(),
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Flexible(
                                                      fit: FlexFit.tight,
                                                      child: Text(
                                                        linkspaceset
                                                                    .indexcnt[
                                                                        index]
                                                                    .placestr ==
                                                                'board'
                                                            ? '보드'
                                                            : (linkspaceset
                                                                        .indexcnt[
                                                                            index]
                                                                        .placestr ==
                                                                    'card'
                                                                ? '링크 및 파일'
                                                                : '캘린더'),
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
                                                      onTap: () {
                                                        linkmadetreeplace(
                                                            context,
                                                            usercode,
                                                            widget.name,
                                                            linkspaceset
                                                                .indexcnt[index]
                                                                .placestr,
                                                            index,
                                                            linkspaceset
                                                                .indexcnt[index]
                                                                .uniquecode);
                                                      },
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
                                                            controller,
                                                            linkspaceset
                                                                .indexcnt[index]
                                                                .placestr,
                                                            linkspaceset
                                                                .indexcnt[index]
                                                                .uniquecode);
                                                      },
                                                      child: const Icon(
                                                        Icons.more_horiz,
                                                        color: Colors.black45,
                                                      ),
                                                    )
                                                  ]),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              FutureBuilder(
                                                  future: MongoDB.getData(
                                                    collectionname: 'linknet',
                                                  ).then((value) {
                                                    linkspaceset
                                                        .indextreetmp[index]
                                                        .clear();
                                                    if (value.isEmpty) {
                                                    } else {
                                                      for (var sp in value) {
                                                        user = sp['username'];
                                                        placestr =
                                                            sp['placestr'];
                                                        if (usercode == user &&
                                                            linkspaceset
                                                                    .indexcnt[
                                                                        index]
                                                                    .placestr ==
                                                                placestr) {
                                                          linkspaceset
                                                              .indextreetmp[
                                                                  index]
                                                              .add(Linkspacetreepage(
                                                                  subindex: linkspaceset
                                                                      .indextreetmp[
                                                                          index]
                                                                      .length,
                                                                  placestr: sp[
                                                                      'addname'],
                                                                  uniqueid: sp[
                                                                      'uniquecode']));
                                                        }
                                                      }
                                                      linkspaceset
                                                          .indextreetmp[index]
                                                          .sort(((a, b) {
                                                        return a.subindex
                                                            .compareTo(
                                                                b.subindex);
                                                      }));
                                                    }
                                                  }),
                                                  builder:
                                                      ((context, snapshot) {
                                                    if (linkspaceset
                                                        .indextreetmp[index]
                                                        .isNotEmpty) {
                                                      return SizedBox(
                                                          height: linkspaceset
                                                                      .indexcnt[
                                                                          index]
                                                                      .placestr ==
                                                                  'board'
                                                              ? (linkspaceset
                                                                      .indextreetmp[
                                                                          index]
                                                                      .length) *
                                                                  200
                                                              : (linkspaceset.indexcnt[index].placestr ==
                                                                      'card'
                                                                  ? (linkspaceset
                                                                          .indextreetmp[
                                                                              index]
                                                                          .length) *
                                                                      130
                                                                  : (linkspaceset
                                                                          .indextreetmp[
                                                                              index]
                                                                          .length) *
                                                                      130),
                                                          child:
                                                              ListView.builder(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    left: 10,
                                                                    right: 10,
                                                                  ),
                                                                  scrollDirection:
                                                                      Axis
                                                                          .vertical,
                                                                  shrinkWrap:
                                                                      true,
                                                                  physics:
                                                                      const ScrollPhysics(),
                                                                  itemCount: linkspaceset
                                                                      .indextreetmp[
                                                                          index]
                                                                      .length,
                                                                  itemBuilder:
                                                                      ((context,
                                                                          index2) {
                                                                    return Column(
                                                                      children: [
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        ContainerDesign(
                                                                            color:
                                                                                Colors.white,
                                                                            child: SizedBox(
                                                                              height: linkspaceset.indexcnt[index].placestr == 'board' ? 150 : (linkspaceset.indexcnt[index].placestr == 'card' ? 80 : 80),
                                                                              child: Column(
                                                                                children: [
                                                                                  InkWell(
                                                                                    onTap: () {
                                                                                      controller.text = linkspaceset.indextreetmp[index][index2].placestr == '' ? '' : linkspaceset.indextreetmp[index][index2].placestr;
                                                                                      linkplacenamechange(context, usercode, linkspaceset.indextreetmp[index][index2].uniqueid, index2, linkspaceset.indextreetmp[index][index2].placestr, changenamenode, controller, linkspaceset.indexcnt[index].placestr);
                                                                                    },
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      children: [
                                                                                        Flexible(
                                                                                          fit: FlexFit.tight,
                                                                                          child: Text(
                                                                                            linkspaceset.indextreetmp[index][index2].placestr == '' ? '제목없음' : linkspaceset.indextreetmp[index][index2].placestr,
                                                                                            textAlign: TextAlign.start,
                                                                                            style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: contentTextsize()),
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                          ),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          width: 10,
                                                                                        ),
                                                                                        const Icon(
                                                                                          Icons.edit,
                                                                                          color: Colors.black45,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            )),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                      ],
                                                                    );
                                                                  })));
                                                    } else {
                                                      return SizedBox(
                                                        height: 100,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Center(
                                                              child: Text(
                                                                linkspaceset
                                                                            .indexcnt[
                                                                                index]
                                                                            .placestr ==
                                                                        'board'
                                                                    ? '보드 공간은 이미지모음, 메모를 클립보드 형식으로 보여주는 공간입니다.'
                                                                    : (linkspaceset.indexcnt[index].placestr ==
                                                                            'card'
                                                                        ? '카드 공간은 링크 및 파일을 바로가기 카드뷰로 보여주는 공간입니다.'
                                                                        : '캘린더 공간은 캘린더 형식만을 보여주는 공간입니다.'),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black45,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        contentTextsize()),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                  }))
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
