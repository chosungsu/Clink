// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../../DB/SpaceContent.dart';
import '../../../Sub/SecureAuth.dart';
import '../../../Tool/BGColor.dart';
import '../../../Tool/ContainerDesign.dart';
import '../../../Tool/Getx/PeopleAdd.dart';
import '../../../Tool/Getx/calendarsetting.dart';
import '../../../Tool/TextSize.dart';
import '../secondContentNet/ClickShowEachCalendar.dart';
import '../secondContentNet/ClickShowEachNote.dart';
import 'CreateCalandmemo.dart';

ViewSet(List defaulthomeviewlist, List userviewlist, bool isresponsive,
    String secondname) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String name = Hive.box('user_info').get('id');
  DateTime Date = DateTime.now();
  final peopleadd = Get.put(PeopleAdd());

  List<Widget> list_all = [];
  List<Widget> children_cal1 = [];
  List<Widget> children_cal2 = [];
  List<Widget> children_memo1 = [];
  List<Widget> children_memo2 = [];
  return GetBuilder<PeopleAdd>(
      builder: (_) => ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: peopleadd.defaulthomeviewlist.length,
          itemBuilder: (context, index) {
            return peopleadd.defaulthomeviewlist[index].toString() == '오늘의 일정'
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('오늘의 일정',
                          style: TextStyle(
                              color: TextColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: contentTitleTextsize())),
                      const SizedBox(
                        height: 20,
                      ),
                      stream1(secondname, isresponsive),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                : (peopleadd.defaulthomeviewlist[index].toString() ==
                        '공유된 오늘의 일정'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('공유된 오늘의 일정',
                              style: TextStyle(
                                  color: TextColor(),
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTitleTextsize())),
                          const SizedBox(
                            height: 20,
                          ),
                          stream2(secondname, isresponsive),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      )
                    : (peopleadd.defaulthomeviewlist[index].toString() ==
                            '홈뷰에 저장된 메모'
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('홈뷰에 저장된 메모',
                                  style: TextStyle(
                                      color: TextColor(),
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTitleTextsize())),
                              const SizedBox(
                                height: 20,
                              ),
                              stream3(secondname, isresponsive),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('오늘 수정 및 생성된 메모',
                                  style: TextStyle(
                                      color: TextColor(),
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTitleTextsize())),
                              const SizedBox(
                                height: 20,
                              ),
                              stream4(secondname, isresponsive),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          )));
          }));
}

