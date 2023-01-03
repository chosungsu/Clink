// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:clickbyme/Tool/ResponsiveUI.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import '../../../Enums/Event.dart';
import '../../../Enums/Variables.dart';
import '../../../Tool/Getx/PeopleAdd.dart';
import '../../../Tool/Getx/calendarsetting.dart';
import '../../../Tool/NoBehavior.dart';
import '../../Tool/AndroidIOS.dart';
import '../../UI/Home/secondContentNet/ClickShowEachCalendar.dart';
import 'CalendarView.dart';

GlobalKey PRFlex = GlobalKey();

DayContentHome(id) {
  return Flexible(
      fit: FlexFit.tight,
      child: LayoutBuilder(
        builder: ((context, constraint) {
          return Responsivelayout(
              constraint.maxWidth,
              LSView(constraint.maxHeight, id),
              PRView(constraint.maxHeight, id));
        }),
      ));
}

LSView(maxHeight, id) {
  final controll_cals = Get.put(calendarsetting());
  List<Event> getList(DateTime date) {
    return controll_cals.events[date] ?? [];
  }

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Flexible(
        flex: 1,
        child: StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection('CalendarDataBase')
                .where('calname', isEqualTo: id)
                .snapshots(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isNotEmpty) {
                  controll_cals.events.clear();
                  final valuespace = snapshot.data!.docs;
                  for (var sp in valuespace) {
                    final ev_date = sp.get('Date');
                    final ev_todo = sp.get('Daytodo');
                    if (controll_cals.events[DateTime.parse(
                            sp.get('Date').toString().split('일')[0] +
                                ' 00:00:00.000Z')] !=
                        null) {
                      controll_cals.events[DateTime.parse(
                              sp.get('Date').toString().split('일')[0] +
                                  ' 00:00:00.000Z')]!
                          .add(Event(title: sp.get('Daytodo')));
                    } else {
                      controll_cals.events[DateTime.parse(
                          sp.get('Date').toString().split('일')[0] +
                              ' 00:00:00.000Z')] = [
                        Event(title: sp.get('Daytodo'))
                      ];
                    }
                  }
                }
              }
              return ScrollConfiguration(
                  behavior: NoBehavior(),
                  child: SingleChildScrollView(
                    physics: const ScrollPhysics(),
                    child: calendarView(context, id, 'large'),
                  ));
            })),
      ),
      Flexible(
          flex: 1,
          child: SizedBox(
            key: PRFlex,
            child: ScrollConfiguration(
              behavior: NoBehavior(),
              child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: StatefulBuilder(builder: (_, StateSetter setState) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 60,
                          ),
                          TimeLineView(id),
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
  );
}

PRView(maxHeight, id) {
  final controll_cals = Get.put(calendarsetting());
  List<Event> getList(DateTime date) {
    return controll_cals.events[date] ?? [];
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      StreamBuilder<QuerySnapshot>(
          stream: firestore
              .collection('CalendarDataBase')
              .where('calname', isEqualTo: id)
              .snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isNotEmpty) {
                controll_cals.events.clear();
                final valuespace = snapshot.data!.docs;
                for (var sp in valuespace) {
                  final ev_date = sp.get('Date');
                  final ev_todo = sp.get('Daytodo');
                  if (controll_cals.events[DateTime.parse(
                          sp.get('Date').toString().split('일')[0] +
                              ' 00:00:00.000Z')] !=
                      null) {
                    controll_cals.events[DateTime.parse(
                            sp.get('Date').toString().split('일')[0] +
                                ' 00:00:00.000Z')]!
                        .add(Event(title: sp.get('Daytodo')));
                  } else {
                    controll_cals.events[DateTime.parse(sp
                            .get('Date')
                            .toString()
                            .split('일')[0] +
                        ' 00:00:00.000Z')] = [Event(title: sp.get('Daytodo'))];
                  }
                }
              }
            }
            return SizedBox(child: calendarView(context, id, 'large'));
          })),
      Flexible(
          fit: FlexFit.tight,
          child: SizedBox(
            key: PRFlex,
            child: ScrollConfiguration(
              behavior: NoBehavior(),
              child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: StatefulBuilder(builder: (_, StateSetter setState) {
                    return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: SizedBox(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              TimeLineView(id),
                              const SizedBox(
                                height: 50,
                              )
                            ],
                          ),
                        ));
                  })),
            ),
          )),
    ],
  );
}

