import 'dart:ui';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../BACKENDPART/Enums/Event.dart';
import '../../../Tool/BGColor.dart';
import '../../../Tool/ContainerDesign.dart';
import '../../BACKENDPART/Getx/calendarsetting.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../../Tool/IconBtn.dart';
import '../../../Tool/MyTheme.dart';
import '../../../Tool/TextSize.dart';
import '../../../sheets/settingCalendarHome.dart';
import '../../Tool/NoBehavior.dart';
import 'DayScript.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

calendarView(
  BuildContext context,
  String id,
  String s,
) {
  List<Widget> listCalendar = [];
  final draw = Get.put(navibool());
  final controllCals = Get.put(calendarsetting());
  final calDate = Get.put(calendarsetting());
  List<Event> getList(DateTime date) {
    return controllCals.events[date] ?? [];
  }

  return s == 'oncreate'
      ? showModalBottomSheet(
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
            return Padding(
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
                  margin: const EdgeInsets.only(
                      left: 10, right: 10, bottom: kBottomNavigationBarHeight),
                  child: ScrollConfiguration(
                    behavior: NoBehavior(),
                    child: SingleChildScrollView(
                      physics: const ScrollPhysics(),
                      child: StatefulBuilder(
                        builder: ((context, setState) {
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
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                  ),
                                  child: StatefulBuilder(
                                      builder: ((context, setState) {
                                    return SizedBox(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GetBuilder<calendarsetting>(
                                            builder: (_) => ScrollConfiguration(
                                              behavior: ScrollConfiguration.of(
                                                      context)
                                                  .copyWith(dragDevices: {
                                                PointerDeviceKind.touch,
                                                PointerDeviceKind.mouse,
                                              }),
                                              child: TableCalendar(
                                                locale: 'ko_KR',
                                                availableGestures:
                                                    AvailableGestures
                                                        .horizontalSwipe,
                                                focusedDay:
                                                    controllCals.focusedDay,
                                                calendarBuilders:
                                                    CalendarBuilders(dowBuilder:
                                                        (context, day) {
                                                  if (day.weekday ==
                                                      DateTime.sunday) {
                                                    return Container(
                                                      height: 55,
                                                      child: Center(
                                                        child: Text(
                                                            DateFormat.E(
                                                                    'ko_KR')
                                                                .format(day),
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .red)),
                                                      ),
                                                    );
                                                  } else if (day.weekday ==
                                                      DateTime.saturday) {
                                                    return Container(
                                                      height: 55,
                                                      child: Center(
                                                        child: Text(
                                                            DateFormat.E(
                                                                    'ko_KR')
                                                                .format(day),
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .blue)),
                                                      ),
                                                    );
                                                  } else {
                                                    return Container(
                                                      height: 55,
                                                      child: Center(
                                                        child: Text(
                                                            DateFormat.E(
                                                                    'ko_KR')
                                                                .format(day),
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black)),
                                                      ),
                                                    );
                                                  }
                                                }, markerBuilder: (context,
                                                        date, events) {
                                                  if (events.isNotEmpty) {
                                                    return Container(
                                                        width: 50,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape
                                                                .rectangle,
                                                            color: controllCals
                                                                        .themecalendar ==
                                                                    0
                                                                ? (events.length % 4 ==
                                                                        0
                                                                    ? MyTheme
                                                                        .colororigred
                                                                    : (events.length % 4 ==
                                                                            1
                                                                        ? MyTheme
                                                                            .colororigorange
                                                                        : (events.length % 4 ==
                                                                                2
                                                                            ? MyTheme
                                                                                .colororigblue
                                                                            : MyTheme
                                                                                .colororiggreen)))
                                                                : (events.length % 4 ==
                                                                        0
                                                                    ? MyTheme
                                                                        .colorpastelred
                                                                    : (events.length % 4 ==
                                                                            1
                                                                        ? MyTheme
                                                                            .colorpastelorange
                                                                        : (events.length % 4 == 2
                                                                            ? MyTheme.colorpastelblue
                                                                            : MyTheme.colorpastelgreen)))),
                                                        child: Center(
                                                          child: Text(
                                                              '+' +
                                                                  events.length
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  color:
                                                                      TextColor())),
                                                        ));
                                                  }
                                                  return null;
                                                }),
                                                /*rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              rangeSelectionMode: _rangeSelectionMode,
              onRangeSelected: _onRangeSelected,*/
                                                pageJumpingEnabled: true,
                                                shouldFillViewport: false,
                                                rowHeight: 55,
                                                weekendDays: const [
                                                  DateTime.saturday
                                                ],
                                                holidayPredicate: (day) {
                                                  return day.weekday ==
                                                      DateTime.sunday;
                                                },
                                                firstDay:
                                                    DateTime.utc(2000, 1, 1),
                                                lastDay:
                                                    DateTime.utc(2100, 12, 31),
                                                calendarFormat: controllCals
                                                            .showcalendar ==
                                                        0
                                                    ? CalendarFormat.week
                                                    : (controllCals
                                                                .showcalendar ==
                                                            1
                                                        ? CalendarFormat
                                                            .twoWeeks
                                                        : CalendarFormat.month),
                                                eventLoader: getList,
                                                selectedDayPredicate: (day) {
                                                  return isSameDay(
                                                      controllCals.selectedDay,
                                                      day);
                                                },
                                                onDaySelected:
                                                    (selectedDay, focusedDay) {
                                                  setState(() {
                                                    controllCals.selectedDay =
                                                        selectedDay;
                                                    controllCals.focusedDay =
                                                        focusedDay;
                                                    calDate.setclickday(
                                                        controllCals
                                                            .selectedDay,
                                                        controllCals
                                                            .focusedDay);
                                                    /*_rangeStart = null;
                  _rangeEnd = null;
                  _rangeSelectionMode = RangeSelectionMode.toggledOff;*/
                                                  });
                                                },
                                                startingDayOfWeek:
                                                    StartingDayOfWeek.sunday,
                                                daysOfWeekVisible: true,
                                                daysOfWeekHeight: 50,
                                                headerStyle: HeaderStyle(
                                                    formatButtonVisible: false,
                                                    headerMargin:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    titleTextFormatter: (date,
                                                            locale) =>
                                                        DateFormat.yMMM(locale)
                                                            .format(date),
                                                    leftChevronVisible:
                                                        s == 'oncreate'
                                                            ? false
                                                            : true,
                                                    leftChevronPadding:
                                                        const EdgeInsets.only(
                                                            left: 20,
                                                            right: 10),
                                                    leftChevronMargin:
                                                        EdgeInsets.zero,
                                                    leftChevronIcon: IconBtn(
                                                        child: IconButton(
                                                            onPressed: () {
                                                              //Navigator.pop(context);
                                                              Get.back();
                                                            },
                                                            icon: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: 30,
                                                              height: 30,
                                                              child: Icon(
                                                                Feather
                                                                    .chevron_left,
                                                                size: 30,
                                                                color:
                                                                    TextColor(),
                                                              ),
                                                            )),
                                                        color: TextColor()),
                                                    rightChevronVisible:
                                                        s == 'oncreate'
                                                            ? false
                                                            : true,
                                                    rightChevronPadding:
                                                        const EdgeInsets.only(
                                                            right: 20),
                                                    rightChevronMargin: EdgeInsets.zero,
                                                    rightChevronIcon: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        IconBtn(
                                                            child: IconButton(
                                                              onPressed: () {
                                                                controllCals
                                                                    .setrepeatdate(
                                                                        1, '주');
                                                                Get.to(
                                                                    () =>
                                                                        DayScript(
                                                                          position:
                                                                              'cal',
                                                                          id: id,
                                                                          isfromwhere:
                                                                              'dayhome',
                                                                        ),
                                                                    transition:
                                                                        Transition
                                                                            .downToUp);
                                                              },
                                                              icon: Icon(
                                                                Ionicons
                                                                    .add_outline,
                                                                size: 30,
                                                                color:
                                                                    TextColor(),
                                                              ),
                                                            ),
                                                            color: TextColor()),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        IconBtn(
                                                            child: IconButton(
                                                              onPressed: () {
                                                                settingCalendarHome(
                                                                  context,
                                                                  controllCals
                                                                      .themecalendar,
                                                                  controllCals
                                                                      .showcalendar,
                                                                  id,
                                                                );
                                                              },
                                                              icon: Icon(
                                                                Ionicons
                                                                    .settings_outline,
                                                                size: 30,
                                                                color:
                                                                    TextColor(),
                                                              ),
                                                            ),
                                                            color: TextColor())
                                                      ],
                                                    ),
                                                    titleTextStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          contentTitleTextsize(),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    titleCentered: false,
                                                    formatButtonShowsNext: false),
                                                calendarStyle: CalendarStyle(
                                                    isTodayHighlighted: false,
                                                    selectedDecoration:
                                                        BoxDecoration(
                                                            color: Colors.orange
                                                                .shade400,
                                                            shape: BoxShape
                                                                .circle),
                                                    selectedTextStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            contentTitleTextsize()),
                                                    defaultTextStyle:
                                                        const TextStyle(
                                                            color:
                                                                Colors.black),
                                                    holidayTextStyle:
                                                        const TextStyle(
                                                            color: Colors.red),
                                                    holidayDecoration:
                                                        const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border()),
                                                    weekendTextStyle:
                                                        const TextStyle(
                                                            color:
                                                                Colors.blue)),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  })),
                                )),
                          );
                        }),
                      ),
                    ),
                  ),
                ));
          }).whenComplete(() {})
      : StatefulBuilder(builder: ((context, setState) {
          return SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GetBuilder<calendarsetting>(
                    builder: (_) => ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context)
                              .copyWith(dragDevices: {
                            PointerDeviceKind.touch,
                            PointerDeviceKind.mouse,
                          }),
                          child: TableCalendar(
                            locale: 'ko_KR',
                            availableGestures:
                                AvailableGestures.horizontalSwipe,
                            focusedDay: controllCals.focusedDay,
                            calendarBuilders:
                                CalendarBuilders(dowBuilder: (context, day) {
                              if (day.weekday == DateTime.sunday) {
                                return Container(
                                  height: 55,
                                  child: Center(
                                    child: Text(
                                        DateFormat.E('ko_KR').format(day),
                                        style:
                                            const TextStyle(color: Colors.red)),
                                  ),
                                );
                              } else if (day.weekday == DateTime.saturday) {
                                return Container(
                                  height: 55,
                                  child: Center(
                                    child: Text(
                                        DateFormat.E('ko_KR').format(day),
                                        style: const TextStyle(
                                            color: Colors.blue)),
                                  ),
                                );
                              } else {
                                return Container(
                                  height: 55,
                                  child: Center(
                                    child: Text(
                                        DateFormat.E('ko_KR').format(day),
                                        style: TextStyle(color: TextColor())),
                                  ),
                                );
                              }
                            }, markerBuilder: (context, date, events) {
                              if (events.isNotEmpty) {
                                return Container(
                                    width: 50,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: controllCals.themecalendar == 0
                                            ? (events.length % 4 == 0
                                                ? MyTheme.colororigred
                                                : (events.length % 4 == 1
                                                    ? MyTheme.colororigorange
                                                    : (events.length % 4 == 2
                                                        ? MyTheme.colororigblue
                                                        : MyTheme
                                                            .colororiggreen)))
                                            : (events.length % 4 == 0
                                                ? MyTheme.colorpastelred
                                                : (events.length % 4 == 1
                                                    ? MyTheme.colorpastelorange
                                                    : (events.length % 4 == 2
                                                        ? MyTheme
                                                            .colorpastelblue
                                                        : MyTheme
                                                            .colorpastelgreen)))),
                                    child: Center(
                                      child: Text(
                                          '+' + events.length.toString(),
                                          style: TextStyle(color: TextColor())),
                                    ));
                              }
                              return null;
                            }),
                            /*rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              rangeSelectionMode: _rangeSelectionMode,
              onRangeSelected: _onRangeSelected,*/
                            pageJumpingEnabled: true,
                            shouldFillViewport: false,
                            rowHeight: 55,
                            weekendDays: const [DateTime.saturday],
                            holidayPredicate: (day) {
                              return day.weekday == DateTime.sunday;
                            },
                            firstDay: DateTime.utc(2000, 1, 1),
                            lastDay: DateTime.utc(2100, 12, 31),
                            calendarFormat: controllCals.showcalendar == 0
                                ? CalendarFormat.week
                                : (controllCals.showcalendar == 1
                                    ? CalendarFormat.twoWeeks
                                    : CalendarFormat.month),
                            eventLoader: getList,
                            selectedDayPredicate: (day) {
                              return isSameDay(controllCals.selectedDay, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                controllCals.selectedDay = selectedDay;
                                controllCals.focusedDay = focusedDay;
                                calDate.setclickday(selectedDay, focusedDay);
                                /*_rangeStart = null;
                  _rangeEnd = null;
                  _rangeSelectionMode = RangeSelectionMode.toggledOff;*/
                              });
                            },
                            onPageChanged: (focusedDay) {
                              controllCals.focusedDay = focusedDay;
                            },
                            startingDayOfWeek: StartingDayOfWeek.sunday,
                            daysOfWeekVisible: true,
                            daysOfWeekHeight: 50,
                            headerStyle: HeaderStyle(
                                formatButtonVisible: false,
                                titleTextFormatter: (date, locale) =>
                                    DateFormat.yMMM(locale).format(date),
                                leftChevronVisible:
                                    s == 'oncreate' ? false : true,
                                leftChevronPadding:
                                    const EdgeInsets.only(left: 20, right: 10),
                                leftChevronMargin: EdgeInsets.zero,
                                leftChevronIcon: ContainerDesign(
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: Icon(
                                        Feather.chevron_left,
                                        size: 30,
                                        color: TextColor(),
                                      ),
                                    ),
                                    color: draw.backgroundcolor),
                                rightChevronVisible:
                                    s == 'oncreate' ? false : true,
                                rightChevronPadding:
                                    const EdgeInsets.only(right: 20),
                                rightChevronMargin: EdgeInsets.zero,
                                rightChevronIcon: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ContainerDesign(
                                        child: GestureDetector(
                                          onTap: () {
                                            controllCals.setrepeatdate(1, '주');
                                            Get.to(
                                                () => DayScript(
                                                      position: 'cal',
                                                      id: id,
                                                      isfromwhere: 'dayhome',
                                                    ),
                                                transition:
                                                    Transition.downToUp);
                                          },
                                          child: Icon(
                                            Ionicons.add_outline,
                                            size: 30,
                                            color: TextColor(),
                                          ),
                                        ),
                                        color: draw.backgroundcolor),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ContainerDesign(
                                        child: GestureDetector(
                                          onTap: () {
                                            settingCalendarHome(
                                              context,
                                              controllCals.themecalendar,
                                              controllCals.showcalendar,
                                              id,
                                            );
                                          },
                                          child: Icon(
                                            Ionicons.settings_outline,
                                            size: 30,
                                            color: TextColor(),
                                          ),
                                        ),
                                        color: draw.backgroundcolor),
                                  ],
                                ),
                                titleTextStyle: TextStyle(
                                  color: TextColor(),
                                  fontSize: contentTitleTextsize(),
                                  fontWeight: FontWeight.bold,
                                ),
                                titleCentered: false,
                                formatButtonShowsNext: false),
                            calendarStyle: CalendarStyle(
                                isTodayHighlighted: false,
                                selectedDecoration: const BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle),
                                selectedTextStyle: TextStyle(
                                    color: TextColor(),
                                    fontSize: contentTitleTextsize()),
                                defaultTextStyle: TextStyle(color: TextColor()),
                                holidayTextStyle:
                                    const TextStyle(color: Colors.red),
                                holidayDecoration: const BoxDecoration(
                                    shape: BoxShape.circle, border: Border()),
                                weekendTextStyle:
                                    const TextStyle(color: Colors.blue)),
                          ),
                        ))
              ],
            ),
          );
        }));
}