FutureBuilder<QuerySnapshot<Object?>> stream1(
  String secondname,
  bool isresponsive,
) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String name = Hive.box('user_info').get('id');
  DateTime Date = DateTime.now();
  final peopleadd = Get.put(PeopleAdd());
  List contentmy = [];

  List<Widget> list_all = [];
  List<Widget> children_cal1 = [];
  firestore
      .collection('CalendarDataBase')
      .where('OriginalUser', isEqualTo: peopleadd.secondname)
      .where('Date',
          isEqualTo: Date.toString().split('-')[0] +
              '-' +
              Date.toString().split('-')[1] +
              '-' +
              Date.toString().split('-')[2].substring(0, 2) +
              '일')
      .orderBy('Timestart')
      .get()
      .then((value) {
    contentmy.clear();
    var timsestart, timefinish, codes, todo, share, summary;
    List cname = [];
    final valuespace = value.docs;
    for (var sp in valuespace) {
      todo = sp.get('Daytodo');
      timsestart = sp.get('Timestart');
      timefinish = sp.get('Timefinish');
      codes = sp.get('calname');
      share = sp.get('Shares');
      summary = sp.get('summary');
      firestore.collection('CalendarSheetHome').doc(codes).get().then((value) {
        value.data()!.forEach((key, value) {
          //print(key + '-' + value);
          if (key == 'calname') {
            cname.add(value);
          }
        });
      });
      contentmy.add(SpaceContent(
          title: todo,
          date: timsestart + '-' + timefinish,
          cname: cname,
          finishdate: timefinish,
          startdate: timsestart,
          share: share,
          code: codes,
          summary: summary));
    }
  });
  return FutureBuilder<QuerySnapshot>(
    future: firestore
        .collection('CalendarDataBase')
        .where('OriginalUser', isEqualTo: secondname)
        .where('Date',
            isEqualTo: Date.toString().split('-')[0] +
                '-' +
                Date.toString().split('-')[1] +
                '-' +
                Date.toString().split('-')[2].substring(0, 2) +
                '일')
        .orderBy('Timestart')
        .get(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        children_cal1 = <Widget>[
          ContainerDesign(
              child: snapshot.data!.docs.isEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: isresponsive == true ? 300 : 50,
                          child: Center(
                            child: NeumorphicText(
                              '보여드릴 오늘의 일정이 없습니다.',
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                depth: 3,
                                color: TextColor(),
                              ),
                              textStyle: NeumorphicTextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: contentTextsize(),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: contentmy.length,
                      itemBuilder: (context, index) {
                        var updateidalarm = '';
                        List<bool> alarmtypes = [];
                        bool isChecked_pushalarm = false;
                        firestore
                            .collectionGroup('AlarmTable')
                            .get()
                            .then((value) {
                          if (value.docs.isNotEmpty) {
                            for (int i = 0; i < value.docs.length; i++) {
                              if (value.docs[i].id == peopleadd.secondname) {
                                if (value.docs[i].data()['calcode'] ==
                                    snapshot.data!.docs[index].id) {
                                  updateidalarm = value.docs[i].id;
                                  for (int j = 0;
                                      j <
                                          value.docs[i]
                                              .data()['alarmtype']
                                              .length;
                                      j++) {
                                    alarmtypes.add(
                                        value.docs[i].data()['alarmtype'][j]);
                                  }
                                  Hive.box('user_setting').put(
                                      'alarm_cal_hour_${snapshot.data!.docs[index].id}_${peopleadd.secondname}',
                                      value.docs[i]
                                          .data()['alarmhour']
                                          .toString());
                                  Hive.box('user_setting').put(
                                      'alarm_cal_minute_${snapshot.data!.docs[index].id}_${peopleadd.secondname}',
                                      value.docs[i]
                                          .data()['alarmminute']
                                          .toString());
                                  calendarsetting().hour1 =
                                      Hive.box('user_setting').get(
                                          'alarm_cal_hour_${snapshot.data!.docs[index].id}_${peopleadd.secondname}');
                                  calendarsetting().minute1 =
                                      Hive.box('user_setting').get(
                                          'alarm_cal_minute_${snapshot.data!.docs[index].id}_${peopleadd.secondname}');
                                  isChecked_pushalarm =
                                      value.docs[i].data()['alarmmake'];
                                }
                              }
                            }
                          }
                        });
                        return Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                                onTap: () {},
                                child: StatefulBuilder(
                                    builder: ((context, setState) {
                                  return ListTile(
                                    onTap: () {
                                      //수정 및 삭제 시트 띄우기

                                      Get.to(
                                          () => ClickShowEachCalendar(
                                                start:
                                                    contentmy[index].startdate,
                                                finish:
                                                    contentmy[index].finishdate,
                                                calinfo: contentmy[index].title,
                                                date: Date,
                                                share: contentmy[index].share,
                                                calname: contentmy[index]
                                                    .cname[index]
                                                    .toString(),
                                                code: contentmy[index].code,
                                                summary:
                                                    contentmy[index].summary,
                                                isfromwhere: 'home',
                                                id: snapshot
                                                    .data!.docs[index].id,
                                                alarmtypes: alarmtypes,
                                                alarmmake: isChecked_pushalarm,
                                              ),
                                          transition: Transition.downToUp);
                                    },
                                    horizontalTitleGap: 10,
                                    dense: true,
                                    leading: Icon(
                                      Icons.calendar_month,
                                      color: TextColor(),
                                    ),
                                    trailing: int.parse(contentmy[index]
                                                .startdate
                                                .toString()
                                                .split(':')[0])
                                            .isGreaterThan(Date.hour)
                                        ? (isChecked_pushalarm
                                            ? Icon(
                                                Icons.alarm,
                                                color: TextColor(),
                                              )
                                            : Icon(
                                                Icons.not_started,
                                                color: TextColor(),
                                              ))
                                        : (int.parse(contentmy[index]
                                                    .startdate
                                                    .toString()
                                                    .split(':')[1])
                                                .isGreaterThan(Date.minute)
                                            ? (isChecked_pushalarm
                                                ? Icon(
                                                    Icons.alarm,
                                                    color: TextColor(),
                                                  )
                                                : Icon(
                                                    Icons.not_started,
                                                    color: TextColor(),
                                                  ))
                                            : Icon(
                                                Icons.done,
                                                color: TextColor(),
                                              )),
                                    subtitle: Text(contentmy[index].title,
                                        style: TextStyle(
                                            color: TextColor(),
                                            fontWeight: FontWeight.bold,
                                            fontSize: contentTextsize())),
                                    title: Text(contentmy[index].date,
                                        style: TextStyle(
                                          color: TextColor(),
                                          fontWeight: FontWeight.bold,
                                        )),
                                  );
                                }))),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        );
                      }),
              color: BGColor())
        ];
      } else if (snapshot.connectionState == ConnectionState.waiting) {
        children_cal1 = <Widget>[
          ContainerDesign(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: isresponsive == true ? 300 : 50,
                      child: const Center(child: CircularProgressIndicator()))
                ],
              ),
              color: BGColor())
        ];
      } else {
        children_cal1 = <Widget>[
          ContainerDesign(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: isresponsive == true ? 300 : 50,
                    child: Center(
                      child: NeumorphicText(
                        '보여드릴 오늘의 일정이 없습니다.',
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          depth: 3,
                          color: TextColor(),
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: contentTextsize(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              color: BGColor())
        ];
      }
      return Column(children: children_cal1);
    },
  );
}

