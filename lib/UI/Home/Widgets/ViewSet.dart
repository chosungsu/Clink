import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../BACKENDPART/Auth/SecureAuth.dart';
import '../../../Enums/SpaceContent.dart';
import '../../../Tool/BGColor.dart';
import '../../../Tool/ContainerDesign.dart';
import '../../../Tool/Getx/PeopleAdd.dart';
import '../../../Tool/Getx/calendarsetting.dart';
import '../../../Tool/TextSize.dart';
import '../firstContentNet/DayContentHome.dart';
import '../secondContentNet/ClickShowEachNote.dart';

ViewSet(List defaulthomeviewlist, List userviewlist, String usercode) {
  final peopleadd = Get.put(PeopleAdd());
  String name = Hive.box('user_info').get('id');
  DateTime Date = DateTime.now();
  List contentmy = [];
  List contentshare = [];
  List memosavelist = [];
  List memotodaylist = [];
  String secondname = peopleadd.secondname;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  firestore
      .collection('CalendarDataBase')
      .where('OriginalUser', isEqualTo: usercode)
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
    var timsestart, timefinish, codes, todo, share, summary, id;
    List cname = [];
    if (value.docs.isNotEmpty) {
      final valuespace = value.docs;
      for (var sp in valuespace) {
        id = sp.id;
        todo = sp.get('Daytodo');
        timsestart = sp.get('Timestart');
        timefinish = sp.get('Timefinish');
        codes = sp.get('calname');
        share = sp.get('Shares');
        summary = sp.get('summary');
        firestore
            .collection('CalendarSheetHome_update')
            .doc(codes)
            .get()
            .then((value) {
          if (value.exists) {
            value.data()!.forEach((key, value) {
              //print(key + '-' + value);
              if (key == 'calname') {
                cname.add(value);
              }
            });
          }
        });
        contentmy.add(SpaceContent(
            title: todo,
            date: timsestart == '하루종일 일정으로 기록' && timefinish == '하루종일 일정으로 기록'
                ? ('하루종일 일정으로 기록')
                : timsestart + '-' + timefinish,
            cname: cname,
            finishdate: timefinish,
            startdate: timsestart,
            share: share,
            code: codes,
            summary: summary,
            id: id));
      }
    }
  });
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
    var timsestart, timefinish, codes, todo, summary, id;
    List cname = [];
    if (value.docs.isNotEmpty) {
      final valuespace = value.docs;
      for (var sp in valuespace) {
        id = sp.id;
        nameList = sp.get('Shares');
        todo = sp.get('Daytodo');
        timsestart = sp.get('Timestart');
        timefinish = sp.get('Timefinish');
        codes = sp.get('calname');
        summary = sp.get('summary');
        firestore
            .collection('CalendarSheetHome_update')
            .doc(codes)
            .get()
            .then((value) {
          if (value.exists) {
            value.data()!.forEach((key, value) {
              //print(key + '-' + value);
              if (key == 'calname') {
                cname.add(value);
              }
            });
          }
        });
        for (int i = 0; i < nameList.length; i++) {
          if (nameList[i].contains(secondname)) {
            contentshare.add(SpaceContent(
                title: todo,
                date:
                    timsestart == '하루종일 일정으로 기록' && timefinish == '하루종일 일정으로 기록'
                        ? ('하루종일 일정으로 기록')
                        : timsestart + '-' + timefinish,
                cname: cname,
                finishdate: timefinish,
                startdate: timsestart,
                share: nameList,
                code: codes,
                summary: summary,
                id: id));
          }
        }
      }
    }
  }));
  firestore
      .collection('MemoDataBase')
      .where('OriginalUser', isEqualTo: usercode)
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
  firestore
      .collection('MemoDataBase')
      .where('OriginalUser', isEqualTo: usercode)
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

  return ListView.builder(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: defaulthomeviewlist.length,
      itemBuilder: (context, index) {
        return defaulthomeviewlist[index].toString() == '오늘의 일정'
            ? Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
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
                    stream1(peopleadd.secondname, contentmy, usercode),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )
            : (defaulthomeviewlist[index].toString() == '공유된 오늘의 일정'
                ? Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
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
                        stream2(peopleadd.secondname, contentshare, usercode),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )
                : (defaulthomeviewlist[index].toString() == '홈뷰에 저장된 메모'
                    ? Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
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
                            stream3(
                                peopleadd.secondname, memosavelist, usercode),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
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
                            stream4(
                                peopleadd.secondname, memotodaylist, usercode),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )));
      });
}