TimeLineView(id) {
  var updateidalarm = '';
  String hour = '';
  String minute = '';
  List<bool> alarmtypes = [];
  bool isChecked_pushalarm = false;
  final controll_cals = Get.put(calendarsetting());
  final cal_share_person = Get.put(PeopleAdd());
  List<Widget> list_timelineview = [];
  return GetBuilder<calendarsetting>(
      builder: (_) => StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection('CalendarDataBase')
                .where('calname', isEqualTo: id)
                //.where('calname', isEqualTo: widget.title)
                .where('Date',
                    isEqualTo:
                        controll_cals.selectedDay.toString().split('-')[0] +
                            '-' +
                            controll_cals.selectedDay.toString().split('-')[1] +
                            '-' +
                            controll_cals.selectedDay
                                .toString()
                                .split('-')[2]
                                .substring(0, 2) +
                            '일')
                .orderBy('Timestart')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                list_timelineview = <Widget>[
                  snapshot.data!.docs.isNotEmpty
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            //수정 및 삭제 시트 띄우기
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ContainerDesign(
                                    child: SizedBox(
                                      height: 80,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  snapshot
                                                                  .data!
                                                                  .docs[index][
                                                                      'Timestart']
                                                                  .toString() ==
                                                              '하루종일 일정으로 기록' &&
                                                          snapshot
                                                                  .data!
                                                                  .docs[index][
                                                                      'Timefinish']
                                                                  .toString() ==
                                                              '하루종일 일정으로 기록'
                                                      ? Text(
                                                          '하루종일',
                                                          maxLines: 2,
                                                          softWrap: true,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20,
                                                            color: TextColor(),
                                                          ),
                                                          overflow:
                                                              TextOverflow.clip,
                                                        )
                                                      : Column(
                                                          children: [
                                                            snapshot.data!.docs[index]
                                                                            [
                                                                            'Timestart'] ==
                                                                        '' ||
                                                                    snapshot.data!.docs[index]
                                                                            [
                                                                            'Timestart'] ==
                                                                        '하루종일 일정으로 기록'
                                                                ? Expanded(
                                                                    flex: 1,
                                                                    child: Text(
                                                                      '',
                                                                      maxLines:
                                                                          2,
                                                                      softWrap:
                                                                          true,
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            20,
                                                                        color:
                                                                            TextColor(),
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .clip,
                                                                    ),
                                                                  )
                                                                : Expanded(
                                                                    flex: 1,
                                                                    child: Text(
                                                                      snapshot.data!.docs[index]['Timestart'].toString().split(':')[1].length ==
                                                                              1
                                                                          ? snapshot.data!.docs[index]['Timestart'].toString().split(':')[0] +
                                                                              ':0' +
                                                                              snapshot.data!.docs[index]['Timestart'].toString().split(':')[
                                                                                  1]
                                                                          : snapshot
                                                                              .data!
                                                                              .docs[index]['Timestart'],
                                                                      maxLines:
                                                                          2,
                                                                      softWrap:
                                                                          true,
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            20,
                                                                        color:
                                                                            TextColor(),
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .clip,
                                                                    ),
                                                                  ),
                                                            Expanded(
                                                              flex: 1,
                                                              child: Text(
                                                                '~',
                                                                maxLines: 2,
                                                                softWrap: true,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20,
                                                                  color:
                                                                      TextColor(),
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .clip,
                                                              ),
                                                            ),
                                                            snapshot.data!.docs[index]
                                                                            [
                                                                            'Timefinish'] ==
                                                                        '' ||
                                                                    snapshot.data!.docs[index]
                                                                            [
                                                                            'Timefinish'] ==
                                                                        '하루종일 일정으로 기록'
                                                                ? Expanded(
                                                                    flex: 1,
                                                                    child: Text(
                                                                      '',
                                                                      maxLines:
                                                                          2,
                                                                      softWrap:
                                                                          true,
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            20,
                                                                        color:
                                                                            TextColor(),
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .clip,
                                                                    ),
                                                                  )
                                                                : Expanded(
                                                                    flex: 1,
                                                                    child: Text(
                                                                      snapshot.data!.docs[index]['Timefinish'].toString().split(':')[1].length ==
                                                                              1
                                                                          ? snapshot.data!.docs[index]['Timefinish'].toString().split(':')[0] +
                                                                              ':0' +
                                                                              snapshot.data!.docs[index]['Timefinish'].toString().split(':')[
                                                                                  1]
                                                                          : snapshot
                                                                              .data!
                                                                              .docs[index]['Timefinish'],
                                                                      maxLines:
                                                                          2,
                                                                      softWrap:
                                                                          true,
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            20,
                                                                        color:
                                                                            TextColor(),
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .clip,
                                                                    ),
                                                                  ),
                                                          ],
                                                        )
                                                ],
                                              )),
                                          VerticalDivider(
                                            width: 10,
                                            thickness: 1,
                                            indent: 15,
                                            endIndent: 15,
                                            color: TextColor(),
                                          ),
                                          Expanded(
                                              flex: 3,
                                              child: InkWell(
                                                onTap: () async {
                                                  await firestore
                                                      .collectionGroup(
                                                          'AlarmTable')
                                                      .get()
                                                      .then((value) {
                                                    if (value.docs.isNotEmpty) {
                                                      for (int i = 0;
                                                          i < value.docs.length;
                                                          i++) {
                                                        if (value.docs[i].id ==
                                                            cal_share_person
                                                                .secondname) {
                                                          if (value.docs[i]
                                                                      .data()[
                                                                  'calcode'] ==
                                                              snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .id) {
                                                            updateidalarm =
                                                                value
                                                                    .docs[i].id;
                                                            alarmtypes.clear();
                                                            for (int j = 0;
                                                                j <
                                                                    value
                                                                        .docs[i]
                                                                        .data()[
                                                                            'alarmtype']
                                                                        .length;
                                                                j++) {
                                                              alarmtypes.add(value
                                                                      .docs[i]
                                                                      .data()[
                                                                  'alarmtype'][j]);
                                                            }
                                                            hour = value.docs[i]
                                                                .data()[
                                                                    'alarmhour']
                                                                .toString();
                                                            minute = value
                                                                .docs[i]
                                                                .data()[
                                                                    'alarmminute']
                                                                .toString();
                                                            isChecked_pushalarm =
                                                                value.docs[i]
                                                                        .data()[
                                                                    'alarmmake'];
                                                            /*calendarsetting().settimeminute(
                                    int.parse(value.docs[i]
                                        .data()['alarmhour']
                                        .toString()),
                                    int.parse(value.docs[i]
                                        .data()['alarmminute']
                                        .toString()),
                                    snapshot.data!.docs[index]['Daytodo'],
                                    snapshot.data!.docs[index].id);*/
                                                          }
                                                        }
                                                      }
                                                    }
                                                  });
                                                  Get.to(
                                                      () =>
                                                          ClickShowEachCalendar(
                                                              groupcode: snapshot
                                                                      .data!
                                                                      .docs[index]
                                                                  ['code'],
                                                              start: snapshot
                                                                      .data!
                                                                      .docs[index]
                                                                  ['Timestart'],
                                                              finish: snapshot
                                                                      .data!
                                                                      .docs[index][
                                                                  'Timefinish'],
                                                              calinfo: snapshot
                                                                      .data!
                                                                      .docs[index]
                                                                  ['Daytodo'],
                                                              date: controll_cals
                                                                  .selectedDay,
                                                              share: snapshot.data!.docs[index]['Shares'],
                                                              //calname: widget.calname,
                                                              calname: controll_cals.calname,
                                                              code: snapshot.data!.docs[index]['calname'],
                                                              summary: snapshot.data!.docs[index]['summary'],
                                                              isfromwhere: 'dayhome',
                                                              id: snapshot.data!.docs[index].id,
                                                              alarmtypes: alarmtypes,
                                                              alarmmake: isChecked_pushalarm,
                                                              alarmhour: hour,
                                                              alarmminute: minute),
                                                      transition: Transition.downToUp);
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          bottom: 10,
                                                          right: 10),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          snapshot
                                                              .data!
                                                              .docs[index]
                                                                  ['Daytodo']
                                                              .toString(),
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              color:
                                                                  TextColor(),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          snapshot
                                                              .data!
                                                              .docs[index]
                                                                  ['summary']
                                                              .toString(),
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              color:
                                                                  TextColor_shadowcolor(),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 18),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    color: controll_cals.themecalendar == 0
                                        ? (index % 4 == 0
                                            ? MyTheme.colororigred
                                            : (index % 4 == 1
                                                ? MyTheme.colororigorange
                                                : (index % 4 == 2
                                                    ? MyTheme.colororigblue
                                                    : MyTheme.colororiggreen)))
                                        : (index % 4 == 0
                                            ? MyTheme.colorpastelred
                                            : (index % 4 == 1
                                                ? MyTheme.colorpastelorange
                                                : (index % 4 == 2
                                                    ? MyTheme.colorpastelblue
                                                    : MyTheme
                                                        .colorpastelgreen)))),
                                const SizedBox(
                                  height: 20,
                                )
                              ],
                            );
                          })
                      : Container(
                          alignment: Alignment.center,
                          height: getHeight(PRFlex) - 70 > 0
                              ? getHeight(PRFlex) - 70
                              : -getHeight(PRFlex) + 70,
                          child: Text(
                            '기록된 일정이 없네요...',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: contentTitleTextsize(),
                              color: TextColor(),
                            ),
                          ),
                        )
                ];
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                list_timelineview = <Widget>[
                  const Center(child: CircularProgressIndicator())
                ];
              } else if (!snapshot.hasData) {
                list_timelineview = <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: getHeight(PRFlex) - 70,
                    child: Text(
                      '기록된 일정이 없네요...',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize(),
                        color: TextColor(),
                      ),
                    ),
                  )
                ];
              } else {
                list_timelineview = <Widget>[
                  ListTile(
                    title: Center(
                        child: Text(
                      '데이터를 불러오는데 실패하였습니다.\n 오류가 지속될 경우 문의바랍니다.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize(),
                        color: TextColor(),
                      ),
                    )),
                  )
                ];
              }
              return Column(children: list_timelineview);
            },
          ));
}