FutureBuilder<QuerySnapshot<Object?>> stream2(
  String secondname,
  bool isresponsive,
) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String name = Hive.box('user_info').get('id');
  DateTime Date = DateTime.now();
  final peopleadd = Get.put(PeopleAdd());
  List contentshare = [];
  List<Widget> list_all = [];
  List<Widget> children_cal2 = [];
  firestore
      .collection('CalendarDataBase')
      .where('Date',
          isEqualTo: Date.toString().split('-')[0] +
              '-' +
              Date.toString().split('-')[1] +
              '-' +
              Date.toString().split('-')[2].substring(0, 2) +
              '일')
      .orderBy('Timestart')
      .get()
      .then(((value) {
    List nameList = [];
    contentshare.clear();
    var timsestart, timefinish, codes, todo, summary;
    List cname = [];
    final valuespace = value.docs;
    for (var sp in valuespace) {
      nameList = sp.get('Shares');
      todo = sp.get('Daytodo');
      timsestart = sp.get('Timestart');
      timefinish = sp.get('Timefinish');
      codes = sp.get('calname');
      summary = sp.get('summary');
      firestore.collection('CalendarSheetHome').doc(codes).get().then((value) {
        value.data()!.forEach((key, value) {
          //print(key + '-' + value);
          if (key == 'calname') {
            cname.add(value);
          }
        });
      });
      for (int i = 0; i < nameList.length; i++) {
        if (nameList[i].contains(secondname)) {
          contentshare.add(SpaceContent(
              title: todo,
              date: timsestart + '-' + timefinish,
              cname: cname,
              finishdate: timefinish,
              startdate: timsestart,
              share: nameList,
              code: codes,
              summary: summary));
        }
      }
    }
  }));
  return FutureBuilder<QuerySnapshot>(
    future: firestore
        .collection('CalendarDataBase')
        .where('Date',
            isEqualTo: Date.toString().split('-')[0] +
                '-' +
                Date.toString().split('-')[1] +
                '-' +
                Date.toString().split('-')[2].substring(0, 2) +
                '일')
        .orderBy('Timestart')
        .get(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        children_cal2 = <Widget>[
          ContainerDesign(
              child: contentshare.isEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: isresponsive == true ? 300 : 50,
                            child: Center(
                              child: NeumorphicText(
                                '보여드릴 공유된 일정이 없습니다.',
                                style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  depth: 3,
                                  color: TextColor(),
                                ),
                                textStyle: NeumorphicTextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: contentTextsize(),
                                ),
                              ),
                            ))
                      ],
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: contentshare.length,
                      itemBuilder: (context, index) {
                        var updateidalarm = '';
                        List<bool> alarmtypes = [];
                        bool isChecked_pushalarm = false;
                        firestore
                            .collectionGroup('AlarmTable')
                            .get()
                            .then((value) {
                          if (value.docs.isNotEmpty) {
                            for (int i = 0; i < value.docs.length; i++) {
                              if (value.docs[i].id == peopleadd.secondname) {
                                if (value.docs[i].data()['calcode'] ==
                                    snapshot.data!.docs[index].id) {
                                  updateidalarm = value.docs[i].id;
                                  for (int j = 0;
                                      j <
                                          value.docs[i]
                                              .data()['alarmtype']
                                              .length;
                                      j++) {
                                    alarmtypes.add(
                                        value.docs[i].data()['alarmtype'][j]);
                                  }
                                  Hive.box('user_setting').put(
                                      'alarm_cal_hour_${snapshot.data!.docs[index].id}_${peopleadd.secondname}',
                                      value.docs[i]
                                          .data()['alarmhour']
                                          .toString());
                                  Hive.box('user_setting').put(
                                      'alarm_cal_minute_${snapshot.data!.docs[index].id}_${peopleadd.secondname}',
                                      value.docs[i]
                                          .data()['alarmminute']
                                          .toString());
                                  calendarsetting().hour1 =
                                      Hive.box('user_setting').get(
                                          'alarm_cal_hour_${snapshot.data!.docs[index].id}_${peopleadd.secondname}');
                                  calendarsetting().minute1 =
                                      Hive.box('user_setting').get(
                                          'alarm_cal_minute_${snapshot.data!.docs[index].id}_${peopleadd.secondname}');
                                  isChecked_pushalarm =
                                      value.docs[i].data()['alarmmake'];
                                }
                              }
                            }
                          }
                        });
                        return Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                                onTap: () {},
                                child: StatefulBuilder(
                                    builder: ((context, setState) {
                                  return ListTile(
                                    onTap: () async {
                                      //수정 및 삭제 시트 띄우기

                                      Get.to(
                                          () => ClickShowEachCalendar(
                                                start: contentshare[index]
                                                    .startdate,
                                                finish: contentshare[index]
                                                    .finishdate,
                                                calinfo:
                                                    contentshare[index].title,
                                                date: Date,
                                                share:
                                                    contentshare[index].share,
                                                calname: contentshare[index]
                                                    .cname[index]
                                                    .toString(),
                                                code: contentshare[index].code,
                                                summary:
                                                    contentshare[index].summary,
                                                isfromwhere: 'home',
                                                id: snapshot
                                                    .data!.docs[index].id,
                                                alarmtypes: alarmtypes,
                                                alarmmake: isChecked_pushalarm,
                                              ),
                                          transition: Transition.downToUp);
                                    },
                                    horizontalTitleGap: 10,
                                    dense: true,
                                    leading: Icon(
                                      Icons.calendar_month,
                                      color: TextColor(),
                                    ),
                                    trailing: int.parse(contentshare[index]
                                                .startdate
                                                .toString()
                                                .split(':')[0])
                                            .isGreaterThan(Date.hour)
                                        ? (isChecked_pushalarm
                                            ? Icon(
                                                Icons.alarm,
                                                color: TextColor(),
                                              )
                                            : Icon(
                                                Icons.not_started,
                                                color: TextColor(),
                                              ))
                                        : (int.parse(contentshare[index]
                                                    .startdate
                                                    .toString()
                                                    .split(':')[1])
                                                .isGreaterThan(Date.minute)
                                            ? (isChecked_pushalarm
                                                ? Icon(
                                                    Icons.alarm,
                                                    color: TextColor(),
                                                  )
                                                : Icon(
                                                    Icons.not_started,
                                                    color: TextColor(),
                                                  ))
                                            : Icon(
                                                Icons.done,
                                                color: TextColor(),
                                              )),
                                    subtitle: Text(contentshare[index].title,
                                        style: TextStyle(
                                            color: TextColor(),
                                            fontWeight: FontWeight.bold,
                                            fontSize: contentTextsize())),
                                    title: Text(contentshare[index].date,
                                        style: TextStyle(
                                          color: TextColor(),
                                          fontWeight: FontWeight.bold,
                                        )),
                                  );
                                }))),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        );
                      }),
              color: BGColor())
        ];
      } else if (snapshot.connectionState == ConnectionState.waiting) {
        children_cal2 = <Widget>[
          ContainerDesign(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: isresponsive == true ? 300 : 50,
                      child: const Center(child: CircularProgressIndicator()))
                ],
              ),
              color: BGColor())
        ];
      } else {
        children_cal2 = <Widget>[
          ContainerDesign(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: isresponsive == true ? 300 : 50,
                    child: Center(
                      child: NeumorphicText(
                        '보여드릴 공유된 일정이 없습니다.',
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          depth: 3,
                          color: TextColor(),
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: contentTextsize(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              color: BGColor())
        ];
      }
      return Column(
        children: children_cal2,
      );
    },
  );
}

