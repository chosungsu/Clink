import 'dart:async';
import 'dart:math';
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
import 'package:reorderable_grid/reorderable_grid.dart';
import 'package:status_bar_control/status_bar_control.dart';
import '../DB/Linkpage.dart';
import '../Route/subuiroute.dart';
import '../../../Tool/Getx/memosetting.dart';
import '../../../Tool/Getx/selectcollection.dart';
import '../../../Tool/NoBehavior.dart';
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
  final List<Linksapcepage> listspacepageset = [];
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();
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
              uisetting().showtopbutton,
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
                                                  Icons.more_horiz,
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
    var user, linkname;
    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        final item = linkspaceset.indexcnt.removeAt(oldIndex);
        linkspaceset.indexcnt.insert(newIndex, item);
      });
    }

    return GetBuilder<linkspacesetting>(
        builder: (_) => serverstatus == true
            ? FutureBuilder(
                future: MongoDB.getData(collectionname: 'pinchannelin')
                    .then((value) {
                  listspacepageset.clear();
                  linkspaceset.indexcnt.clear();
                  if (value.isEmpty) {
                  } else {
                    for (int j = 0; j < value.length; j++) {
                      user = value[j]['username'];
                      linkname = value[j]['linkname'];
                      if (user == usercode && linkname == widget.name) {
                        for (int i = 0; i < value[j]['placestr'].length; i++) {
                          linkspaceset.setspacein(linkspaceset.indexcnt.length,
                              value[j]['placestr'][i]);
                          listspacepageset.add(Linksapcepage(
                              index: value[j]['index'][i],
                              placestr: value[j]['placestr'][i]));
                        }
                      }
                    }
                  }
                }),
                builder: (context, snapshot) {
                  return listspacepageset.isEmpty
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
                      : Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              linkspaceset.indexcnt.isEmpty
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
                                  : ReorderableGridView.builder(
                                      physics: const ScrollPhysics(),
                                      itemCount: linkspaceset.indexcnt.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 1,
                                              childAspectRatio: 2 / 1,
                                              crossAxisSpacing: 20,
                                              mainAxisSpacing: 20),
                                      onReorder: _onReorder,
                                      shrinkWrap: true,
                                      itemBuilder: ((context, index) {
                                        return Column(
                                          key: ValueKey(index.toString() +
                                              String.fromCharCodes(
                                                  Iterable.generate(
                                                      5,
                                                      (_) => _chars.codeUnitAt(
                                                          _rnd.nextInt(_chars
                                                              .length))))),
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                                fit: FlexFit.tight,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    print('here');
                                                    linkplacechangeoptions(
                                                        context,
                                                        usercode,
                                                        widget.name,
                                                        index);
                                                  },
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                        shape:
                                                            BoxShape.rectangle,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: Colors
                                                            .grey.shade200,
                                                      ),
                                                      child: SizedBox(
                                                          child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                            Flexible(
                                                                fit: FlexFit
                                                                    .tight,
                                                                child: Text(
                                                                  linkspaceset
                                                                          .indexcnt[
                                                                      index],
                                                                  maxLines: 2,
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
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ))
                                                          ]))),
                                                )),
                                          ],
                                        );
                                      }),
                                    ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )

                          /*GridView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      childAspectRatio: 3 / 1,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20),
                              itemCount: listspacepageset.length,
                              itemBuilder: ((context, index) {
                                return GestureDetector(
                                    onLongPress: () {},
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
                                            child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                              Flexible(
                                                  fit: FlexFit.tight,
                                                  child: Text(
                                                    listspacepageset[index]
                                                        .placestr
                                                        .toString(),
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black45,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            contentTextsize()),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ))
                                            ]))));
                              }))*/
                          );
                },
              )
            : StreamBuilder<QuerySnapshot>(
                stream: firestore.collection('Pinchannelin').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    listspacepageset.clear();
                    final valuespace = snapshot.data!.docs;
                    for (var sp in valuespace) {
                      user = sp.get('username');
                      linkname = sp.get('linkname');
                      if (user == usercode && linkname == widget.name) {
                        for (int i = 0; i < sp.get('placestr').length; i++) {
                          listspacepageset.add(Linksapcepage(
                              index: sp.get('index')[i],
                              placestr: sp.get('placestr')[i]));
                        }
                      }
                    }
                    return listspacepageset.isEmpty
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
                        : Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: GridView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1,
                                        childAspectRatio: 3 / 1,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20),
                                itemCount: listspacepageset.length,
                                itemBuilder: ((context, index) {
                                  return GestureDetector(
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
                                              child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                Flexible(
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      listspacepageset[index]
                                                          .placestr
                                                          .toString(),
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.black45,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              contentTextsize()),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ))
                                              ]))));
                                })));
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