stream1(
  String secondname,
  List contentmy,
  String usercode,
) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String name = Hive.box('user_info').get('id');
  DateTime Date = DateTime.now();
  final peopleadd = Get.put(PeopleAdd());
  var updateidalarm = '';
  List<bool> alarmtypes = [];
  bool isChecked_pushalarm = false;
  List<Widget> list_all = [];
  String id = '';

  return FutureBuilder<QuerySnapshot>(
    future: firestore
        .collection('CalendarDataBase')
        .where('OriginalUser', isEqualTo: usercode)
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
      if (snapshot.hasData &&
          snapshot.data!.docs.isNotEmpty &&
          contentmy.isNotEmpty) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ContainerDesign(
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: contentmy.length,
                    itemBuilder: (context, index) {
                      firestore
                          .collectionGroup('AlarmTable')
                          .get()
                          .then((value) {
                        if (value.docs.isNotEmpty) {
                          for (int i = 0; i < value.docs.length; i++) {
                            if (value.docs[i].id == name) {
                              if (value.docs[i].data()['calcode'] ==
                                  contentmy[index].id) {
                                updateidalarm = value.docs[i].id;
                                alarmtypes.clear();
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
                                    'alarm_cal_hour_${contentmy[index].id}_${peopleadd.secondname}',
                                    value.docs[i]
                                        .data()['alarmhour']
                                        .toString());
                                Hive.box('user_setting').put(
                                    'alarm_cal_minute_${contentmy[index].id}_${peopleadd.secondname}',
                                    value.docs[i]
                                        .data()['alarmminute']
                                        .toString());
                                calendarsetting().hour1 =
                                    Hive.box('user_setting').get(
                                        'alarm_cal_hour_${contentmy[index].id}_${peopleadd.secondname}');
                                calendarsetting().minute1 =
                                    Hive.box('user_setting').get(
                                        'alarm_cal_minute_${contentmy[index].id}_${peopleadd.secondname}');
                                isChecked_pushalarm =
                                    value.docs[i].data()['alarmmake'];
                                calendarsetting().settimeminute(
                                    int.parse(value.docs[i]
                                        .data()['alarmhour']
                                        .toString()),
                                    int.parse(value.docs[i]
                                        .data()['alarmminute']
                                        .toString()),
                                    contentmy[index].id,
                                    contentmy[index].id);
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
                          InkWell(
                            onTap: () {
                              Get.to(
                                () => DayContentHome(
                                  contentmy[index].code,
                                ),
                                transition: Transition.rightToLeft,
                              );
                              /*Get.to(
                                  () => ChooseCalendar(
                                        isfromwhere: 'home',
                                        index: 0,
                                      ),
                                  transition: Transition.downToUp);*/
                              /*Get.to(
                                  () => ClickShowEachCalendar(
                                        start: contentmy[index].startdate,
                                        finish: contentmy[index].finishdate,
                                        calinfo: contentmy[index].title,
                                        date: Date,
                                        share: contentmy[index].share,
                                        calname:
                                            contentmy[index].cname.toString(),
                                        code: contentmy[index].code,
                                        summary: contentmy[index].summary,
                                        isfromwhere: 'home',
                                        id: snapshot.data!.docs[index].id,
                                        alarmtypes: alarmtypes,
                                        alarmmake: isChecked_pushalarm,
                                      ),
                                  transition: Transition.upToDown);*/
                            },
                            child: ListTile(
                              horizontalTitleGap: 10,
                              dense: true,
                              leading: Icon(
                                Icons.calendar_month,
                                color: TextColor(),
                              ),
                              trailing: contentmy[index].startdate.toString() ==
                                      '하루종일 일정으로 기록'
                                  ? ((isChecked_pushalarm
                                      ? Icon(
                                          Icons.alarm,
                                          color: TextColor(),
                                        )
                                      : Icon(
                                          Icons.done,
                                          color: TextColor(),
                                        )))
                                  : (int.parse(contentmy[index]
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
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      );
                    }),
                color: BGColor())
          ],
        );
      } else if (snapshot.connectionState == ConnectionState.waiting) {
        return ContainerDesign(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(
                    height: 50,
                    child: Center(child: CircularProgressIndicator()))
              ],
            ),
            color: BGColor());
      } else {
        return ContainerDesign(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
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
            color: BGColor());
      }
    },
  );
}

