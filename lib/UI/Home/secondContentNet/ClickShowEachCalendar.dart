import 'package:clickbyme/Dialogs/checkdeletecandm.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/IconBtn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import '../../../LocalNotiPlatform/NotificationApi.dart';
import '../../../Tool/BGColor.dart';
import '../../../Tool/Getx/calendarsetting.dart';
import '../../../Tool/NoBehavior.dart';
import '../../../Tool/TextSize.dart';
import '../Widgets/CreateCalandmemo.dart';
import '../firstContentNet/DayScript.dart';

class ClickShowEachCalendar extends StatefulWidget {
  const ClickShowEachCalendar(
      {Key? key,
      required this.start,
      required this.finish,
      required this.calinfo,
      required this.date,
      required this.alarm,
      required this.share,
      required this.calname,
      required this.code})
      : super(key: key);
  final String start;
  final String finish;
  final String calinfo;
  final DateTime date;
  final String alarm;
  final List share;
  final String calname;
  final String code;
  @override
  State<StatefulWidget> createState() => _ClickShowEachCalendarState();
}

class _ClickShowEachCalendarState extends State<ClickShowEachCalendar>
    with WidgetsBindingObserver {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  late TextEditingController textEditingController1;
  late TextEditingController textEditingController2;
  late TextEditingController textEditingController3;
  final searchNode = FocusNode();
  List updateid = [];
  List deleteid = [];
  bool isChecked_pushalarm = false;
  String changevalue = Hive.box('user_setting').get('alarming_time') ?? "10분 전";
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    textEditingController1 = TextEditingController(text: widget.calinfo);
    textEditingController2 = TextEditingController(text: widget.start);
    textEditingController3 = TextEditingController(text: widget.finish);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    textEditingController1.dispose();
    textEditingController2.dispose();
    textEditingController3.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: UI(),
    ));
  }

  UI() {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
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
                                            style: const NeumorphicStyle(
                                                shape: NeumorphicShape.convex,
                                                depth: 2,
                                                surfaceIntensity: 0.5,
                                                color: Colors.black,
                                                lightSource:
                                                    LightSource.topLeft),
                                          ),
                                        )),
                                    color: Colors.black),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 70,
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Row(
                                          children: [
                                            const Flexible(
                                              fit: FlexFit.tight,
                                              child: Text(
                                                '',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            IconBtn(
                                                child: IconButton(
                                                    onPressed: () {
                                                      //수정
                                                      var firsttxt = '0' +
                                                          textEditingController2
                                                              .text +
                                                          ' - 0' +
                                                          textEditingController3
                                                              .text;
                                                      var secondtxt = '0' +
                                                          textEditingController2
                                                              .text +
                                                          ' - ' +
                                                          textEditingController3
                                                              .text;
                                                      var thirdtxt =
                                                          textEditingController2
                                                                  .text +
                                                              ' - 0' +
                                                              textEditingController3
                                                                  .text;
                                                      var forthtxt =
                                                          textEditingController2
                                                                  .text +
                                                              ' - ' +
                                                              textEditingController3
                                                                  .text;
                                                      CreateCalandmemoSuccessFlushbar(
                                                          context);
                                                      firestore
                                                          .collection(
                                                              'AppNoticeByUsers')
                                                          .add({
                                                        'title': '[' +
                                                            widget.calname +
                                                            '] 캘린더의 일정 중 ${textEditingController1.text}이(가) 변경되었습니다.',
                                                        'date': DateFormat(
                                                                'yyyy-MM-dd')
                                                            .parse(
                                                                DateTime.now()
                                                                    .toString())
                                                            .toString()
                                                            .split(' ')[0],
                                                        'username': widget.share
                                                      }).whenComplete(() {
                                                        firestore
                                                            .collection(
                                                                'CalendarDataBase')
                                                            .where('calname',
                                                                isEqualTo:
                                                                    widget.code)
                                                            .where('Daytodo',
                                                                isEqualTo: widget
                                                                    .calinfo)
                                                            .where('Date',
                                                                isEqualTo: widget
                                                                            .date
                                                                            .toString()
                                                                            .split('-')[
                                                                        0] +
                                                                    '-' +
                                                                    widget.date
                                                                            .toString()
                                                                            .split('-')[
                                                                        1] +
                                                                    '-' +
                                                                    widget
                                                                        .date
                                                                        .toString()
                                                                        .split('-')[
                                                                            2]
                                                                        .substring(
                                                                            0,
                                                                            2) +
                                                                    '일')
                                                            .where('Timestart',
                                                                isEqualTo:
                                                                    widget.start)
                                                            .get()
                                                            .then((value) {
                                                          updateid.clear();
                                                          for (var element
                                                              in value.docs) {
                                                            updateid.add(
                                                                element.id);
                                                          }
                                                          for (int i = 0;
                                                              i <
                                                                  updateid
                                                                      .length;
                                                              i++) {
                                                            firestore
                                                                .collection(
                                                                    'CalendarDataBase')
                                                                .doc(
                                                                    updateid[i])
                                                                .update({
                                                              'Daytodo': textEditingController1
                                                                      .text
                                                                      .isEmpty
                                                                  ? widget
                                                                      .calinfo
                                                                  : textEditingController1
                                                                      .text,
                                                              'Alarm': widget
                                                                          .alarm ==
                                                                      '설정off'
                                                                  ? (isChecked_pushalarm ==
                                                                          true
                                                                      ? changevalue
                                                                      : '설정off')
                                                                  : (!isChecked_pushalarm ==
                                                                          true
                                                                      ? changevalue
                                                                      : '설정off'),
                                                              'Timestart': textEditingController2
                                                                      .text
                                                                      .isEmpty
                                                                  ? widget.start
                                                                  : (textEditingController2
                                                                              .text
                                                                              .split(':')[
                                                                                  0]
                                                                              .length ==
                                                                          1
                                                                      ? '0' +
                                                                          textEditingController2
                                                                              .text
                                                                      : textEditingController2
                                                                          .text),
                                                              'Timefinish': textEditingController3
                                                                      .text
                                                                      .isEmpty
                                                                  ? widget
                                                                      .finish
                                                                  : (textEditingController3
                                                                              .text
                                                                              .split(':')[
                                                                                  0]
                                                                              .length ==
                                                                          1
                                                                      ? '0' +
                                                                          textEditingController3
                                                                              .text
                                                                      : textEditingController3
                                                                          .text),
                                                            });
                                                          }
                                                        }).whenComplete(() {
                                                          Future.delayed(
                                                              const Duration(
                                                                  seconds: 2),
                                                              () {
                                                            CreateCalandmemoSuccessFlushbarSub(
                                                                context, '일정');
                                                            if (widget.alarm !=
                                                                '설정off') {
                                                              NotificationApi
                                                                  .showNotification(
                                                                title: '알람설정된 일정 : ' +
                                                                    textEditingController1
                                                                        .text,
                                                                body: textEditingController2
                                                                            .text
                                                                            .split(':')[
                                                                                0]
                                                                            .length ==
                                                                        1
                                                                    ? (textEditingController3.text.split(':')[0].length ==
                                                                            1
                                                                        ? '예정된 시각 : ' +
                                                                            firsttxt
                                                                        : '예정된 시각 : ' +
                                                                            secondtxt)
                                                                    : (textEditingController3.text.split(':')[0].length ==
                                                                            1
                                                                        ? '예정된 시각 : ' +
                                                                            thirdtxt
                                                                        : '예정된 시각 : ' +
                                                                            forthtxt),
                                                              );
                                                              NotificationApi.showScheduledNotification(
                                                                  id: int.parse(widget.date.toString().split('-')[0]) + int.parse(widget.date.toString().split('-')[1]) + int.parse(widget.date.toString().split('-')[2].toString().split(' ')[0]) + int.parse(textEditingController2.text.split(':')[1]) < int.parse(changevalue.substring(0, changevalue.length - 3))
                                                                      ? int.parse(textEditingController2.text.split(':')[0].length == 1 ? '0' + textEditingController2.text.split(':')[0] : textEditingController2.text.split(':')[0]) - 1
                                                                      : int.parse(textEditingController2.text.split(':')[0].length == 1 ? '0' + textEditingController2.text.split(':')[0] : textEditingController2.text.split(':')[0]) + int.parse(textEditingController2.text.split(':')[1]) < int.parse(changevalue.substring(0, changevalue.length - 3))
                                                                          ? 60 - (int.parse(changevalue.substring(0, changevalue.length - 3)) - int.parse(textEditingController2.text.split(':')[1]))
                                                                          : int.parse(textEditingController2.text.split(':')[1]) - int.parse(changevalue.substring(0, changevalue.length - 3)),
                                                                  title: textEditingController1.text + '일정이 다가옵니다',
                                                                  body: textEditingController2.text.split(':')[0].length == 1 ? (textEditingController3.text.split(':')[0].length == 1 ? '예정된 시각 : ' + firsttxt : '예정된 시각 : ' + secondtxt) : (textEditingController3.text.split(':')[0].length == 1 ? '예정된 시각 : ' + thirdtxt : '예정된 시각 : ' + forthtxt),
                                                                  scheduledate: DateTime.utc(
                                                                    int.parse(widget
                                                                        .date
                                                                        .toString()
                                                                        .split(
                                                                            '-')[0]),
                                                                    int.parse(widget
                                                                        .date
                                                                        .toString()
                                                                        .split(
                                                                            '-')[1]),
                                                                    int.parse(widget
                                                                        .date
                                                                        .toString()
                                                                        .split('-')[
                                                                            2]
                                                                        .toString()
                                                                        .split(
                                                                            ' ')[0]),
                                                                    int.parse(textEditingController2.text.split(':')[1]) <
                                                                            int.parse(changevalue.substring(
                                                                                0,
                                                                                changevalue.length -
                                                                                    3))
                                                                        ? int.parse(textEditingController2.text.split(':')[0].length == 1 ? '0' + textEditingController2.text.split(':')[0] : textEditingController2.text.split(':')[0]) -
                                                                            1
                                                                        : int.parse(textEditingController2.text.split(':')[0].length ==
                                                                                1
                                                                            ? '0' +
                                                                                textEditingController2.text.split(':')[0]
                                                                            : textEditingController2.text.split(':')[0]),
                                                                    int.parse(textEditingController2.text.split(':')[1]) <
                                                                            int.parse(changevalue.substring(
                                                                                0,
                                                                                changevalue.length -
                                                                                    3))
                                                                        ? 60 -
                                                                            (int.parse(changevalue.substring(0, changevalue.length - 3)) -
                                                                                int.parse(textEditingController2.text.split(':')[
                                                                                    1]))
                                                                        : int.parse(textEditingController2.text.split(':')[1]) -
                                                                            int.parse(changevalue.substring(0,
                                                                                changevalue.length - 3)),
                                                                  ));
                                                            } else {}
                                                          });
                                                        });
                                                      });
                                                    },
                                                    icon: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 30,
                                                      height: 30,
                                                      child: NeumorphicIcon(
                                                        Icons.edit,
                                                        size: 30,
                                                        style: const NeumorphicStyle(
                                                            shape:
                                                                NeumorphicShape
                                                                    .convex,
                                                            depth: 2,
                                                            surfaceIntensity:
                                                                0.5,
                                                            color: Colors.black,
                                                            lightSource:
                                                                LightSource
                                                                    .topLeft),
                                                      ),
                                                    )),
                                                color: Colors.black),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            IconBtn(
                                                child: IconButton(
                                                    onPressed: () async {
                                                      //삭제
                                                      final reloadpage =
                                                          await Get.dialog(
                                                              checkdeletecandm(
                                                                  context,
                                                                  '일정'));
                                                      if (reloadpage) {
                                                        CreateCalandmemoSuccessFlushbar(
                                                                context)
                                                            .whenComplete(() {
                                                          firestore
                                                              .collection(
                                                                  'AppNoticeByUsers')
                                                              .add({
                                                            'title': '[' +
                                                                widget.calname +
                                                                '] 캘린더의 일정 중 ${textEditingController1.text}이(가) 삭제되었습니다.',
                                                            'date': DateFormat(
                                                                    'yyyy-MM-dd')
                                                                .parse(DateTime
                                                                        .now()
                                                                    .toString())
                                                                .toString()
                                                                .split(' ')[0],
                                                            'username':
                                                                widget.share
                                                          }).whenComplete(() {
                                                            firestore
                                                                .collection(
                                                                    'CalendarDataBase')
                                                                .where('calname',
                                                                    isEqualTo: widget
                                                                        .code)
                                                                .where(
                                                                    'Daytodo',
                                                                    isEqualTo:
                                                                        widget
                                                                            .calinfo)
                                                                .where(
                                                                    'Date',
                                                                    isEqualTo: widget.date.toString().split('-')[0] +
                                                                        '-' +
                                                                        widget.date.toString().split('-')[
                                                                            1] +
                                                                        '-' +
                                                                        widget
                                                                            .date
                                                                            .toString()
                                                                            .split('-')[
                                                                                2]
                                                                            .substring(0,
                                                                                2) +
                                                                        '일')
                                                                .where(
                                                                    'Timestart',
                                                                    isEqualTo:
                                                                        widget
                                                                            .start)
                                                                .get()
                                                                .then((value) {
                                                              deleteid.clear();
                                                              for (var element
                                                                  in value
                                                                      .docs) {
                                                                deleteid.add(
                                                                    element.id);
                                                              }
                                                              for (int i = 0;
                                                                  i <
                                                                      deleteid
                                                                          .length;
                                                                  i++) {
                                                                firestore
                                                                    .collection(
                                                                        'CalendarDataBase')
                                                                    .doc(
                                                                        deleteid[
                                                                            i])
                                                                    .delete();
                                                              }
                                                            }).whenComplete(() {
                                                              Future.delayed(
                                                                  const Duration(
                                                                      seconds:
                                                                          2),
                                                                  () {
                                                                CreateCalandmemoFlushbardelete(
                                                                    context,
                                                                    '일정');
                                                                NotificationApi.cancelNotification(
                                                                    id: int.parse(widget.date.toString().split('-')[0]) + int.parse(widget.date.toString().split('-')[1]) + int.parse(widget.date.toString().split('-')[2].toString().split(' ')[0]) + int.parse(textEditingController2.text.split(':')[1]) < int.parse(changevalue.substring(0, changevalue.length - 3))
                                                                        ? int.parse(textEditingController2.text.split(':')[0].length == 1 ? '0' + textEditingController2.text.split(':')[0] : textEditingController2.text.split(':')[0]) - 1
                                                                        : int.parse(textEditingController2.text.split(':')[0].length == 1 ? '0' + textEditingController2.text.split(':')[0] : textEditingController2.text.split(':')[0]) + int.parse(textEditingController2.text.split(':')[1]) < int.parse(changevalue.substring(0, changevalue.length - 3))
                                                                            ? 60 - (int.parse(changevalue.substring(0, changevalue.length - 3)) - int.parse(textEditingController2.text.split(':')[1]))
                                                                            : int.parse(textEditingController2.text.split(':')[1]) - int.parse(changevalue.substring(0, changevalue.length - 3)));
                                                              });
                                                            });
                                                          });
                                                        });
                                                      }
                                                    },
                                                    icon: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 30,
                                                      height: 30,
                                                      child: NeumorphicIcon(
                                                        Icons.delete,
                                                        size: 30,
                                                        style: const NeumorphicStyle(
                                                            shape:
                                                                NeumorphicShape
                                                                    .convex,
                                                            depth: 2,
                                                            surfaceIntensity:
                                                                0.5,
                                                            color: Colors.black,
                                                            lightSource:
                                                                LightSource
                                                                    .topLeft),
                                                      ),
                                                    )),
                                                color: Colors.black),
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
                        return GestureDetector(
                          onTap: () {
                            searchNode.unfocus();
                          },
                          child: Padding(
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
                                Title(),
                                const SizedBox(
                                  height: 30,
                                ),
                                buildContentTitle(),
                                const SizedBox(
                                  height: 20,
                                ),
                                Content(),
                                const SizedBox(
                                  height: 20,
                                ),
                                buildAlarmTitle(),
                                const SizedBox(
                                  height: 20,
                                ),
                                Alarm(),
                                const SizedBox(
                                  height: 50,
                                )
                              ],
                            ),
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
    return Text(
      '일정제목',
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: contentTitleTextsize(),
          color: Colors.black),
    );
  }

  Title() {
    return SizedBox(
      height: widget.calinfo.length < 20 ? 30 : 80,
      child: TextFormField(
        readOnly: false,
        minLines: 1,
        maxLines: 3,
        focusNode: searchNode,
        style: TextStyle(fontSize: contentTextsize(), color: Colors.black),
        decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 2,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          contentPadding: EdgeInsets.only(left: 10),
          border: InputBorder.none,
          isCollapsed: true,
        ),
        controller: textEditingController1,
      ),
    );
  }

  buildContentTitle() {
    return Text(
      '일정세부사항',
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: contentTitleTextsize(),
          color: Colors.black),
    );
  }

  Content() {
    return ListView.builder(
        itemCount: 1,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: ((context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                child: ContainerDesign(
                  color: Colors.white,
                  child: ListTile(
                    leading: NeumorphicIcon(
                      Icons.schedule,
                      size: 30,
                      style: const NeumorphicStyle(
                          shape: NeumorphicShape.convex,
                          depth: 2,
                          surfaceIntensity: 0.5,
                          color: Colors.black,
                          lightSource: LightSource.topLeft),
                    ),
                    title: Text(
                      '시작시간',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentTitleTextsize(),
                          color: Colors.black),
                    ),
                    subtitle: TextFormField(
                      readOnly: true,
                      style: TextStyle(
                          fontSize: contentTextsize(), color: Colors.black),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                      controller: textEditingController2,
                    ),
                    trailing: InkWell(
                      onTap: () {
                        pickDates(context, textEditingController2, widget.date);
                      },
                      child: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                child: ContainerDesign(
                  color: Colors.white,
                  child: ListTile(
                    leading: NeumorphicIcon(
                      Icons.schedule,
                      size: 30,
                      style: const NeumorphicStyle(
                          shape: NeumorphicShape.convex,
                          depth: 2,
                          surfaceIntensity: 0.5,
                          color: Colors.black,
                          lightSource: LightSource.topLeft),
                    ),
                    title: Text(
                      '종료시간',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentTitleTextsize(),
                          color: Colors.black),
                    ),
                    subtitle: TextFormField(
                      readOnly: true,
                      style: TextStyle(
                          fontSize: contentTextsize(), color: Colors.black),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                      controller: textEditingController3,
                    ),
                    trailing: InkWell(
                      onTap: () {
                        pickDates(context, textEditingController3, widget.date);
                      },
                      child: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }));
  }

  buildAlarmTitle() {
    print(widget.alarm);
    return SizedBox(
        child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: Text(
            '알람설정',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: contentTitleTextsize(),
                color: Colors.black),
          ),
        ),
        widget.alarm == '설정off'
            ? Transform.scale(
                scale: 1,
                child: Switch(
                    activeColor: Colors.blue,
                    inactiveThumbColor: Colors.black,
                    inactiveTrackColor: Colors.grey.shade100,
                    value: isChecked_pushalarm,
                    onChanged: (bool val) {
                      setState(() {
                        isChecked_pushalarm = val;
                        if (isChecked_pushalarm == false) {
                          NotificationApi.cancelNotification(
                              id: int.parse(widget.date.toString().split('-')[0]) + int.parse(widget.date.toString().split('-')[1]) + int.parse(widget.date.toString().split('-')[2].toString().split(' ')[0]) + int.parse(textEditingController2.text.split(':')[1]) <
                                      int.parse(changevalue.substring(
                                          0, changevalue.length - 3))
                                  ? int.parse(textEditingController2.text
                                                  .split(':')[0]
                                                  .length ==
                                              1
                                          ? '0' +
                                              textEditingController2.text
                                                  .split(':')[0]
                                          : textEditingController2.text
                                              .split(':')[0]) -
                                      1
                                  : int.parse(textEditingController2.text.split(':')[0].length == 1 ? '0' + textEditingController2.text.split(':')[0] : textEditingController2.text.split(':')[0]) +
                                              int.parse(textEditingController2.text.split(':')[1]) <
                                          int.parse(changevalue.substring(0, changevalue.length - 3))
                                      ? 60 - (int.parse(changevalue.substring(0, changevalue.length - 3)) - int.parse(textEditingController2.text.split(':')[1]))
                                      : int.parse(textEditingController2.text.split(':')[1]) - int.parse(changevalue.substring(0, changevalue.length - 3)));
                        }
                      });
                    }),
              )
            : Transform.scale(
                scale: 1,
                child: Switch(
                    activeColor: Colors.blue,
                    inactiveThumbColor: Colors.black,
                    inactiveTrackColor: Colors.grey.shade400,
                    value: !isChecked_pushalarm,
                    onChanged: (bool val) {
                      setState(() {
                        isChecked_pushalarm = !val;
                        if (!isChecked_pushalarm == false) {
                          NotificationApi.cancelNotification(
                              id: int.parse(widget.date.toString().split('-')[0]) + int.parse(widget.date.toString().split('-')[1]) + int.parse(widget.date.toString().split('-')[2].toString().split(' ')[0]) + int.parse(textEditingController2.text.split(':')[1]) <
                                      int.parse(changevalue.substring(
                                          0, changevalue.length - 3))
                                  ? int.parse(textEditingController2.text
                                                  .split(':')[0]
                                                  .length ==
                                              1
                                          ? '0' +
                                              textEditingController2.text
                                                  .split(':')[0]
                                          : textEditingController2.text
                                              .split(':')[0]) -
                                      1
                                  : int.parse(textEditingController2.text.split(':')[0].length == 1 ? '0' + textEditingController2.text.split(':')[0] : textEditingController2.text.split(':')[0]) +
                                              int.parse(textEditingController2.text.split(':')[1]) <
                                          int.parse(changevalue.substring(0, changevalue.length - 3))
                                      ? 60 - (int.parse(changevalue.substring(0, changevalue.length - 3)) - int.parse(textEditingController2.text.split(':')[1]))
                                      : int.parse(textEditingController2.text.split(':')[1]) - int.parse(changevalue.substring(0, changevalue.length - 3)));
                        }
                      });
                    }),
              )
      ],
    ));
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("1분 전"), value: "1분 전"),
      const DropdownMenuItem(child: Text("5분 전"), value: "5분 전"),
      const DropdownMenuItem(child: Text("10분 전"), value: "10분 전"),
      const DropdownMenuItem(child: Text("30분 전"), value: "30분 전"),
    ];
    return menuItems;
  }

  Alarm() {
    return SizedBox(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          child: ContainerDesign(
            color: Colors.white,
            child: ListTile(
              leading: NeumorphicIcon(
                Icons.alarm,
                size: 30,
                style: const NeumorphicStyle(
                    shape: NeumorphicShape.convex,
                    depth: 2,
                    surfaceIntensity: 0.5,
                    color: Colors.black,
                    lightSource: LightSource.topLeft),
              ),
              title: Text(
                '알람',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: contentTitleTextsize(),
                    color: Colors.black),
              ),
              trailing: widget.alarm == '설정off'
                  ? (isChecked_pushalarm == true
                      ? DropdownButton(
                          value: changevalue,
                          dropdownColor: Colors.white,
                          items: dropdownItems,
                          icon: NeumorphicIcon(
                            Icons.arrow_drop_down,
                            size: 20,
                            style: const NeumorphicStyle(
                                shape: NeumorphicShape.convex,
                                depth: 2,
                                surfaceIntensity: 0.5,
                                color: Colors.black,
                                lightSource: LightSource.topLeft),
                          ),
                          style: TextStyle(
                              color: Colors.black, fontSize: contentTextsize()),
                          onChanged: isChecked_pushalarm == true
                              ? (String? value) {
                                  setState(() {
                                    changevalue = value!;
                                    Hive.box('user_setting')
                                        .put('alarming_time', changevalue);
                                  });
                                }
                              : null,
                        )
                      : Text(
                          '설정off상태입니다.',
                          style: TextStyle(
                              fontSize: contentTextsize(), color: Colors.black),
                        ))
                  : (!isChecked_pushalarm == true
                      ? DropdownButton(
                          value: changevalue,
                          dropdownColor: Colors.white,
                          items: dropdownItems,
                          icon: NeumorphicIcon(
                            Icons.arrow_drop_down,
                            size: 20,
                            style: const NeumorphicStyle(
                                shape: NeumorphicShape.convex,
                                depth: 2,
                                surfaceIntensity: 0.5,
                                color: Colors.black,
                                lightSource: LightSource.topLeft),
                          ),
                          style: TextStyle(
                              color: Colors.black, fontSize: contentTextsize()),
                          onChanged: !isChecked_pushalarm == true
                              ? (String? value) {
                                  setState(() {
                                    changevalue = value!;
                                    Hive.box('user_setting')
                                        .put('alarming_time', changevalue);
                                  });
                                }
                              : null,
                        )
                      : Text(
                          '설정off상태입니다.',
                          style: TextStyle(
                              fontSize: contentTextsize(), color: Colors.black),
                        )),
            ),
          ),
        ),
      ],
    ));
  }
}
