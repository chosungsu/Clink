import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../DB/SpaceContent.dart';
import '../../../Sub/SecureAuth.dart';
import '../../../Tool/BGColor.dart';
import '../../../Tool/ContainerDesign.dart';
import '../../../Tool/TextSize.dart';
import '../secondContentNet/ClickShowEachCalendar.dart';
import '../secondContentNet/ClickShowEachNote.dart';

ViewSet(double height, String docid, List defaulthomeviewlist,
    List userviewlist, List contentmy, List contentshare) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String name = Hive.box('user_info').get('id');
  late DateTime Date = DateTime.now();

  firestore
      .collection('HomeViewCategories')
      .where('usercode', isEqualTo: docid)
      .get()
      .then((value) {
    if (value.docs.isNotEmpty) {
    } else {
      firestore.collection('HomeViewCategories').doc(docid).set({
        'usercode': value.docs.isEmpty ? docid : value.docs[0].id,
        'viewcategory': defaulthomeviewlist,
        'hidecategory': userviewlist
      }, SetOptions(merge: true));
    }
  });
  List<Widget> list_all = [];
  List<Widget> children_cal1 = [];
  List<Widget> children_cal2 = [];
  List<Widget> children_memo1 = [];
  List<Widget> children_memo2 = [];
  //프로버전 구매시 보이지 않게 함
  return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('HomeViewCategories')
          .where('usercode', isEqualTo: docid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          list_all = <Widget>[
            ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data!.docs[0]['viewcategory'].length,
                itemBuilder: (context, index) {
                  return snapshot.data!.docs[0]['viewcategory'][index]
                              .toString() ==
                          '오늘의 일정'
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30,
                              child: Text('오늘의 일정',
                                  style: TextStyle(
                                      color: TextColor(),
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTitleTextsize())),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: firestore
                                  .collection('CalendarDataBase')
                                  .where('OriginalUser', isEqualTo: name)
                                  .where('Date',
                                      isEqualTo: Date.toString().split('-')[0] +
                                          '-' +
                                          Date.toString().split('-')[1] +
                                          '-' +
                                          Date.toString()
                                              .split('-')[2]
                                              .substring(0, 2) +
                                          '일')
                                  .orderBy('Timestart')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  contentmy.clear();
                                  var timsestart,
                                      timefinish,
                                      codes,
                                      todo,
                                      alarm;
                                  final valuespace = snapshot.data!.docs;
                                  for (var sp in valuespace) {
                                    todo = sp.get('Daytodo');
                                    timsestart = sp.get('Timestart');
                                    timefinish = sp.get('Timefinish');
                                    alarm = sp.get('Alarm');
                                    codes = sp.get('calname');
                                    contentmy.add(SpaceContent(
                                        title: todo,
                                        date: timsestart + '-' + timefinish,
                                        calendarcode: codes,
                                        alarm: alarm,
                                        finishdate: timefinish,
                                        startdate: timsestart,
                                        share: []));
                                  }
                                  children_cal1 = <Widget>[
                                    ContainerDesign(
                                        child: contentmy.isEmpty
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child: NeumorphicText(
                                                      '보여드릴 오늘의 일정이 없습니다.',
                                                      style: NeumorphicStyle(
                                                        shape: NeumorphicShape
                                                            .flat,
                                                        depth: 3,
                                                        color: TextColor(),
                                                      ),
                                                      textStyle:
                                                          NeumorphicTextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize:
                                                            contentTextsize(),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                itemCount: contentmy.length,
                                                itemBuilder: (context, index) {
                                                  return Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {},
                                                        child: ListTile(
                                                          onTap: () {
                                                            Get.to(
                                                                () =>
                                                                    ClickShowEachCalendar(
                                                                      start: contentmy[
                                                                              index]
                                                                          .startdate,
                                                                      finish: contentmy[
                                                                              index]
                                                                          .finishdate,
                                                                      calinfo: contentmy[
                                                                              index]
                                                                          .title,
                                                                      date: DateTime
                                                                          .now(),
                                                                      doc: contentmy[
                                                                              index]
                                                                          .calendarcode,
                                                                      alarm: contentmy[
                                                                              index]
                                                                          .alarm,
                                                                      share: [],
                                                                      calname: contentmy[
                                                                              index]
                                                                          .calendarcode,
                                                                    ),
                                                                transition:
                                                                    Transition
                                                                        .downToUp);
                                                          },
                                                          horizontalTitleGap:
                                                              10,
                                                          dense: true,
                                                          leading: Icon(
                                                            Icons
                                                                .calendar_month,
                                                            color: TextColor(),
                                                          ),
                                                          trailing: int.parse(contentmy[
                                                                          index]
                                                                      .startdate
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          2)) >
                                                                  Date.hour
                                                              ? (contentmy[index]
                                                                          .alarm !=
                                                                      '설정off'
                                                                  ? Icon(
                                                                      Icons
                                                                          .alarm,
                                                                      color:
                                                                          TextColor(),
                                                                    )
                                                                  : Icon(
                                                                      Icons
                                                                          .not_started,
                                                                      color:
                                                                          TextColor(),
                                                                    ))
                                                              : Icon(
                                                                  Icons.done,
                                                                  color:
                                                                      TextColor(),
                                                                ),
                                                          subtitle: Text(
                                                              contentmy[index]
                                                                  .title,
                                                              style: TextStyle(
                                                                  color:
                                                                      TextColor(),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      contentTextsize())),
                                                          title: Text(
                                                              contentmy[index]
                                                                  .date,
                                                              style: TextStyle(
                                                                color:
                                                                    TextColor(),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                  ];
                                } else if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  children_cal1 = <Widget>[
                                    ContainerDesign(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Center(
                                                child:
                                                    CircularProgressIndicator())
                                          ],
                                        ),
                                        color: BGColor())
                                  ];
                                }
                                return Column(children: children_cal1);
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        )
                      : (snapshot.data!.docs[0]['viewcategory'][index]
                                  .toString() ==
                              '공유된 오늘의 일정'
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 30,
                                  child: Text('공유된 오늘의 일정',
                                      style: TextStyle(
                                          color: TextColor(),
                                          fontWeight: FontWeight.bold,
                                          fontSize: contentTitleTextsize())),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                StreamBuilder<QuerySnapshot>(
                                  stream: firestore
                                      .collection('CalendarDataBase')
                                      .where('Date',
                                          isEqualTo: Date.toString()
                                                  .split('-')[0] +
                                              '-' +
                                              Date.toString().split('-')[1] +
                                              '-' +
                                              Date.toString()
                                                  .split('-')[2]
                                                  .substring(0, 2) +
                                              '일')
                                      .orderBy('Timestart')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      List nameList = [];
                                      contentshare.clear();
                                      var timsestart,
                                          timefinish,
                                          codes,
                                          todo,
                                          alarm;
                                      final valuespace = snapshot.data!.docs;
                                      for (var sp in valuespace) {
                                        nameList = sp.get('Shares');
                                        todo = sp.get('Daytodo');
                                        timsestart = sp.get('Timestart');
                                        timefinish = sp.get('Timefinish');
                                        codes = sp.get('calname');
                                        alarm = sp.get('Alarm');
                                        for (int i = 0;
                                            i < nameList.length;
                                            i++) {
                                          if (nameList[i].contains(name)) {
                                            contentshare.add(SpaceContent(
                                                title: todo,
                                                date: timsestart +
                                                    '-' +
                                                    timefinish,
                                                calendarcode: codes,
                                                alarm: alarm,
                                                finishdate: timefinish,
                                                startdate: timsestart,
                                                share: nameList));
                                          }
                                        }
                                      }
                                      children_cal2 = <Widget>[
                                        ContainerDesign(
                                            child: contentshare.isEmpty
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Center(
                                                        child: NeumorphicText(
                                                          '보여드릴 공유된 일정이 없습니다.',
                                                          style:
                                                              NeumorphicStyle(
                                                            shape:
                                                                NeumorphicShape
                                                                    .flat,
                                                            depth: 3,
                                                            color: TextColor(),
                                                          ),
                                                          textStyle:
                                                              NeumorphicTextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize:
                                                                contentTextsize(),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : ListView.builder(
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        contentshare.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {},
                                                            child: ListTile(
                                                              onTap: () {
                                                                Get.to(
                                                                    () =>
                                                                        ClickShowEachCalendar(
                                                                          start:
                                                                              contentshare[index].startdate,
                                                                          finish:
                                                                              contentshare[index].finishdate,
                                                                          calinfo:
                                                                              contentshare[index].title,
                                                                          date:
                                                                              DateTime.now(),
                                                                          doc: contentshare[index]
                                                                              .calendarcode,
                                                                          alarm:
                                                                              contentshare[index].alarm,
                                                                          share:
                                                                              contentshare[index]['Shares'],
                                                                          calname:
                                                                              contentshare[index].calendarcode,
                                                                        ),
                                                                    transition:
                                                                        Transition
                                                                            .downToUp);
                                                              },
                                                              horizontalTitleGap:
                                                                  10,
                                                              dense: true,
                                                              leading: Icon(
                                                                Icons
                                                                    .calendar_month,
                                                                color:
                                                                    TextColor(),
                                                              ),
                                                              trailing: int.parse(contentshare[
                                                                              index]
                                                                          .startdate
                                                                          .toString()
                                                                          .substring(
                                                                              0,
                                                                              2)) >
                                                                      Date.hour
                                                                  ? (contentshare[index]
                                                                              .alarm !=
                                                                          '설정off'
                                                                      ? Icon(
                                                                          Icons
                                                                              .alarm,
                                                                          color:
                                                                              TextColor(),
                                                                        )
                                                                      : Icon(
                                                                          Icons
                                                                              .not_started,
                                                                          color:
                                                                              TextColor(),
                                                                        ))
                                                                  : Icon(
                                                                      Icons
                                                                          .done,
                                                                      color:
                                                                          TextColor(),
                                                                    ),
                                                              subtitle: Text(
                                                                  contentshare[
                                                                          index]
                                                                      .title,
                                                                  style: TextStyle(
                                                                      color:
                                                                          TextColor(),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          contentTextsize())),
                                                              title: Text(
                                                                  contentshare[
                                                                          index]
                                                                      .date,
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        TextColor(),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
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
                                      ];
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      children_cal2 = <Widget>[
                                        ContainerDesign(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Center(
                                                    child:
                                                        CircularProgressIndicator())
                                              ],
                                            ),
                                            color: BGColor())
                                      ];
                                    }
                                    return Column(
                                      children: children_cal2,
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            )
                          : (snapshot.data!.docs[0]['viewcategory'][index]
                                      .toString() ==
                                  '홈뷰에 저장된 메모'
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      child: Text('홈뷰에 저장된 메모',
                                          style: TextStyle(
                                              color: TextColor(),
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  contentTitleTextsize())),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    StreamBuilder<QuerySnapshot>(
                                      stream: firestore
                                          .collection('MemoDataBase')
                                          .where('OriginalUser',
                                              isEqualTo: name)
                                          .where('homesave', isEqualTo: true)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          children_memo1 = <Widget>[
                                            ContainerDesign(
                                                child: snapshot
                                                        .data!.docs.isEmpty
                                                    ? Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Center(
                                                            child:
                                                                NeumorphicText(
                                                              '홈 내보내기 설정된 메모는 없습니다.',
                                                              style:
                                                                  NeumorphicStyle(
                                                                shape:
                                                                    NeumorphicShape
                                                                        .flat,
                                                                depth: 3,
                                                                color:
                                                                    TextColor(),
                                                              ),
                                                              textStyle:
                                                                  NeumorphicTextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize:
                                                                    contentTextsize(),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    : ListView.builder(
                                                        physics:
                                                            const BouncingScrollPhysics(),
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        shrinkWrap: true,
                                                        itemCount: snapshot
                                                            .data!.docs.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Column(
                                                            children: [
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {},
                                                                child: ListTile(
                                                                  onTap:
                                                                      () async {
                                                                    if (snapshot.data!.docs[index]['security'] ==
                                                                            false ||
                                                                        snapshot.data!.docs[index]['securewith'] ==
                                                                            999) {
                                                                      Get.to(
                                                                          () => ClickShowEachNote(
                                                                              date: snapshot.data!.docs[index]['Date'],
                                                                              doc: snapshot.data!.docs[index].id,
                                                                              doccollection: snapshot.data!.docs[index]['Collection'] ?? '',
                                                                              doccolor: snapshot.data!.docs[index]['color'],
                                                                              docindex: snapshot.data!.docs[index]['memoindex'] ?? [],
                                                                              docname: snapshot.data!.docs[index]['memoTitle'],
                                                                              docsummary: snapshot.data!.docs[index]['memolist'] ?? [],
                                                                              editdate: snapshot.data!.docs[index]['EditDate'],
                                                                              image: snapshot.data!.docs[index]['photoUrl']),
                                                                          transition: Transition.downToUp);
                                                                    } else if (snapshot
                                                                            .data!
                                                                            .docs[index]['securewith'] ==
                                                                        0) {
                                                                      if (GetPlatform
                                                                          .isAndroid) {
                                                                        final reloadpage = await Get.to(
                                                                            () => SecureAuth(
                                                                                string: '지문',
                                                                                id: snapshot.data!.docs[index].id,
                                                                                doc_secret_bool: snapshot.data!.docs[index]['security'],
                                                                                doc_pin_number: snapshot.data!.docs[index]['pinnumber'],
                                                                                unlock: true),
                                                                            transition: Transition.downToUp);
                                                                        if (reloadpage !=
                                                                                null &&
                                                                            reloadpage ==
                                                                                true) {
                                                                          Get.to(
                                                                              () => ClickShowEachNote(date: snapshot.data!.docs[index]['Date'], doc: snapshot.data!.docs[index].id, doccollection: snapshot.data!.docs[index]['Collection'] ?? '', doccolor: snapshot.data!.docs[index]['color'], docindex: snapshot.data!.docs[index]['memoindex'] ?? [], docname: snapshot.data!.docs[index]['memoTitle'], docsummary: snapshot.data!.docs[index]['memolist'] ?? [], editdate: snapshot.data!.docs[index]['EditDate'], image: snapshot.data!.docs[index]['photoUrl']),
                                                                              transition: Transition.downToUp);
                                                                        }
                                                                      } else {
                                                                        final reloadpage = await Get.to(
                                                                            () => SecureAuth(
                                                                                string: '얼굴',
                                                                                id: snapshot.data!.docs[index].id,
                                                                                doc_secret_bool: snapshot.data!.docs[index]['security'],
                                                                                doc_pin_number: snapshot.data!.docs[index]['pinnumber'],
                                                                                unlock: true),
                                                                            transition: Transition.downToUp);
                                                                        if (reloadpage !=
                                                                                null &&
                                                                            reloadpage ==
                                                                                true) {
                                                                          Get.to(
                                                                              () => ClickShowEachNote(date: snapshot.data!.docs[index]['Date'], doc: snapshot.data!.docs[index].id, doccollection: snapshot.data!.docs[index]['Collection'] ?? '', doccolor: snapshot.data!.docs[index]['color'], docindex: snapshot.data!.docs[index]['memoindex'] ?? [], docname: snapshot.data!.docs[index]['memoTitle'], docsummary: snapshot.data!.docs[index]['memolist'] ?? [], editdate: snapshot.data!.docs[index]['EditDate'], image: snapshot.data!.docs[index]['photoUrl']),
                                                                              transition: Transition.downToUp);
                                                                        }
                                                                      }
                                                                    } else {
                                                                      final reloadpage = await Get.to(
                                                                          () => SecureAuth(
                                                                              string: '핀',
                                                                              id: snapshot.data!.docs[index].id,
                                                                              doc_secret_bool: snapshot.data!.docs[index]['security'],
                                                                              doc_pin_number: snapshot.data!.docs[index]['pinnumber'],
                                                                              unlock: true),
                                                                          transition: Transition.downToUp);
                                                                      if (reloadpage !=
                                                                              null &&
                                                                          reloadpage ==
                                                                              true) {
                                                                        Get.to(
                                                                            () => ClickShowEachNote(
                                                                                date: snapshot.data!.docs[index]['Date'],
                                                                                doc: snapshot.data!.docs[index].id,
                                                                                doccollection: snapshot.data!.docs[index]['Collection'] ?? '',
                                                                                doccolor: snapshot.data!.docs[index]['color'],
                                                                                docindex: snapshot.data!.docs[index]['memoindex'] ?? [],
                                                                                docname: snapshot.data!.docs[index]['memoTitle'],
                                                                                docsummary: snapshot.data!.docs[index]['memolist'] ?? [],
                                                                                editdate: snapshot.data!.docs[index]['EditDate'],
                                                                                image: snapshot.data!.docs[index]['photoUrl']),
                                                                            transition: Transition.downToUp);
                                                                      }
                                                                    }
                                                                  },
                                                                  horizontalTitleGap:
                                                                      10,
                                                                  dense: true,
                                                                  leading: Icon(
                                                                    Icons
                                                                        .description,
                                                                    color:
                                                                        TextColor(),
                                                                  ),
                                                                  trailing: snapshot
                                                                              .data!
                                                                              .docs[index]['security'] ==
                                                                          true
                                                                      ? Icon(
                                                                          Icons
                                                                              .lock,
                                                                          color:
                                                                              TextColor(),
                                                                        )
                                                                      : null,
                                                                  title: Text(
                                                                      snapshot.data!
                                                                              .docs[index]
                                                                          [
                                                                          'memoTitle'],
                                                                      style: TextStyle(
                                                                          color:
                                                                              TextColor(),
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              contentTextsize())),
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
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          children_memo1 = <Widget>[
                                            ContainerDesign(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Center(
                                                        child:
                                                            CircularProgressIndicator())
                                                  ],
                                                ),
                                                color: BGColor())
                                          ];
                                        }
                                        return Column(children: children_memo1);
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      child: Text('오늘 수정 및 생성된 메모',
                                          style: TextStyle(
                                              color: TextColor(),
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  contentTitleTextsize())),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    StreamBuilder<QuerySnapshot>(
                                      stream: firestore
                                          .collection('MemoDataBase')
                                          .where('OriginalUser',
                                              isEqualTo: name)
                                          .where('EditDate',
                                              isEqualTo: Date.toString()
                                                      .split('-')[0] +
                                                  '-' +
                                                  Date.toString()
                                                      .split('-')[1] +
                                                  '-' +
                                                  Date.toString()
                                                      .split('-')[2]
                                                      .substring(0, 2) +
                                                  '일')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          children_memo2 = <Widget>[
                                            ContainerDesign(
                                                child: snapshot
                                                        .data!.docs.isEmpty
                                                    ? Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Center(
                                                            child:
                                                                NeumorphicText(
                                                              '오늘 수정된 메모는 없습니다.',
                                                              style:
                                                                  NeumorphicStyle(
                                                                shape:
                                                                    NeumorphicShape
                                                                        .flat,
                                                                depth: 3,
                                                                color:
                                                                    TextColor(),
                                                              ),
                                                              textStyle:
                                                                  NeumorphicTextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize:
                                                                    contentTextsize(),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    : ListView.builder(
                                                        physics:
                                                            const BouncingScrollPhysics(),
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        shrinkWrap: true,
                                                        itemCount: snapshot
                                                            .data!.docs.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Column(
                                                            children: [
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {},
                                                                child: ListTile(
                                                                  onTap:
                                                                      () async {
                                                                    if (snapshot.data!.docs[index]['security'] ==
                                                                            false ||
                                                                        snapshot.data!.docs[index]['securewith'] ==
                                                                            999) {
                                                                      Get.to(
                                                                          () => ClickShowEachNote(
                                                                              date: snapshot.data!.docs[index]['Date'],
                                                                              doc: snapshot.data!.docs[index].id,
                                                                              doccollection: snapshot.data!.docs[index]['Collection'] ?? '',
                                                                              doccolor: snapshot.data!.docs[index]['color'],
                                                                              docindex: snapshot.data!.docs[index]['memoindex'] ?? [],
                                                                              docname: snapshot.data!.docs[index]['memoTitle'],
                                                                              docsummary: snapshot.data!.docs[index]['memolist'] ?? [],
                                                                              editdate: snapshot.data!.docs[index]['EditDate'],
                                                                              image: snapshot.data!.docs[index]['photoUrl']),
                                                                          transition: Transition.downToUp);
                                                                    } else if (snapshot
                                                                            .data!
                                                                            .docs[index]['securewith'] ==
                                                                        0) {
                                                                      if (GetPlatform
                                                                          .isAndroid) {
                                                                        final reloadpage = await Get.to(
                                                                            () => SecureAuth(
                                                                                string: '지문',
                                                                                id: snapshot.data!.docs[index].id,
                                                                                doc_secret_bool: snapshot.data!.docs[index]['security'],
                                                                                doc_pin_number: snapshot.data!.docs[index]['pinnumber'],
                                                                                unlock: true),
                                                                            transition: Transition.downToUp);
                                                                        if (reloadpage !=
                                                                                null &&
                                                                            reloadpage ==
                                                                                true) {
                                                                          Get.to(
                                                                              () => ClickShowEachNote(date: snapshot.data!.docs[index]['Date'], doc: snapshot.data!.docs[index].id, doccollection: snapshot.data!.docs[index]['Collection'] ?? '', doccolor: snapshot.data!.docs[index]['color'], docindex: snapshot.data!.docs[index]['memoindex'] ?? [], docname: snapshot.data!.docs[index]['memoTitle'], docsummary: snapshot.data!.docs[index]['memolist'] ?? [], editdate: snapshot.data!.docs[index]['EditDate'], image: snapshot.data!.docs[index]['saveimage']),
                                                                              transition: Transition.downToUp);
                                                                        }
                                                                      } else {
                                                                        final reloadpage = await Get.to(
                                                                            () => SecureAuth(
                                                                                string: '얼굴',
                                                                                id: snapshot.data!.docs[index].id,
                                                                                doc_secret_bool: snapshot.data!.docs[index]['security'],
                                                                                doc_pin_number: snapshot.data!.docs[index]['pinnumber'],
                                                                                unlock: true),
                                                                            transition: Transition.downToUp);
                                                                        if (reloadpage !=
                                                                                null &&
                                                                            reloadpage ==
                                                                                true) {
                                                                          Get.to(
                                                                              () => ClickShowEachNote(date: snapshot.data!.docs[index]['Date'], doc: snapshot.data!.docs[index].id, doccollection: snapshot.data!.docs[index]['Collection'] ?? '', doccolor: snapshot.data!.docs[index]['color'], docindex: snapshot.data!.docs[index]['memoindex'] ?? [], docname: snapshot.data!.docs[index]['memoTitle'], docsummary: snapshot.data!.docs[index]['memolist'] ?? [], editdate: snapshot.data!.docs[index]['EditDate'], image: snapshot.data!.docs[index]['photoUrl']),
                                                                              transition: Transition.downToUp);
                                                                        }
                                                                      }
                                                                    } else {
                                                                      final reloadpage = await Get.to(
                                                                          () => SecureAuth(
                                                                              string: '핀',
                                                                              id: snapshot.data!.docs[index].id,
                                                                              doc_secret_bool: snapshot.data!.docs[index]['security'],
                                                                              doc_pin_number: snapshot.data!.docs[index]['pinnumber'],
                                                                              unlock: true),
                                                                          transition: Transition.downToUp);
                                                                      if (reloadpage !=
                                                                              null &&
                                                                          reloadpage ==
                                                                              true) {
                                                                        Get.to(
                                                                            () =>
                                                                                ClickShowEachNote(
                                                                                  date: snapshot.data!.docs[index]['Date'],
                                                                                  doc: snapshot.data!.docs[index].id,
                                                                                  doccollection: snapshot.data!.docs[index]['Collection'] ?? '',
                                                                                  doccolor: snapshot.data!.docs[index]['color'],
                                                                                  docindex: snapshot.data!.docs[index]['memoindex'] ?? [],
                                                                                  docname: snapshot.data!.docs[index]['memoTitle'],
                                                                                  docsummary: snapshot.data!.docs[index]['memolist'] ?? [],
                                                                                  editdate: snapshot.data!.docs[index]['EditDate'],
                                                                                  image: snapshot.data!.docs[index]['photoUrl'],
                                                                                ),
                                                                            transition:
                                                                                Transition.downToUp);
                                                                      }
                                                                    }
                                                                  },
                                                                  horizontalTitleGap:
                                                                      10,
                                                                  dense: true,
                                                                  leading: Icon(
                                                                    Icons
                                                                        .description,
                                                                    color:
                                                                        TextColor(),
                                                                  ),
                                                                  trailing: snapshot
                                                                              .data!
                                                                              .docs[index]['security'] ==
                                                                          true
                                                                      ? Icon(
                                                                          Icons
                                                                              .lock,
                                                                          color:
                                                                              TextColor(),
                                                                        )
                                                                      : null,
                                                                  title: Text(
                                                                      snapshot.data!
                                                                              .docs[index]
                                                                          [
                                                                          'memoTitle'],
                                                                      style: TextStyle(
                                                                          color:
                                                                              TextColor(),
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              contentTextsize())),
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
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          children_memo2 = <Widget>[
                                            ContainerDesign(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Center(
                                                        child:
                                                            CircularProgressIndicator())
                                                  ],
                                                ),
                                                color: BGColor())
                                          ];
                                        }
                                        return Column(children: children_memo2);
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                )));
                })
          ];
        } else if (snapshot.hasError) {
          list_all = <Widget>[
            ContainerDesign(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text('데이터를 불러오는데 실패하였습니다\n상황이 지속될 경우 문의바랍니다.',
                          style: TextStyle(
                              color: TextColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: contentTextsize())),
                    )
                  ],
                ),
                color: BGColor())
          ];
        } else {
          list_all = <Widget>[
            ContainerDesign(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Center(child: CircularProgressIndicator())],
                ),
                color: BGColor())
          ];
        }
        return Column(children: list_all);
      });
}