FutureBuilder<QuerySnapshot<Object?>> stream3(
  String secondname,
  bool isresponsive,
) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String name = Hive.box('user_info').get('id');
  DateTime Date = DateTime.now();
  final peopleadd = Get.put(PeopleAdd());
  List memosavelist = [];

  List<Widget> list_all = [];
  List<Widget> children_memo1 = [];
  firestore
      .collection('MemoDataBase')
      .where('OriginalUser', isEqualTo: name)
      .where('homesave', isEqualTo: true)
      .get()
      .then(((value) {
    memosavelist.clear();
    List memoindex = [];
    List photos = [];
    List memolist = [];

    var security,
        Collection,
        color,
        colorfont,
        memoTitle,
        EditDate,
        securewith,
        pinnumber,
        date,
        id;
    final valuespace = value.docs;
    for (var sp in valuespace) {
      id = sp.id;
      security = sp.get('security');
      Collection = sp.get('Collection');
      color = sp.get('color');
      colorfont = sp.get('colorfont');
      memoTitle = sp.get('memoTitle');
      EditDate = sp.get('EditDate');
      securewith = sp.get('securewith');
      pinnumber = sp.get('pinnumber');
      date = sp.get('Date');
      memoindex = sp.get('memoindex');
      photos = sp.get('photoUrl');
      memolist = sp.get('memolist');

      memosavelist.add(MemoContent(
          security: security,
          Date: date,
          Collection: Collection ?? '',
          color: color,
          colorfont: colorfont,
          memoTitle: memoTitle,
          EditDate: EditDate,
          securewith: securewith,
          pinnumber: pinnumber,
          memoindex: memoindex,
          photoUrl: photos,
          memolist: memolist,
          id: id));
    }
  }));
  return FutureBuilder<QuerySnapshot>(
    future: firestore
        .collection('MemoDataBase')
        .where('OriginalUser', isEqualTo: name)
        .where('homesave', isEqualTo: true)
        .get(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        children_memo1 = <Widget>[
          ContainerDesign(
              child: memosavelist.isEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: isresponsive == true ? 300 : 50,
                            child: Center(
                              child: NeumorphicText(
                                '홈 내보내기 설정된 메모는 없습니다.',
                                style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  depth: 3,
                                  color: TextColor(),
                                ),
                                textStyle: NeumorphicTextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: contentTextsize(),
                                ),
                              ),
                            ))
                      ],
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: memosavelist.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                                onTap: () {},
                                child: StatefulBuilder(
                                    builder: ((context, setState) {
                                  return ListTile(
                                    onTap: () async {
                                      if (memosavelist[index].security ==
                                              false ||
                                          memosavelist[index].securewith ==
                                              999) {
                                        Get.to(
                                            () => ClickShowEachNote(
                                                  date:
                                                      memosavelist[index].Date,
                                                  doc: memosavelist[index].id,
                                                  doccollection:
                                                      memosavelist[index]
                                                              .Collection ??
                                                          '',
                                                  doccolor:
                                                      memosavelist[index].color,
                                                  doccolorfont:
                                                      memosavelist[index]
                                                          .colorfont,
                                                  docindex: memosavelist[index]
                                                          .memoindex ??
                                                      [],
                                                  docname: memosavelist[index]
                                                      .memoTitle,
                                                  docsummary:
                                                      memosavelist[index]
                                                              .memolist ??
                                                          [],
                                                  editdate: memosavelist[index]
                                                      .EditDate,
                                                  image: memosavelist[index]
                                                      .photoUrl,
                                                  securewith:
                                                      memosavelist[index]
                                                              .securewith ??
                                                          999,
                                                  isfromwhere: 'home',
                                                ),
                                            transition: Transition.downToUp);
                                      } else if (memosavelist[index]
                                              .securewith ==
                                          0) {
                                        if (GetPlatform.isAndroid) {
                                          final reloadpage = await Get.to(
                                              () => SecureAuth(
                                                  string: '지문',
                                                  id: memosavelist[index].id,
                                                  doc_secret_bool:
                                                      memosavelist[index]
                                                          .security,
                                                  doc_pin_number:
                                                      memosavelist[index]
                                                          .pinnumber,
                                                  unlock: true),
                                              transition: Transition.downToUp);
                                          if (reloadpage != null &&
                                              reloadpage == true) {
                                            Get.to(
                                                () => ClickShowEachNote(
                                                    date: memosavelist[index]
                                                        .Date,
                                                    doc: memosavelist[index].id,
                                                    doccollection:
                                                        memosavelist[index]
                                                                .Collection ??
                                                            '',
                                                    doccolor: memosavelist[index]
                                                        .color,
                                                    doccolorfont:
                                                        memosavelist[index]
                                                            .colorfont,
                                                    docindex: memosavelist[index]
                                                            .memoindex ??
                                                        [],
                                                    docname: memosavelist[index]
                                                        .memoTitle,
                                                    docsummary: memosavelist[index]
                                                            .memolist ??
                                                        [],
                                                    editdate: memosavelist[index]
                                                        .EditDate,
                                                    image: memosavelist[index]
                                                        .photoUrl,
                                                    securewith:
                                                        memosavelist[index].securewith ?? 999,
                                                    isfromwhere: 'home'),
                                                transition: Transition.downToUp);
                                          }
                                        } else {
                                          final reloadpage = await Get.to(
                                              () => SecureAuth(
                                                  string: '얼굴',
                                                  id: memosavelist[index].id,
                                                  doc_secret_bool:
                                                      memosavelist[index]
                                                          .security,
                                                  doc_pin_number:
                                                      memosavelist[index]
                                                          .pinnumber,
                                                  unlock: true),
                                              transition: Transition.downToUp);
                                          if (reloadpage != null &&
                                              reloadpage == true) {
                                            Get.to(
                                                () => ClickShowEachNote(
                                                    date: memosavelist[index]
                                                        .Date,
                                                    doc: memosavelist[index].id,
                                                    doccollection:
                                                        memosavelist[index]
                                                                .Collection ??
                                                            '',
                                                    doccolor: memosavelist[index]
                                                        .color,
                                                    doccolorfont:
                                                        memosavelist[index]
                                                            .colorfont,
                                                    docindex: memosavelist[index]
                                                            .memoindex ??
                                                        [],
                                                    docname: memosavelist[index]
                                                        .memoTitle,
                                                    docsummary: memosavelist[index]
                                                            .memolist ??
                                                        [],
                                                    editdate: memosavelist[index]
                                                        .EditDate,
                                                    image: memosavelist[index]
                                                        .photoUrl,
                                                    securewith:
                                                        memosavelist[index].securewith ?? 999,
                                                    isfromwhere: 'home'),
                                                transition: Transition.downToUp);
                                          }
                                        }
                                      } else {
                                        final reloadpage = await Get.to(
                                            () => SecureAuth(
                                                string: '핀',
                                                id: memosavelist[index].id,
                                                doc_secret_bool:
                                                    memosavelist[index]
                                                        .security,
                                                doc_pin_number:
                                                    memosavelist[index]
                                                        .pinnumber,
                                                unlock: true),
                                            transition: Transition.downToUp);
                                        if (reloadpage != null &&
                                            reloadpage == true) {
                                          Get.to(
                                              () => ClickShowEachNote(
                                                  date:
                                                      memosavelist[index].Date,
                                                  doc: memosavelist[index].id,
                                                  doccollection:
                                                      memosavelist[index]
                                                              .Collection ??
                                                          '',
                                                  doccolor:
                                                      memosavelist[index].color,
                                                  doccolorfont:
                                                      memosavelist[index]
                                                          .colorfont,
                                                  docindex: memosavelist[index]
                                                          .memoindex ??
                                                      [],
                                                  docname: memosavelist[index]
                                                      .memoTitle,
                                                  docsummary: memosavelist[index]
                                                          .memolist ??
                                                      [],
                                                  editdate: memosavelist[index]
                                                      .EditDate,
                                                  image: memosavelist[index]
                                                      .photoUrl,
                                                  securewith:
                                                      memosavelist[index]
                                                              .securewith ??
                                                          999,
                                                  isfromwhere: 'home'),
                                              transition: Transition.downToUp);
                                        }
                                      }
                                    },
                                    horizontalTitleGap: 10,
                                    dense: true,
                                    leading: Icon(
                                      Icons.description,
                                      color: TextColor(),
                                    ),
                                    trailing:
                                        memosavelist[index].security == true
                                            ? Icon(
                                                Icons.lock,
                                                color: TextColor(),
                                              )
                                            : null,
                                    title: Text(memosavelist[index].memoTitle,
                                        style: TextStyle(
                                            color: TextColor(),
                                            fontWeight: FontWeight.bold,
                                            fontSize: contentTextsize())),
                                  );
                                }))),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        );
                      }),
              color: BGColor())
        ];
      } else if (snapshot.connectionState == ConnectionState.waiting) {
        children_memo1 = <Widget>[
          ContainerDesign(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: isresponsive == true ? 300 : 50,
                      child: const Center(child: CircularProgressIndicator()))
                ],
              ),
              color: BGColor())
        ];
      } else {
        children_memo1 = <Widget>[
          ContainerDesign(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: isresponsive == true ? 300 : 50,
                      child: Center(
                        child: NeumorphicText(
                          '홈 내보내기 설정된 메모는 없습니다.',
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            depth: 3,
                            color: TextColor(),
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: contentTextsize(),
                          ),
                        ),
                      ))
                ],
              ),
              color: BGColor())
        ];
      }
      return Column(children: children_memo1);
    },
  );
}