stream2(
  String secondname,
  List contentshare,
  String usercode,
) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String name = Hive.box('user_info').get('id');
  DateTime Date = DateTime.now();
  final peopleadd = Get.put(PeopleAdd());

  List<Widget> list_all = [];
  List<Widget> children_cal2 = [];
  var updateidalarm = '';
  List<bool> alarmtypes = [];
  bool isChecked_pushalarm = false;

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
      if (snapshot.hasData &&
          snapshot.data!.docs.isNotEmpty &&
          contentshare.isNotEmpty) {
        children_cal2 = <Widget>[
          ContainerDesign(
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: contentshare.length,
                  itemBuilder: (context, index) {
                    firestore.collectionGroup('AlarmTable').get().then((value) {
                      if (value.docs.isNotEmpty) {
                        for (int i = 0; i < value.docs.length; i++) {
                          if (value.docs[i].id == name) {
                            if (value.docs[i].data()['calcode'] ==
                                snapshot.data!.docs[index].id) {
                              updateidalarm = value.docs[i].id;
                              for (int j = 0;
                                  j < value.docs[i].data()['alarmtype'].length;
                                  j++) {
                                alarmtypes
                                    .add(value.docs[i].data()['alarmtype'][j]);
                              }
                              Hive.box('user_setting').put(
                                  'alarm_cal_hour_${snapshot.data!.docs[index].id}_${peopleadd.secondname}',
                                  value.docs[i].data()['alarmhour'].toString());
                              Hive.box('user_setting').put(
                                  'alarm_cal_minute_${snapshot.data!.docs[index].id}_${peopleadd.secondname}',
                                  value.docs[i]
                                      .data()['alarmminute']
                                      .toString());
                              calendarsetting().hour1 = Hive.box('user_setting')
                                  .get(
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
                            child:
                                StatefulBuilder(builder: ((context, setState) {
                              return ListTile(
                                onTap: () async {
                                  //수정 및 삭제 시트 띄우기
                                  Get.to(
                                    () => DayContentHome(
                                      contentshare[index].code,
                                    ),
                                    transition: Transition.rightToLeft,
                                  );
                                  /*Get.to(
                                      () => ChooseCalendar(
                                            isfromwhere: 'home',
                                            index: 1,
                                          ),
                                      transition: Transition.downToUp);*/
                                },
                                horizontalTitleGap: 10,
                                dense: true,
                                leading: Icon(
                                  Icons.calendar_month,
                                  color: TextColor(),
                                ),
                                trailing:
                                    contentshare[index].startdate.toString() ==
                                            '하루종일 일정으로 기록'
                                        ? ((isChecked_pushalarm
                                            ? Icon(
                                                Icons.alarm,
                                                color: TextColor(),
                                              )
                                            : Icon(
                                                Icons.done,
                                                color: TextColor(),
                                              )))
                                        : (int.parse(contentshare[index]
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
                children: const [
                  SizedBox(
                      height: 50,
                      child: Center(child: CircularProgressIndicator()))
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
                    height: 50,
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
  List memosavelist,
  String usercode,
) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DateTime Date = DateTime.now();
  final peopleadd = Get.put(PeopleAdd());

  List<Widget> list_all = [];
  List<Widget> children_memo1 = [];

  return FutureBuilder<QuerySnapshot>(
    future: firestore
        .collection('MemoDataBase')
        .where('OriginalUser', isEqualTo: usercode)
        .where('homesave', isEqualTo: true)
        .get(),
    builder: (context, snapshot) {
      if (snapshot.hasData &&
          snapshot.data!.docs.isNotEmpty &&
          memosavelist.isNotEmpty) {
        children_memo1 = <Widget>[
          ContainerDesign(
              child: ListView.builder(
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
                            child:
                                StatefulBuilder(builder: ((context, setState) {
                              return ListTile(
                                onTap: () async {
                                  if (memosavelist[index].security == false ||
                                      memosavelist[index].securewith == 999) {
                                    Get.to(
                                        () => ClickShowEachNote(
                                              date: memosavelist[index].Date,
                                              doc: memosavelist[index].id,
                                              doccollection: memosavelist[index]
                                                      .Collection ??
                                                  '',
                                              doccolor: memosavelist[index]
                                                  .backgroundcolor,
                                              doccolorfont:
                                                  memosavelist[index].colorfont,
                                              docindex: memosavelist[index]
                                                      .memoindex ??
                                                  [],
                                              docname:
                                                  memosavelist[index].memoTitle,
                                              docsummary: memosavelist[index]
                                                      .memolist ??
                                                  [],
                                              editdate:
                                                  memosavelist[index].EditDate,
                                              image:
                                                  memosavelist[index].photoUrl,
                                              securewith: memosavelist[index]
                                                      .securewith ??
                                                  999,
                                              isfromwhere: 'home',
                                            ),
                                        transition: Transition.downToUp);
                                  } else if (memosavelist[index].securewith ==
                                      0) {
                                    if (GetPlatform.isAndroid) {
                                      final reloadpage = await Get.to(
                                          () => SecureAuth(
                                              string: '지문',
                                              id: memosavelist[index].id,
                                              doc_secret_bool:
                                                  memosavelist[index].security,
                                              doc_pin_number:
                                                  memosavelist[index].pinnumber,
                                              unlock: true),
                                          transition: Transition.downToUp);
                                      if (reloadpage != null &&
                                          reloadpage == true) {
                                        Get.to(
                                            () => ClickShowEachNote(
                                                date: memosavelist[index].Date,
                                                doc: memosavelist[index].id,
                                                doccollection:
                                                    memosavelist[index]
                                                            .Collection ??
                                                        '',
                                                doccolor: memosavelist[index]
                                                    .backgroundcolor,
                                                doccolorfont: memosavelist[index]
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
                                                securewith: memosavelist[index]
                                                        .securewith ??
                                                    999,
                                                isfromwhere: 'home'),
                                            transition: Transition.downToUp);
                                      }
                                    } else {
                                      final reloadpage = await Get.to(
                                          () => SecureAuth(
                                              string: '얼굴',
                                              id: memosavelist[index].id,
                                              doc_secret_bool:
                                                  memosavelist[index].security,
                                              doc_pin_number:
                                                  memosavelist[index].pinnumber,
                                              unlock: true),
                                          transition: Transition.downToUp);
                                      if (reloadpage != null &&
                                          reloadpage == true) {
                                        Get.to(
                                            () => ClickShowEachNote(
                                                date: memosavelist[index].Date,
                                                doc: memosavelist[index].id,
                                                doccollection:
                                                    memosavelist[index]
                                                            .Collection ??
                                                        '',
                                                doccolor: memosavelist[index]
                                                    .backgroundcolor,
                                                doccolorfont: memosavelist[index]
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
                                                securewith: memosavelist[index]
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
                                            id: memosavelist[index].id,
                                            doc_secret_bool:
                                                memosavelist[index].security,
                                            doc_pin_number:
                                                memosavelist[index].pinnumber,
                                            unlock: true),
                                        transition: Transition.downToUp);
                                    if (reloadpage != null &&
                                        reloadpage == true) {
                                      Get.to(
                                          () => ClickShowEachNote(
                                              date: memosavelist[index].Date,
                                              doc: memosavelist[index].id,
                                              doccollection: memosavelist[index]
                                                      .Collection ??
                                                  '',
                                              doccolor: memosavelist[index]
                                                  .backgroundcolor,
                                              doccolorfont:
                                                  memosavelist[index].colorfont,
                                              docindex: memosavelist[index]
                                                      .memoindex ??
                                                  [],
                                              docname:
                                                  memosavelist[index].memoTitle,
                                              docsummary: memosavelist[index]
                                                      .memolist ??
                                                  [],
                                              editdate:
                                                  memosavelist[index].EditDate,
                                              image:
                                                  memosavelist[index].photoUrl,
                                              securewith: memosavelist[index]
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
                                trailing: memosavelist[index].security == true
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
                children: const [
                  SizedBox(
                      height: 50,
                      child: Center(child: CircularProgressIndicator()))
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
                      height: 50,
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
  List memotodaylist,
  String usercode,
) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DateTime Date = DateTime.now();
  final peopleadd = Get.put(PeopleAdd());

  List<Widget> list_all = [];
  List<Widget> children_memo2 = [];

  return FutureBuilder<QuerySnapshot>(
    future: firestore
        .collection('MemoDataBase')
        .where('OriginalUser', isEqualTo: usercode)
        .where('homesave', isEqualTo: true)
        .get(),
    builder: (context, snapshot) {
      if (snapshot.hasData &&
          snapshot.data!.docs.isNotEmpty &&
          memotodaylist.isNotEmpty) {
        children_memo2 = <Widget>[
          ContainerDesign(
              child: ListView.builder(
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
                                        doccollection:
                                            memotodaylist[index].Collection ??
                                                '',
                                        doccolor: memotodaylist[index]
                                            .backgroundcolor,
                                        doccolorfont:
                                            memotodaylist[index].colorfont,
                                        docindex:
                                            memotodaylist[index].memoindex ??
                                                [],
                                        docname: memotodaylist[index].memoTitle,
                                        docsummary:
                                            memotodaylist[index].memolist ?? [],
                                        editdate: memotodaylist[index].EditDate,
                                        image: memotodaylist[index].photoUrl,
                                        securewith:
                                            memotodaylist[index].securewith ??
                                                999,
                                        isfromwhere: 'home'),
                                    transition: Transition.downToUp);
                              } else if (memotodaylist[index].securewith == 0) {
                                if (GetPlatform.isAndroid) {
                                  final reloadpage = await Get.to(
                                      () => SecureAuth(
                                          string: '지문',
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
                                            doccolor: memotodaylist[index]
                                                .backgroundcolor,
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
                                  }
                                } else {
                                  final reloadpage = await Get.to(
                                      () => SecureAuth(
                                          string: '얼굴',
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
                                            doccolor: memotodaylist[index]
                                                .backgroundcolor,
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
                                if (reloadpage != null && reloadpage == true) {
                                  Get.to(
                                      () => ClickShowEachNote(
                                          date: memotodaylist[index].Date,
                                          doc: memotodaylist[index].id,
                                          doccollection:
                                              memotodaylist[index].Collection ??
                                                  '',
                                          doccolor: memotodaylist[index]
                                              .backgroundcolor,
                                          doccolorfont:
                                              memotodaylist[index].colorfont,
                                          docindex:
                                              memotodaylist[index].memoindex ??
                                                  [],
                                          docname:
                                              memotodaylist[index].memoTitle,
                                          docsummary:
                                              memotodaylist[index].memolist ??
                                                  [],
                                          editdate:
                                              memotodaylist[index].EditDate,
                                          image: memotodaylist[index].photoUrl,
                                          securewith:
                                              memotodaylist[index].securewith ??
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
                children: const [
                  SizedBox(
                      height: 50,
                      child: Center(child: CircularProgressIndicator()))
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
                      height: 50,
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
