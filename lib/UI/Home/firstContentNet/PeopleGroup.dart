import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:clickbyme/sheets/settingRoutineHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../Tool/BGColor.dart';
import '../../../Tool/NoBehavior.dart';
import '../../../Tool/SheetGetx/PeopleAdd.dart';
import '../../../Tool/TextSize.dart';
import '../../../sheets/addgroupmember.dart';

class PeopleGroup extends StatefulWidget {
  const PeopleGroup(
      {Key? key,
      required this.doc,
      required this.when,
      required this.type,
      required this.color,
      required this.nameid,
      required this.share,
      required this.made})
      : super(key: key);
  final String nameid;
  final String made;
  final String doc;
  final String when;
  final int type;
  final List share;
  final int color;
  @override
  State<StatefulWidget> createState() => _PeopleGroupState();
}

class _PeopleGroupState extends State<PeopleGroup> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  var searchNode = FocusNode();
  var _controller = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String username = Hive.box('user_info').get(
    'id',
  );
  List updateid = [];
  List deleteid = [];
  List<bool> isselected = List.filled(10000, false, growable: true);
  List<String> list_sp = [];
  final cal_share_person = Get.put(PeopleAdd());
  List listselected_sp = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    cal_share_person.peoplecalendar();
    listselected_sp = cal_share_person.people;
    ;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: UI(),
    ));
  }

  UI() {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Container(
          decoration: BoxDecoration(
            color: BGColor(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                            fit: FlexFit.tight,
                            child: Row(
                              children: [
                                SizedBox(
                                    width: 50,
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            Get.back();
                                          });
                                        },
                                        child: Container(
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
                                                color: TextColor(),
                                                lightSource:
                                                    LightSource.topLeft),
                                          ),
                                        ))),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 70,
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 10),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: Text(
                                                '',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: TextColor()),
                                              ),
                                            ),
                                            SizedBox(
                                                width: 30,
                                                child: InkWell(
                                                    onTap: () {
                                                      addgroupmember(
                                                          context,
                                                          searchNode,
                                                          _controller);
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 30,
                                                      height: 30,
                                                      child: NeumorphicIcon(
                                                        Icons.add,
                                                        size: 30,
                                                        style: NeumorphicStyle(
                                                            shape:
                                                                NeumorphicShape
                                                                    .convex,
                                                            depth: 2,
                                                            surfaceIntensity:
                                                                0.5,
                                                            color: TextColor(),
                                                            lightSource:
                                                                LightSource
                                                                    .topLeft),
                                                      ),
                                                    ))),
                                          ],
                                        ))),
                              ],
                            )),
                      ],
                    ),
                  )),
              Flexible(
                  fit: FlexFit.tight,
                  child: SizedBox(
                    child: ScrollConfiguration(
                      behavior: NoBehavior(),
                      child: SingleChildScrollView(child:
                          StatefulBuilder(builder: (_, StateSetter setState) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              buildSheetTitle(),
                              const SizedBox(
                                height: 20,
                              ),
                              Content(),
                              const SizedBox(
                                height: 50,
                              )
                            ],
                          ),
                        );
                      })),
                    ),
                  )),
            ],
          )),
    );
  }

  buildSheetTitle() {
    return SizedBox(
        height: 50,
        child: Text(
          '목록',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: contentTitleTextsize(),
              color: TextColor()),
        ));
  }

  Content() {
    return StatefulBuilder(builder: (_, StateSetter setState) {
      return Column(
        children: [
          FutureBuilder(
              future: firestore
                  .collection('PeopleList')
                  .doc(username)
                  .get()
                  .then((value) {
                list_sp.clear();
                value.data()!.forEach((key, value) {
                  list_sp.add(value);
                });
              }),
              builder: (context, snapshot) {
                if (snapshot.hasData || list_sp.isNotEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height - 300,
                    child: AlphabetScrollView(
                      list: list_sp.map((e) => AlphaModel(e)).toList(),
                      itemExtent: 50,
                      itemBuilder: (_, k, id) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: ListTile(
                              title: Text(
                                '$id',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: contentTextsize(),
                                    color: TextColor()),
                              ),
                              leading: Icon(
                                Icons.person,
                                color: TextColor(),
                              ),
                              trailing: Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: TextColor(),
                                  ),
                                  child: Checkbox(
                                    activeColor: TextColor(),
                                    checkColor: Colors.blue,
                                    onChanged: (value) {
                                      setState(() {
                                        isselected[k] = value!;
                                        if (!listselected_sp.contains(id)) {
                                          if (isselected[k] == true) {
                                            listselected_sp.add(id);
                                          } else {
                                            listselected_sp.removeWhere(
                                                (element) => element == id);
                                          }
                                        } else {
                                          if (isselected[k] == false) {
                                            listselected_sp.removeWhere(
                                                (element) => element == id);
                                          } else {
                                            listselected_sp.add(id);
                                          }
                                        }
                                      });
                                    },
                                    value: listselected_sp.contains(id)
                                        ? isselected[list_sp.indexOf(id)] = true
                                        : isselected[list_sp.indexOf(id)] =
                                            false,
                                  ))),
                        );
                      },
                      selectedTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentTitleTextsize(),
                          color: Colors.purpleAccent),
                      unselectedTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentTitleTextsize(),
                          color: TextColor()),
                    ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return SizedBox(
                      height: 230,
                      width: MediaQuery.of(context).size.width - 40,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(
                            color: Colors.black,
                          )
                        ],
                      ));
                }
                return SizedBox(
                    height: 230,
                    width: MediaQuery.of(context).size.width - 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        NeumorphicText(
                          '친구목록이 비어있습니다.\n 추가하는 방법 : 상단 플러스아이콘 클릭',
                          style: const NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            depth: 3,
                            color: Colors.black,
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize(),
                          ),
                        ),
                      ],
                    ));
              }),
          SizedBox(
              height: 50,
              width: (MediaQuery.of(context).size.width - 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: ButtonColor(),
                      ),
                      onPressed: () {
                        setState(() {
                          _controller.clear();
                          Hive.box('user_setting')
                              .put('share_cal_person', listselected_sp);
                          cal_share_person.peoplecalendar();
                          listselected_sp = cal_share_person.people;
                          firestore
                              .collection('CalendarSheetHome')
                              .doc(widget.doc)
                              .update({
                            'calname': _controller.text.isEmpty
                                ? widget.nameid
                                : _controller.text,
                            'madeUser': widget.made,
                            'type': widget.type,
                            'color': widget.color,
                            'share': listselected_sp,
                          }).whenComplete(() {
                            firestore
                                .collection('CalendarDataBase')
                                .where('calname', isEqualTo: widget.doc)
                                .get()
                                .then((value) {
                              updateid.clear();
                              value.docs.forEach((element) {
                                updateid.add(element.id);
                              });
                              for (int i = 0; i < updateid.length; i++) {
                                firestore
                                    .collection('CalendarDataBase')
                                    .doc(updateid[i])
                                    .update({
                                  'Shares': listselected_sp,
                                });
                              }
                            }).whenComplete(() {
                              if (widget.share.isNotEmpty) {
                                /*deleteid.clear();
                                if (listselected_sp.length >
                                    widget.share.length) {
                                  for (int i = 0;
                                      i < listselected_sp.length;
                                      i++) {
                                    deleteid.add(listselected_sp
                                        .where((element) =>
                                            element != widget.share[i])
                                        .toSet());
                                  }
                                } else {
                                  for (int i = 0;
                                      i < widget.share.length;
                                      i++) {
                                    deleteid.add(widget.share
                                        .where((element) =>
                                            element != listselected_sp[i])
                                        .toSet());
                                  }
                                }
                                print(deleteid.length);*/
                                firestore
                                    .collection('ShareHome')
                                    .where('doc', isEqualTo: widget.doc)
                                    .get()
                                    .then((value) {
                                  deleteid.clear();
                                  value.docs.forEach((element) {
                                    deleteid.add(element.id);
                                  });
                                  for (int i = 0; i < updateid.length; i++) {
                                    firestore
                                        .collection('ShareHome')
                                        .doc(deleteid[i])
                                        .delete();
                                  }
                                }).whenComplete(() {
                                  for (int i = 0;
                                      i < listselected_sp.length;
                                      i++) {
                                    firestore
                                        .collection('ShareHome')
                                        .doc(widget.doc +
                                            '-' +
                                            widget.made +
                                            '-' +
                                            listselected_sp[i])
                                        .get()
                                        .then((value) {
                                      if (value.data() == null) {
                                        firestore
                                            .collection('ShareHome')
                                            .doc(widget.doc +
                                                '-' +
                                                widget.made +
                                                '-' +
                                                listselected_sp[i])
                                            .set({
                                          'calname': widget.nameid,
                                          'madeUser': widget.made,
                                          'showingUser': listselected_sp[i],
                                          'type': widget.type,
                                          'color': widget.color,
                                          'share': listselected_sp,
                                          'doc': widget.doc,
                                          'date': widget.when
                                        });
                                      } else {
                                        firestore
                                            .collection('ShareHome')
                                            .doc(widget.doc +
                                                '-' +
                                                widget.made +
                                                '-' +
                                                widget.share[i])
                                            .update({
                                          'calname': widget.nameid,
                                          'madeUser': widget.made,
                                          'type': widget.type,
                                          'color': widget.color,
                                          'share': listselected_sp,
                                          'doc': widget.doc,
                                          'date': widget.when
                                        });
                                      }
                                    });
                                  }
                                  Flushbar(
                                    backgroundColor: Colors.blue.shade400,
                                    titleText: Text('Notice',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: contentTitleTextsize(),
                                          fontWeight: FontWeight.bold,
                                        )),
                                    messageText: Text('변경사항이 정상적으로 저장되었습니다.',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: contentTextsize(),
                                          fontWeight: FontWeight.bold,
                                        )),
                                    icon: const Icon(
                                      Icons.info_outline,
                                      size: 25.0,
                                      color: Colors.white,
                                    ),
                                    duration: const Duration(seconds: 1),
                                    leftBarIndicatorColor: Colors.blue.shade100,
                                  )
                                      .show(context)
                                      .whenComplete(() => Get.back());
                                });
                              } else {
                                for (int i = 0;
                                    i < listselected_sp.length;
                                    i++) {
                                  firestore
                                      .collection('ShareHome')
                                      .doc(widget.doc +
                                          '-' +
                                          widget.made +
                                          '-' +
                                          listselected_sp[i])
                                      .get()
                                      .then((value) {
                                    if (value.data() == null) {
                                      firestore
                                          .collection('ShareHome')
                                          .doc(widget.doc +
                                              '-' +
                                              widget.made +
                                              '-' +
                                              listselected_sp[i])
                                          .set({
                                        'calname': widget.nameid,
                                        'madeUser': widget.made,
                                        'showingUser': listselected_sp[i],
                                        'type': widget.type,
                                        'color': widget.color,
                                        'share': listselected_sp,
                                        'doc': widget.doc,
                                        'date': widget.when
                                      });
                                    } else {
                                      firestore
                                          .collection('ShareHome')
                                          .doc(widget.doc +
                                              '-' +
                                              widget.made +
                                              '-' +
                                              widget.share[i])
                                          .update({
                                        'calname': widget.nameid,
                                        'madeUser': widget.made,
                                        'type': widget.type,
                                        'color': widget.color,
                                        'share': listselected_sp,
                                        'doc': widget.doc,
                                        'date': widget.when
                                      });
                                    }
                                  });
                                }
                                Flushbar(
                                  backgroundColor: Colors.blue.shade400,
                                  titleText: Text('Notice',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: contentTitleTextsize(),
                                        fontWeight: FontWeight.bold,
                                      )),
                                  messageText: Text('변경사항이 정상적으로 저장되었습니다.',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: contentTextsize(),
                                        fontWeight: FontWeight.bold,
                                      )),
                                  icon: const Icon(
                                    Icons.info_outline,
                                    size: 25.0,
                                    color: Colors.white,
                                  ),
                                  duration: const Duration(seconds: 1),
                                  leftBarIndicatorColor: Colors.blue.shade100,
                                ).show(context).whenComplete(() => Get.back());
                              }

                              /*if (listselected_sp.isNotEmpty) {
                                for (int i = 0;
                                    i < widget.share.length;
                                    i++) {
                                  firestore
                                      .collection('ShareHome')
                                      .doc(widget.doc +
                                          '-' +
                                          widget.made +
                                          '-' +
                                          widget.share[i])
                                      .get()
                                      .then((value) {
                                    if (value.data() == null) {
                                      firestore
                                          .collection('ShareHome')
                                          .doc(widget.doc +
                                              '-' +
                                              widget.made +
                                              '-' +
                                              widget.share[i])
                                          .set({
                                        'calname': widget.nameid,
                                        'madeUser': widget.made,
                                        'showingUser': listselected_sp[i],
                                        'type': widget.type,
                                        'color': widget.color,
                                        'share': listselected_sp,
                                        'doc': widget.doc,
                                        'date': widget.when
                                      });
                                    } else {
                                      firestore
                                          .collection('ShareHome')
                                          .doc(widget.doc +
                                              '-' +
                                              widget.made +
                                              '-' +
                                              widget.share[i])
                                          .update({
                                        'calname': widget.nameid,
                                        'madeUser': widget.made,
                                        'showingUser': widget.share[i],
                                        'type': widget.type,
                                        'color': widget.color,
                                        'share': widget.share,
                                        'doc': widget.doc,
                                        'date': widget.when
                                      });
                                    }
                                  }).whenComplete(() {
                                    Flushbar(
                                      backgroundColor: Colors.blue.shade400,
                                      titleText: Text('Notice',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: contentTitleTextsize(),
                                            fontWeight: FontWeight.bold,
                                          )),
                                      messageText: Text('변경사항이 정상적으로 저장되었습니다.',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: contentTextsize(),
                                            fontWeight: FontWeight.bold,
                                          )),
                                      icon: const Icon(
                                        Icons.info_outline,
                                        size: 25.0,
                                        color: Colors.white,
                                      ),
                                      duration: const Duration(seconds: 1),
                                      leftBarIndicatorColor:
                                          Colors.blue.shade100,
                                    )
                                        .show(context)
                                        .whenComplete(() => Get.back());
                                  });
                                }
                              } else {
                                for (int i = 0;
                                    i < listselected_sp.length;
                                    i++) {
                                  firestore
                                      .collection('ShareHome')
                                      .doc(widget.doc +
                                              '-' +
                                              widget.made +
                                              '-' +
                                              widget.share[i])
                                      .delete();
                                }
                              }*/
                            });
                          });
                        });
                      },
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: NeumorphicText(
                                '선택완료',
                                style: const NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  depth: 3,
                                  color: Colors.white,
                                ),
                                textStyle: NeumorphicTextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTitleTextsize(),
                                ),
                              ),
                            )
                          ],
                        ),
                      ))
                ],
              ))
        ],
      );
    });
  }
}
