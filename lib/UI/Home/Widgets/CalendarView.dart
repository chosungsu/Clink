import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../DB/Event.dart';
import '../../../Tool/BGColor.dart';
import '../../../Tool/Getx/calendarsetting.dart';
import '../../../Tool/IconBtn.dart';
import '../../../Tool/MyTheme.dart';
import '../../../Tool/TextSize.dart';
import '../../../sheets/settingCalendarHome.dart';
import '../firstContentNet/DayScript.dart';

calendarView(
  BuildContext context,
  calendarsetting controll_cals,
  Map<DateTime, List<Event>> events,
  DateTime _focusedDay,
  DateTime _selectedDay,
  String title,
  List share,
  String calname,
  String usercode,
  int theme,
  int view,
  String s,
) {
  List<Widget> list_calendar = [];
  List<Event> getList(DateTime date) {
    return events[date] ?? [];
  }

  final cal_date = Get.put(calendarsetting());

  return s == 'oncreate'
      ? showModalBottomSheet(
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
                    child: StatefulBuilder(builder: ((context, setState) {
                      return SizedBox(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GetBuilder<calendarsetting>(
                              builder: (_) => TableCalendar(
                                locale: 'ko_KR',
                                focusedDay: controll_cals.focusedDay,
                                calendarBuilders: CalendarBuilders(
                                    dowBuilder: (context, day) {
                                  if (day.weekday == DateTime.sunday) {
                                    return Container(
                                      height: 55,
                                      child: Center(
                                        child: Text(
                                            DateFormat.E('ko_KR').format(day),
                                            style: const TextStyle(
                                                color: Colors.red)),
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
                                            style:
                                                TextStyle(color: TextColor())),
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
                                            color: controll_cals.themecalendar ==
                                                    0
                                                ? (events.length % 4 == 0
                                                    ? MyTheme.colororigred
                                                    : (events.length % 4 == 1
                                                        ? MyTheme
                                                            .colororigorange
                                                        : (events.length % 4 == 2
                                                            ? MyTheme
                                                                .colororigblue
                                                            : MyTheme
                                                                .colororiggreen)))
                                                : (events.length % 4 == 0
                                                    ? MyTheme.colorpastelred
                                                    : (events.length % 4 == 1
                                                        ? MyTheme
                                                            .colorpastelorange
                                                        : (events.length % 4 ==
                                                                2
                                                            ? MyTheme
                                                                .colorpastelblue
                                                            : MyTheme
                                                                .colorpastelgreen)))),
                                        child: Center(
                                          child: Text(
                                              '+' + events.length.toString(),
                                              style: TextStyle(
                                                  color: TextColor())),
                                        ));
                                  }
                                  return null;
                                }),
                                /*rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              rangeSelectionMode: _rangeSelectionMode,
              onRangeSelected: _onRangeSelected,*/
                                pageJumpingEnabled: false,
                                shouldFillViewport: false,
                                rowHeight: 55,
                                weekendDays: const [DateTime.saturday],
                                holidayPredicate: (day) {
                                  return day.weekday == DateTime.sunday;
                                },
                                firstDay: DateTime.utc(2000, 1, 1),
                                lastDay: DateTime.utc(2100, 12, 31),
                                calendarFormat: controll_cals.showcalendar == 0
                                    ? CalendarFormat.week
                                    : (controll_cals.showcalendar == 1
                                        ? CalendarFormat.twoWeeks
                                        : CalendarFormat.month),
                                eventLoader: getList,
                                selectedDayPredicate: (day) {
                                  return isSameDay(
                                      controll_cals.selectedDay, day);
                                },
                                onDaySelected: (selectedDay, focusedDay) {
                                  setState(() {
                                    controll_cals.selectedDay = selectedDay;
                                    controll_cals.focusedDay = focusedDay;
                                    print(controll_cals.selectedDay.toString() +
                                        '/' +
                                        controll_cals.focusedDay.toString());
                                    cal_date.setclickday(
                                        controll_cals.selectedDay,
                                        controll_cals.focusedDay);
                                    /*_rangeStart = null;
                  _rangeEnd = null;
                  _rangeSelectionMode = RangeSelectionMode.toggledOff;*/
                                  });
                                },
                                startingDayOfWeek: StartingDayOfWeek.sunday,
                                daysOfWeekVisible: true,
                                daysOfWeekHeight: 50,
                                headerStyle: HeaderStyle(
                                    formatButtonVisible: false,
                                    headerMargin:
                                        const EdgeInsets.only(left: 10),
                                    titleTextFormatter: (date, locale) =>
                                        DateFormat.yMMM(locale).format(date),
                                    leftChevronVisible:
                                        s == 'oncreate' ? false : true,
                                    leftChevronPadding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    leftChevronMargin: EdgeInsets.zero,
                                    leftChevronIcon: IconBtn(
                                        child: IconButton(
                                            onPressed: () {
                                              //Navigator.pop(context);
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
                                                    shape:
                                                        NeumorphicShape.convex,
                                                    depth: 2,
                                                    surfaceIntensity: 0.5,
                                                    color: TextColor(),
                                                    lightSource:
                                                        LightSource.topLeft),
                                              ),
                                            )),
                                        color: TextColor()),
                                    rightChevronVisible:
                                        s == 'oncreate' ? false : true,
                                    rightChevronPadding:
                                        const EdgeInsets.only(right: 10),
                                    rightChevronMargin: EdgeInsets.zero,
                                    rightChevronIcon: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconBtn(
                                            child: IconButton(
                                              onPressed: () {
                                                controll_cals.setrepeatdate(
                                                    1, '주');
                                                Get.to(
                                                    () => DayScript(
                                                          firstdate:
                                                              controll_cals
                                                                  .selectedDay,
                                                          lastdate:
                                                              controll_cals
                                                                  .selectedDay,
                                                          position: 'cal',
                                                          title: title,
                                                          share: share,
                                                          orig: usercode,
                                                          calname: calname,
                                                          isfromwhere:
                                                              'dayhome',
                                                        ),
                                                    transition:
                                                        Transition.downToUp);
                                              },
                                              icon: NeumorphicIcon(
                                                Icons.add,
                                                size: 30,
                                                style: NeumorphicStyle(
                                                    shape:
                                                        NeumorphicShape.convex,
                                                    depth: 2,
                                                    surfaceIntensity: 0.5,
                                                    color: TextColor(),
                                                    lightSource:
                                                        LightSource.topLeft),
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
                                                  controll_cals,
                                                  theme,
                                                  view,
                                                  title,
                                                );
                                              },
                                              icon: NeumorphicIcon(
                                                Icons.settings,
                                                size: 30,
                                                style: NeumorphicStyle(
                                                    shape:
                                                        NeumorphicShape.convex,
                                                    depth: 2,
                                                    surfaceIntensity: 0.5,
                                                    color: TextColor(),
                                                    lightSource:
                                                        LightSource.topLeft),
                                              ),
                                            ),
                                            color: TextColor())
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
                                    selectedDecoration: BoxDecoration(
                                        color: Colors.orange.shade400,
                                        shape: BoxShape.circle),
                                    selectedTextStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: contentTitleTextsize()),
                                    defaultTextStyle:
                                        TextStyle(color: TextColor()),
                                    holidayTextStyle:
                                        const TextStyle(color: Colors.red),
                                    holidayDecoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border()),
                                    weekendTextStyle:
                                        const TextStyle(color: Colors.blue)),
                              ),
                            )
                          ],
                        ),
                      );
                    })),
                  )),
            );
          }).whenComplete(() {})
      : StatefulBuilder(builder: ((context, setState) {
          return SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GetBuilder<calendarsetting>(
                  builder: (_) => TableCalendar(
                    locale: 'ko_KR',
                    focusedDay: controll_cals.focusedDay,
                    calendarBuilders:
                        CalendarBuilders(dowBuilder: (context, day) {
                      if (day.weekday == DateTime.sunday) {
                        return Container(
                          height: 55,
                          child: Center(
                            child: Text(DateFormat.E('ko_KR').format(day),
                                style: const TextStyle(color: Colors.red)),
                          ),
                        );
                      } else if (day.weekday == DateTime.saturday) {
                        return Container(
                          height: 55,
                          child: Center(
                            child: Text(DateFormat.E('ko_KR').format(day),
                                style: const TextStyle(color: Colors.blue)),
                          ),
                        );
                      } else {
                        return Container(
                          height: 55,
                          child: Center(
                            child: Text(DateFormat.E('ko_KR').format(day),
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
                                color: controll_cals.themecalendar == 0
                                    ? (events.length % 4 == 0
                                        ? MyTheme.colororigred
                                        : (events.length % 4 == 1
                                            ? MyTheme.colororigorange
                                            : (events.length % 4 == 2
                                                ? MyTheme.colororigblue
                                                : MyTheme.colororiggreen)))
                                    : (events.length % 4 == 0
                                        ? MyTheme.colorpastelred
                                        : (events.length % 4 == 1
                                            ? MyTheme.colorpastelorange
                                            : (events.length % 4 == 2
                                                ? MyTheme.colorpastelblue
                                                : MyTheme.colorpastelgreen)))),
                            child: Center(
                              child: Text('+' + events.length.toString(),
                                  style: TextStyle(color: TextColor())),
                            ));
                      }
                      return null;
                    }),
                    /*rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              rangeSelectionMode: _rangeSelectionMode,
              onRangeSelected: _onRangeSelected,*/
                    pageJumpingEnabled: false,
                    shouldFillViewport: false,
                    rowHeight: 55,
                    weekendDays: const [DateTime.saturday],
                    holidayPredicate: (day) {
                      return day.weekday == DateTime.sunday;
                    },
                    firstDay: DateTime.utc(2000, 1, 1),
                    lastDay: DateTime.utc(2100, 12, 31),
                    calendarFormat: controll_cals.showcalendar == 0
                        ? CalendarFormat.week
                        : (controll_cals.showcalendar == 1
                            ? CalendarFormat.twoWeeks
                            : CalendarFormat.month),
                    eventLoader: getList,
                    selectedDayPredicate: (day) {
                      return isSameDay(controll_cals.selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        controll_cals.selectedDay = selectedDay;
                        controll_cals.focusedDay = focusedDay;
                        cal_date.setclickday(selectedDay, focusedDay);
                        /*_rangeStart = null;
                  _rangeEnd = null;
                  _rangeSelectionMode = RangeSelectionMode.toggledOff;*/
                      });
                    },
                    onPageChanged: (focusedDay) {
                      controll_cals.focusedDay = focusedDay;
                    },
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    daysOfWeekVisible: true,
                    daysOfWeekHeight: 50,
                    headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleTextFormatter: (date, locale) =>
                            DateFormat.yMMM(locale).format(date),
                        leftChevronVisible: s == 'oncreate' ? false : true,
                        leftChevronPadding:
                            const EdgeInsets.only(left: 10, right: 10),
                        leftChevronMargin: EdgeInsets.zero,
                        leftChevronIcon: IconBtn(
                            child: IconButton(
                                onPressed: () {
                                  //Navigator.pop(context);
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
                                        lightSource: LightSource.topLeft),
                                  ),
                                )),
                            color: TextColor()),
                        rightChevronVisible: s == 'oncreate' ? false : true,
                        rightChevronPadding: const EdgeInsets.only(right: 10),
                        rightChevronMargin: EdgeInsets.zero,
                        rightChevronIcon: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconBtn(
                                child: IconButton(
                                  onPressed: () {
                                    controll_cals.setrepeatdate(1, '주');
                                    Get.to(
                                        () => DayScript(
                                              firstdate:
                                                  controll_cals.selectedDay,
                                              lastdate:
                                                  controll_cals.selectedDay,
                                              position: 'cal',
                                              title: title,
                                              share: share,
                                              orig: usercode,
                                              calname: calname,
                                              isfromwhere: 'dayhome',
                                            ),
                                        transition: Transition.downToUp);
                                  },
                                  icon: NeumorphicIcon(
                                    Icons.add,
                                    size: 30,
                                    style: NeumorphicStyle(
                                        shape: NeumorphicShape.convex,
                                        depth: 2,
                                        surfaceIntensity: 0.5,
                                        color: TextColor(),
                                        lightSource: LightSource.topLeft),
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
                                      controll_cals,
                                      theme,
                                      view,
                                      title,
                                    );
                                  },
                                  icon: NeumorphicIcon(
                                    Icons.settings,
                                    size: 30,
                                    style: NeumorphicStyle(
                                        shape: NeumorphicShape.convex,
                                        depth: 2,
                                        surfaceIntensity: 0.5,
                                        color: TextColor(),
                                        lightSource: LightSource.topLeft),
                                  ),
                                ),
                                color: TextColor())
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
                            color: Colors.orange, shape: BoxShape.circle),
                        selectedTextStyle: TextStyle(
                            color: TextColor(),
                            fontSize: contentTitleTextsize()),
                        defaultTextStyle: TextStyle(color: TextColor()),
                        holidayTextStyle: const TextStyle(color: Colors.red),
                        holidayDecoration: const BoxDecoration(
                            shape: BoxShape.circle, border: Border()),
                        weekendTextStyle: const TextStyle(color: Colors.blue)),
                  ),
                )
              ],
            ),
          );
        }));
}

settingCalendarHome(
  BuildContext context,
  calendarsetting controll_cals,
  int theme,
  int view,
  String title,
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
                child: SheetPage(context, controll_cals, theme, view, title),
              )),
        );
      }).whenComplete(() {});
}
