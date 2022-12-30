import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

settingCalendarHome(int index, doc_name, doc_shares, doc_change,
    BuildContext context, doc, doc_theme, doc_view) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).orientation == Orientation.portrait
            ? Get.width
            : Get.width / 2,
      ),
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
        return Container(
          margin: const EdgeInsets.all(10),
          child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      )),
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SheetPageCC(context, doc_name, doc_shares, doc_change,
                          doc, doc_theme, doc_view),
                    ],
                  ))),
        );
      }).whenComplete(() {});
}

SheetPageCC(BuildContext context, doc_name, doc_shares, doc_change, doc,
    doc_theme, doc_view) {
  return SizedBox(
      child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
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
                          width: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? (MediaQuery.of(context).size.width - 40) * 0.2
                              : (Get.width / 2 - 40) * 0.2,
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
              content(context, doc_name, doc_change, doc_shares, doc, doc_theme,
                  doc_view)
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
          Text('공유자 권한설정',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: secondTitleTextsize()))
        ],
      ));
}

content(BuildContext context, doc_id, doc_change, doc_shares, doc, doc_theme,
    doc_view) {
  DateTime date = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String username = Hive.box('user_info').get(
    'id',
  );
  bool isselected_all = doc_shares == true && doc_change == true ? true : false;
  bool isselected_share = doc_shares == true ? true : false;
  bool isselected_change_set = doc_change == true ? true : false;
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return SizedBox(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 30,
          child: Row(
            children: [
              Flexible(
                  fit: FlexFit.tight,
                  child: SizedBox(
                    height: 30,
                    child: Text('모든 권한',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize())),
                  )),
              Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor: Colors.black,
                  ),
                  child: Checkbox(
                    side: const BorderSide(
                      // POINT
                      color: Colors.black,
                      width: 2.0,
                    ),
                    activeColor: Colors.white,
                    checkColor: Colors.blue,
                    onChanged: (value) {
                      setState(() {
                        isselected_all = value!;
                        if (isselected_all) {
                          isselected_share = true;
                          isselected_change_set = true;
                        } else {
                          isselected_share = false;
                          isselected_change_set = false;
                        }
                        firestore.collection('AppNoticeByUsers').add({
                          'title': '[' + doc + '] 캘린더의 공유자 권한설정이 변경되었습니다.',
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
                          'sharename': doc_shares,
                          'username': username,
                          'read': 'no',
                        });
                      });
                    },
                    value: isselected_all,
                  ))
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 30,
          child: Row(
            children: [
              Flexible(
                  fit: FlexFit.tight,
                  child: SizedBox(
                    height: 30,
                    child: Text('재공유 권한',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize())),
                  )),
              Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor: Colors.black,
                  ),
                  child: Checkbox(
                    side: const BorderSide(
                      // POINT
                      color: Colors.black,
                      width: 2.0,
                    ),
                    activeColor: Colors.white,
                    checkColor: Colors.blue,
                    onChanged: (value) {
                      setState(() {
                        isselected_share = value!;
                        if (isselected_share == false &&
                            isselected_all == true) {
                          isselected_all = false;
                        } else if (isselected_share == true &&
                            isselected_change_set == false) {
                          isselected_all = false;
                        } else if (isselected_share == false &&
                            isselected_change_set == false) {
                          isselected_all = false;
                        } else if (isselected_share == true &&
                            isselected_change_set == true) {
                          isselected_all = true;
                        } else {}
                        firestore.collection('AppNoticeByUsers').add({
                          'title': '[' + doc + '] 캘린더의 공유자 권한설정이 변경되었습니다.',
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
                          'sharename': doc_shares,
                          'username': username,
                          'read': 'no',
                        });
                      });
                    },
                    value: isselected_share,
                  ))
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 30,
          child: Row(
            children: [
              Flexible(
                  fit: FlexFit.tight,
                  child: SizedBox(
                    height: 30,
                    child: Text('카드제목 및 배경색 변경권한',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize())),
                  )),
              Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor: Colors.black,
                  ),
                  child: Checkbox(
                    side: const BorderSide(
                      // POINT
                      color: Colors.black,
                      width: 2.0,
                    ),
                    activeColor: Colors.white,
                    checkColor: Colors.blue,
                    onChanged: (value) {
                      setState(() {
                        isselected_change_set = value!;
                        if (isselected_change_set == false &&
                            isselected_all == true) {
                          isselected_all = false;
                        } else if (isselected_share == true &&
                            isselected_change_set == false) {
                          isselected_all = false;
                        } else if (isselected_share == false &&
                            isselected_change_set == false) {
                          isselected_all = false;
                        } else if (isselected_share == true &&
                            isselected_change_set == true) {
                          isselected_all = true;
                        } else {}
                        firestore.collection('AppNoticeByUsers').add({
                          'title': '[' + doc + '] 캘린더의 공유자 권한설정이 변경되었습니다.',
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
                          'sharename': doc_shares,
                          'username': username,
                          'read': 'no',
                        });
                      });
                    },
                    value: isselected_change_set,
                  ))
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 40,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                primary: Colors.blue,
              ),
              onPressed: () {
                setState(() {
                  firestore.collection('Calendar').doc(doc_id).update({
                    'allowance_share': isselected_share,
                    'allowance_change_set': isselected_change_set,
                  }).whenComplete(() {
                    firestore
                        .collection('ShareHome_update')
                        .where('doc', isEqualTo: doc_id)
                        .get()
                        .then((value) {
                      value.docs.forEach((element) {
                        firestore
                            .collection('ShareHome_update')
                            .doc(doc_id + '-' + element['showingUser'])
                            .update({
                          'allowance_share': isselected_share,
                          'allowance_change_set': isselected_change_set,
                          'themesetting': doc_theme,
                          'viewsetting': doc_view
                        });
                      });
                    }).whenComplete(() {
                      Navigator.pop(context);
                    });
                  });
                });
              },
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: NeumorphicText(
                        '설정완료',
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
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    ));
  });
}