FutureBuilder<QuerySnapshot<Object?>> stream4(
  String secondname,
  bool isresponsive,
) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String name = Hive.box('user_info').get('id');
  DateTime Date = DateTime.now();
  final peopleadd = Get.put(PeopleAdd());
  List memotodaylist = [];
  List<Widget> list_all = [];
  List<Widget> children_memo2 = [];
  firestore
      .collection('MemoDataBase')
      .where('OriginalUser', isEqualTo: name)
      .where('homesave', isEqualTo: true)
      .get()
      .then(((value) {
    memotodaylist.clear();
    List memoindex = [];
    List photos = [];
    List memolist = [];

    var security,
        Collection,
        color,
        colorfont,
        memoTitle,
        EditDate,
        securewith,
        pinnumber,
        date,
        id;
    final valuespace = value.docs;
    for (var sp in valuespace) {
      id = sp.id;
      security = sp.get('security');
      Collection = sp.get('Collection');
      color = sp.get('color');
      colorfont = sp.get('colorfont');
      memoTitle = sp.get('memoTitle');
      EditDate = sp.get('EditDate');
      securewith = sp.get('securewith');
      pinnumber = sp.get('pinnumber');
      date = sp.get('Date');
      memoindex = sp.get('memoindex');
      photos = sp.get('photoUrl');
      memolist = sp.get('memolist');

      memotodaylist.add(MemoContent(
          security: security,
          Date: date,
          Collection: Collection ?? '',
          color: color,
          colorfont: colorfont,
          memoTitle: memoTitle,
          EditDate: EditDate,
          securewith: securewith,
          pinnumber: pinnumber,
          memoindex: memoindex,
          photoUrl: photos,
          memolist: memolist,
          id: id));
    }
  }));
  return FutureBuilder<QuerySnapshot>(
    future: firestore
        .collection('MemoDataBase')
        .where('OriginalUser', isEqualTo: name)
        .where('homesave', isEqualTo: true)
        .get(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        children_memo2 = <Widget>[
          ContainerDesign(
              child: memotodaylist.isEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: isresponsive == true ? 300 : 50,
                            child: Center(
                              child: NeumorphicText(
                                '오늘 변경사항이 없습니다.',
                                style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  depth: 3,
                                  color: TextColor(),
                                ),
                                textStyle: NeumorphicTextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: contentTextsize(),
                                ),
                              ),
                            ))
                      ],
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: memotodaylist.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: ListTile(
                                onTap: () async {
                                  if (memotodaylist[index].security == false ||
                                      memotodaylist[index].securewith == 999) {
                                    Get.to(
                                        () => ClickShowEachNote(
                                            date: memotodaylist[index].Date,
                                            doc: memotodaylist[index].id,
                                            doccollection: memotodaylist[index]
                                                    .Collection ??
                                                '',
                                            doccolor:
                                                memotodaylist[index].color,
                                            doccolorfont:
                                                memotodaylist[index].colorfont,
                                            docindex: memotodaylist[index]
                                                    .memoindex ??
                                                [],
                                            docname:
                                                memotodaylist[index].memoTitle,
                                            docsummary:
                                                memotodaylist[index].memolist ??
                                                    [],
                                            editdate:
                                                memotodaylist[index].EditDate,
                                            image:
                                                memotodaylist[index].photoUrl,
                                            securewith: memotodaylist[index]
                                                    .securewith ??
                                                999,
                                            isfromwhere: 'home'),
                                        transition: Transition.downToUp);
                                  } else if (memotodaylist[index].securewith ==
                                      0) {
                                    if (GetPlatform.isAndroid) {
                                      final reloadpage = await Get.to(
                                          () => SecureAuth(
                                              string: '지문',
                                              id: memotodaylist[index].id,
                                              doc_secret_bool:
                                                  memotodaylist[index].security,
                                              doc_pin_number:
                                                  memotodaylist[index]
                                                      .pinnumber,
                                              unlock: true),
                                          transition: Transition.downToUp);
                                      if (reloadpage != null &&
                                          reloadpage == true) {
                                        Get.to(
                                            () => ClickShowEachNote(
                                                date: memotodaylist[index].Date,
                                                doc: memotodaylist[index].id,
                                                doccollection:
                                                    memotodaylist[index]
                                                            .Collection ??
                                                        '',
                                                doccolor:
                                                    memotodaylist[index].color,
                                                doccolorfont: memotodaylist[index]
                                                    .colorfont,
                                                docindex: memotodaylist[index]
                                                        .memoindex ??
                                                    [],
                                                docname: memotodaylist[index]
                                                    .memoTitle,
                                                docsummary: memotodaylist[index]
                                                        .memolist ??
                                                    [],
                                                editdate: memotodaylist[index]
                                                    .EditDate,
                                                image: memotodaylist[index]
                                                    .photoUrl,
                                                securewith: memotodaylist[index]
                                                        .securewith ??
                                                    999,
                                                isfromwhere: 'home'),
                                            transition: Transition.downToUp);
                                      }
                                    } else {
                                      final reloadpage = await Get.to(
                                          () => SecureAuth(
                                              string: '얼굴',
                                              id: memotodaylist[index].id,
                                              doc_secret_bool:
                                                  memotodaylist[index].security,
                                              doc_pin_number:
                                                  memotodaylist[index]
                                                      .pinnumber,
                                              unlock: true),
                                          transition: Transition.downToUp);
                                      if (reloadpage != null &&
                                          reloadpage == true) {
                                        Get.to(
                                            () => ClickShowEachNote(
                                                date: memotodaylist[index].Date,
                                                doc: memotodaylist[index].id,
                                                doccollection:
                                                    memotodaylist[index]
                                                            .Collection ??
                                                        '',
                                                doccolor:
                                                    memotodaylist[index].color,
                                                doccolorfont: memotodaylist[index]
                                                    .colorfont,
                                                docindex: memotodaylist[index]
                                                        .memoindex ??
                                                    [],
                                                docname: memotodaylist[index]
                                                    .memoTitle,
                                                docsummary: memotodaylist[index]
                                                        .memolist ??
                                                    [],
                                                editdate: memotodaylist[index]
                                                    .EditDate,
                                                image: memotodaylist[index]
                                                    .photoUrl,
                                                securewith: memotodaylist[index]
                                                        .securewith ??
                                                    999,
                                                isfromwhere: 'home'),
                                            transition: Transition.downToUp);
                                      }
                                    }
                                  } else {
                                    final reloadpage = await Get.to(
                                        () => SecureAuth(
                                            string: '핀',
                                            id: memotodaylist[index].id,
                                            doc_secret_bool:
                                                memotodaylist[index].security,
                                            doc_pin_number:
                                                memotodaylist[index].pinnumber,
                                            unlock: true),
                                        transition: Transition.downToUp);
                                    if (reloadpage != null &&
                                        reloadpage == true) {
                                      Get.to(
                                          () => ClickShowEachNote(
                                              date: memotodaylist[index].Date,
                                              doc: memotodaylist[index].id,
                                              doccollection: memotodaylist[index]
                                                      .Collection ??
                                                  '',
                                              doccolor:
                                                  memotodaylist[index].color,
                                              doccolorfont: memotodaylist[index]
                                                  .colorfont,
                                              docindex: memotodaylist[index]
                                                      .memoindex ??
                                                  [],
                                              docname: memotodaylist[index]
                                                  .memoTitle,
                                              docsummary: memotodaylist[index]
                                                      .memolist ??
                                                  [],
                                              editdate:
                                                  memotodaylist[index].EditDate,
                                              image:
                                                  memotodaylist[index].photoUrl,
                                              securewith: memotodaylist[index]
                                                      .securewith ??
                                                  999,
                                              isfromwhere: 'home'),
                                          transition: Transition.downToUp);
                                    }
                                  }
                                },
                                horizontalTitleGap: 10,
                                dense: true,
                                leading: Icon(
                                  Icons.description,
                                  color: TextColor(),
                                ),
                                trailing: memotodaylist[index].security == true
                                    ? Icon(
                                        Icons.lock,
                                        color: TextColor(),
                                      )
                                    : null,
                                title: Text(memotodaylist[index].memoTitle,
                                    style: TextStyle(
                                        color: TextColor(),
                                        fontWeight: FontWeight.bold,
                                        fontSize: contentTextsize())),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        );
                      }),
              color: BGColor())
        ];
      } else if (snapshot.connectionState == ConnectionState.waiting) {
        children_memo2 = <Widget>[
          ContainerDesign(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: isresponsive == true ? 300 : 50,
                      child: const Center(child: CircularProgressIndicator()))
                ],
              ),
              color: BGColor())
        ];
      } else {
        children_memo2 = <Widget>[
          ContainerDesign(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: isresponsive == true ? 300 : 50,
                      child: Center(
                        child: NeumorphicText(
                          '오늘 변경사항이 없습니다.',
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            depth: 3,
                            color: TextColor(),
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: contentTextsize(),
                          ),
                        ),
                      ))
                ],
              ),
              color: BGColor())
        ];
      }
      return Column(children: children_memo2);
    },
  );
}
