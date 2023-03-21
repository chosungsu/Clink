import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:clickbyme/Tool/IconBtn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../../../Tool/BGColor.dart';
import '../../../Tool/FlushbarStyle.dart';
import '../../../BACKENDPART/Getx/UserInfo.dart';
import '../../../Tool/NoBehavior.dart';
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
      required this.made,
      required this.allow_share,
      required this.allow_change_set,
      required this.themesetting,
      required this.viewsetting})
      : super(key: key);
  final String nameid;
  final String made;
  final String doc;
  final String when;
  final int type;
  final List share;
  final int color;
  final bool allow_share;
  final bool allow_change_set;
  final int themesetting;
  final int viewsetting;
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
  bool iscontactyes = false;
  List updateid = [];
  List deleteid = [];
  List<bool> isselected = List.filled(10000, false, growable: true);
  List<String> list_sp = [];
  final cal_share_person = Get.put(UserInfo());
  List listselected_sp = [];
  var contacts;
  List usercontactlist = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    cal_share_person.people = Hive.box('user_setting').get('share_cal_person');
    listselected_sp = cal_share_person.people;
    //ContactsPermissionIsGranted();
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
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 20, bottom: 10),
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
                                          Get.back();
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
                                                color: TextColor(),
                                                lightSource:
                                                    LightSource.topLeft),
                                          ),
                                        )),
                                    color: TextColor()),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 70,
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
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
                                            IconBtn(
                                                child: IconButton(
                                                    onPressed: () {
                                                      addgroupmember(
                                                          context,
                                                          searchNode,
                                                          _controller,
                                                          cal_share_person
                                                              .code);
                                                    },
                                                    icon: Container(
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
                                                    )),
                                                color: TextColor()),
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
                            mainAxisSize: MainAxisSize.min,
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
                              Content_real_user(),
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
          '공유자 선택',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: secondTitleTextsize(),
              color: TextColor()),
        ));
  }

  Content_real_user() {
    DateTime date = DateTime.now();
    return StatefulBuilder(builder: (_, StateSetter setState) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder(
              future: firestore
                  .collection('PeopleList')
                  .doc(username)
                  .get()
                  .then((value) {
                list_sp.clear();
                for (int i = 0; i < value.get('friends').length; i++) {
                  list_sp.add(value.get('friends')[i]);
                }
                list_sp.sort(((a, b) {
                  return a.toString().compareTo(b.toString());
                }));
              }),
              builder: (context, snapshot) {
                if (snapshot.hasData || list_sp.isNotEmpty) {
                  return SizedBox(
                      height: MediaQuery.of(context).size.height - 300,
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: list_sp.length,
                          itemBuilder: ((context, index) {
                            return Column(
                              children: [
                                ListTile(
                                    title: Text(
                                      list_sp[index],
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
                                          activeColor: BGColor(),
                                          checkColor: Colors.blue,
                                          side: BorderSide(
                                            // POINT
                                            color: TextColor(),
                                            width: 2.0,
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              isselected[index] = value!;
                                              if (!listselected_sp
                                                  .contains(list_sp[index])) {
                                                if (isselected[index] == true) {
                                                  listselected_sp
                                                      .add(list_sp[index]);
                                                } else {
                                                  listselected_sp.removeWhere(
                                                      (element) =>
                                                          element ==
                                                          list_sp[index]);
                                                }
                                              } else {
                                                if (isselected[index] ==
                                                    false) {
                                                  listselected_sp.removeWhere(
                                                      (element) =>
                                                          element ==
                                                          list_sp[index]);
                                                } else {
                                                  listselected_sp
                                                      .add(list_sp[index]);
                                                }
                                              }
                                            });
                                          },
                                          value: listselected_sp
                                                  .contains(list_sp[index])
                                              ? isselected[list_sp.indexOf(
                                                  list_sp[index])] = true
                                              : isselected[list_sp.indexOf(
                                                  list_sp[index])] = false,
                                        ))),
                              ],
                            );
                          }))
                      /*AlphabetScrollView(
                      list: list_sp.map((e) => AlphaModel(e)).toList(),
                      itemExtent: 50,
                      itemBuilder: (_, k, id) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: 
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
                    ),*/
                      );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return SizedBox(
                      height: MediaQuery.of(context).size.height - 300,
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
                    height: MediaQuery.of(context).size.height - 300,
                    width: MediaQuery.of(context).size.width - 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        NeumorphicText(
                          '친구목록이 비어있습니다.\n 추가하는 방법 : 상단 플러스아이콘 클릭',
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            depth: 3,
                            color: TextColor(),
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
              width: (MediaQuery.of(context).size.width - 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: ButtonColor(),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        setState(() {
                          _controller.clear();
                          Hive.box('user_setting')
                              .put('share_cal_person', listselected_sp);
                          cal_share_person.peoplecalendar();
                          listselected_sp = cal_share_person.people;
                          firestore.collection('AppNoticeByUsers').add({
                            'title':
                                '[' + widget.nameid + '] 캘린더의 공유자명단이 변경되었습니다.',
                            'date': DateFormat('yyyy-MM-dd hh:mm')
                                    .parse(date.toString())
                                    .toString()
                                    .split(' ')[0] +
                                ' ' +
                                DateFormat('yyyy-MM-dd hh:mm')
                                    .parse(date.toString())
                                    .toString()
                                    .split(' ')[1]
                                    .split(':')[0] +
                                ':' +
                                DateFormat('yyyy-MM-dd hh:mm')
                                    .parse(date.toString())
                                    .toString()
                                    .split(' ')[1]
                                    .split(':')[1],
                            'username': username,
                            'sharename': [],
                            'read': 'no',
                          });
                          firestore
                              .collection('CalendarSheetHome_update')
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
                              firestore
                                  .collection('CalendarDataBase')
                                  .where('calname', isEqualTo: widget.doc)
                                  .get()
                                  .then((value) {
                                List valueid = [];
                                final List<bool> _ischecked_alarmslist = [
                                  false,
                                  false
                                ];
                                for (int i = 0; i < value.docs.length; i++) {
                                  valueid.add(value.docs[i].id);
                                }
                                for (int j = 0; j < valueid.length; j++) {
                                  for (int k = 0;
                                      k < listselected_sp.length;
                                      k++) {
                                    firestore
                                        .collection('CalendarDataBase')
                                        .doc(valueid[j])
                                        .collection('AlarmTable')
                                        .doc(listselected_sp[k])
                                        .get()
                                        .then((value) {
                                      if (value.exists) {
                                      } else {
                                        firestore
                                            .collection('CalendarDataBase')
                                            .doc(valueid[j])
                                            .collection('AlarmTable')
                                            .doc(listselected_sp[k])
                                            .set({
                                          'alarmtype': _ischecked_alarmslist,
                                          'alarmhour': '99',
                                          'alarmminute': '99',
                                          'alarmmake': false,
                                          'calcode': valueid[j]
                                        }, SetOptions(merge: true));
                                      }
                                    });
                                  }
                                }
                              });
                            }).whenComplete(() {
                              if (widget.share.isNotEmpty) {
                                firestore
                                    .collection('ShareHome_update')
                                    .where('doc', isEqualTo: widget.doc)
                                    .get()
                                    .then((value) {
                                  deleteid.clear();
                                  value.docs.forEach((element) {
                                    deleteid.add(element.id);
                                  });
                                  for (int i = 0; i < deleteid.length; i++) {
                                    firestore
                                        .collection('ShareHome_update')
                                        .doc(deleteid[i])
                                        .delete();
                                  }
                                }).whenComplete(() {
                                  for (int i = 0;
                                      i < listselected_sp.length;
                                      i++) {
                                    firestore
                                        .collection('ShareHome_update')
                                        .doc(widget.doc +
                                            '-' +
                                            listselected_sp[i])
                                        .get()
                                        .then((value) {
                                      if (value.data() == null) {
                                        firestore
                                            .collection('ShareHome_update')
                                            .doc(widget.doc +
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
                                          'date': widget.when,
                                          'allowance_share': widget.allow_share,
                                          'allowance_change_set':
                                              widget.allow_change_set,
                                          'themesetting': widget.themesetting,
                                          'viewsetting': widget.viewsetting
                                        });
                                      } else {
                                        firestore
                                            .collection('ShareHome_update')
                                            .doc(widget.doc +
                                                '-' +
                                                widget.share[i])
                                            .update({
                                          'calname': widget.nameid,
                                          'madeUser': widget.made,
                                          'type': widget.type,
                                          'color': widget.color,
                                          'share': listselected_sp,
                                          'doc': widget.doc,
                                          'date': widget.when,
                                          'allowance_share': widget.allow_share,
                                          'allowance_change_set':
                                              widget.allow_change_set,
                                          'themesetting': widget.themesetting,
                                          'viewsetting': widget.viewsetting
                                        });
                                      }
                                    });
                                  }
                                  Get.back();
                                  Snack.show(
                                      context: context,
                                      title: '알림',
                                      content: '변경사항이 정상적으로 저장되었습니다.',
                                      snackType: SnackType.info,
                                      behavior: SnackBarBehavior.floating);
                                });
                              } else {
                                for (int i = 0;
                                    i < listselected_sp.length;
                                    i++) {
                                  firestore
                                      .collection('ShareHome_update')
                                      .doc(
                                          widget.doc + '-' + listselected_sp[i])
                                      .get()
                                      .then((value) {
                                    if (value.data() == null) {
                                      firestore
                                          .collection('ShareHome_update')
                                          .doc(widget.doc +
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
                                        'date': widget.when,
                                        'allowance_share': widget.allow_share,
                                        'allowance_change_set':
                                            widget.allow_change_set,
                                        'themesetting': widget.themesetting,
                                        'viewsetting': widget.viewsetting
                                      });
                                    } else {
                                      firestore
                                          .collection('ShareHome_update')
                                          .doc(widget.doc +
                                              '-' +
                                              listselected_sp[i])
                                          .update({
                                        'calname': widget.nameid,
                                        'madeUser': widget.made,
                                        'type': widget.type,
                                        'color': widget.color,
                                        'share': listselected_sp,
                                        'doc': widget.doc,
                                        'date': widget.when,
                                        'allowance_share': widget.allow_share,
                                        'allowance_change_set':
                                            widget.allow_change_set,
                                        'themesetting': widget.themesetting,
                                        'viewsetting': widget.viewsetting
                                      });
                                    }
                                  });
                                }
                                Get.back();
                                Snack.show(
                                    context: context,
                                    title: '알림',
                                    content: '변경사항이 정상적으로 저장되었습니다.',
                                    snackType: SnackType.info,
                                    behavior: SnackBarBehavior.floating);
                              }
                            });
                          });
                        });
                      },
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
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
