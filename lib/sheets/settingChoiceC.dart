import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../Dialogs/destroyBackKey.dart';
import '../Tool/AndroidIOS.dart';
import '../Tool/FlushbarStyle.dart';
import '../Tool/Getx/PeopleAdd.dart';
import '../Tool/Getx/calendarsetting.dart';
import '../Tool/TextSize.dart';

settingChoiceCal(
  BuildContext context,
  TextEditingController controller,
  doc,
  doc_type,
  doc_color,
  doc_name,
  doc_made_user,
  FocusNode searchNode,
  List finallist,
  doc_share,
  String secondname,
) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      )),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              child: GestureDetector(
                  onTap: () {
                    searchNode.unfocus();
                  },
                  child: SizedBox(
                    child: SheetPageC(
                        context,
                        controller,
                        searchNode,
                        doc,
                        doc_type,
                        doc_color,
                        doc_name,
                        doc_made_user,
                        finallist,
                        doc_share,
                        secondname),
                  )),
            ));
      }).whenComplete(() {
    controller.clear();
  });
}

SheetPageC(
    BuildContext context,
    TextEditingController controller,
    FocusNode searchNode,
    doc,
    doc_type,
    doc_color,
    doc_name,
    doc_made_user,
    List finallist,
    doc_share,
    String secondname) {
  return SizedBox(
      child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: (MediaQuery.of(context).size.width - 40) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              title(context),
              const SizedBox(
                height: 20,
              ),
              content(context, searchNode, controller, doc, doc_type, doc_color,
                  doc_name, doc_made_user, finallist, doc_share, secondname),
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}

title(
  BuildContext context,
) {
  return SizedBox(
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('설정',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: secondTitleTextsize()))
        ],
      ));
}

content(
    BuildContext context,
    FocusNode searchNode,
    TextEditingController controller,
    doc,
    doc_type,
    doc_color,
    doc_name,
    doc_made_user,
    List finallist,
    doc_share,
    String secondname) {
  String username = Hive.box('user_info').get(
    'id',
  );
  String usercode = Hive.box('user_setting').get('usercode');
  DateTime date = DateTime.now();
  Color _color = doc_color == null ? Colors.blue : Color(doc_color);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var controll_cals = Get.put(calendarsetting());
  final cal_share_person = Get.put(PeopleAdd());

  List deleteid = [];
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return SizedBox(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 30,
          child: Text('제목 수정하기',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: contentTitleTextsize())),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
            height: 50,
            child: ContainerDesign(
              color: Colors.white,
              child: TextField(
                minLines: 1,
                maxLines: 2,
                controller: controller,
                focusNode: searchNode,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintMaxLines: 2,
                  hintText: '카드 제목을 입력하세요',
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black45),
                  isCollapsed: true,
                ),
              ),
            )),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 30,
          width: MediaQuery.of(context).size.width - 40,
          child: Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: SizedBox(
                  height: 30,
                  child: Text('일정표 카드 배경색',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: contentTitleTextsize())),
                ),
              ),
              SizedBox(
                  height: 30,
                  width: 30,
                  child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('선택',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTitleTextsize())),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              content: Builder(
                                builder: (context) {
                                  return SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
                                      child: SingleChildScrollView(
                                        child: ColorPicker(
                                          pickerColor: _color,
                                          onColorChanged: (Color color) {
                                            setState(() {
                                              _color = color;
                                            });
                                          },
                                        ),
                                      ));
                                },
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text('반영하기'),
                                  onPressed: () {
                                    setState(() {
                                      _color = _color;
                                    });
                                    Hive.box('user_setting').put(
                                        'typecolorcalendar',
                                        _color.value.toInt());
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: _color,
                      )))
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
            height: 50,
            child: Row(
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      primary: Colors.white,
                    ),
                    onPressed: () async {
                      final reloadpage =
                          await Get.dialog(OSDialog(context, '경고', Builder(
                                builder: (context) {
                                  return SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: SingleChildScrollView(
                                      child: Text('정말 이 일정표를 삭제하시겠습니까?',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: contentTextsize(),
                                              color: Colors.blueGrey)),
                                    ),
                                  );
                                },
                              ), pressed2)) ??
                              false;
                      if (reloadpage) {
                        if (Hive.box('user_setting')
                                    .get('noti_calendar_click') ==
                                null ||
                            Hive.box('user_setting')
                                    .get('noti_calendar_click') ==
                                0) {
                          firestore
                              .collection('CalendarSheetHome_update')
                              .doc(doc)
                              .delete();
                          firestore
                              .collection('CalendarDataBase')
                              .where('calname', isEqualTo: doc)
                              .get()
                              .then((value) {
                            value.docs.forEach((element) {
                              deleteid.add(element.id);
                            });
                            for (int i = 0; i < deleteid.length; i++) {
                              firestore
                                  .collection('CalendarDataBase')
                                  .doc(deleteid[i])
                                  .delete();
                            }
                          });
                          firestore
                              .collection('ShareHome_update')
                              .doc(doc + '-' + usercode)
                              .delete();
                        } else {
                          firestore
                              .collection('ShareHome_update')
                              .doc(doc + '-' + usercode)
                              .delete();
                        }
                        Navigator.pop(context);
                        Snack.show(
                            context: context,
                            title: '알림',
                            content: '캘린더의 카드가 삭제되었습니다.',
                            snackType: SnackType.warning,
                            behavior: SnackBarBehavior.floating);
                        firestore.collection('AppNoticeByUsers').add({
                          'title': '[' + doc_name + '] 캘린더의 카드설정이 변경되었습니다.',
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
                          'sharename': doc_share,
                          'username': username,
                          'read': 'no',
                        });
                      }
                    },
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: NeumorphicText(
                              '삭제',
                              style: const NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                depth: 3,
                                color: Colors.red,
                              ),
                              textStyle: NeumorphicTextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: contentTextsize(),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        primary: Colors.blue,
                      ),
                      onPressed: () {
                        setState(() {
                          firestore
                              .collection('CalendarSheetHome_update')
                              .doc(doc)
                              .update({
                            'calname': controller.text,
                            'color': _color.value.toInt(),
                          });
                          firestore
                              .collection('ShareHome_update')
                              .doc(doc + '-' + usercode)
                              .update({
                            'calname': controller.text,
                            'color': _color.value.toInt(),
                          });
                          firestore.collection('AppNoticeByUsers').add({
                            'title': '[' + doc_name + '] 캘린더의 카드설정이 변경되었습니다.',
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
                            'sharename': doc_share,
                            'username': username,
                            'read': 'no',
                          });

                          Navigator.pop(context);
                          Snack.show(
                              context: context,
                              title: '알림',
                              content: '캘린더의 카드가 변경되었습니다.',
                              snackType: SnackType.info,
                              behavior: SnackBarBehavior.floating);
                        });
                      },
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: NeumorphicText(
                                '변경',
                                style: const NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  depth: 3,
                                  color: Colors.white,
                                ),
                                textStyle: NeumorphicTextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize(),
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                )
              ],
            )),
      ],
    ));
  });
}
