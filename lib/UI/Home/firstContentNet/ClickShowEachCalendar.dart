import 'package:another_flushbar/flushbar.dart';
import 'package:clickbyme/Dialogs/checkdeletecandm.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../Tool/BGColor.dart';
import '../../../Tool/NoBehavior.dart';
import '../../../Tool/TextSize.dart';
import '../Widgets/CreateCalandmemo.dart';
import 'DayScript.dart';

class ClickShowEachCalendar extends StatefulWidget {
  const ClickShowEachCalendar(
      {Key? key,
      required this.start,
      required this.finish,
      required this.calinfo,
      required this.date,
      required this.doc,
      required this.alarm})
      : super(key: key);
  final String start;
  final String finish;
  final String calinfo;
  final DateTime date;
  final String doc;
  final String alarm;
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeDependencies();
    if (state == AppLifecycleState.resumed) {
      SystemNavigator.pop();
    }
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
          decoration: BoxDecoration(
            color: BGColor(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                            fit: FlexFit.tight,
                            child: Row(
                              children: [
                                SizedBox(
                                    width: 50,
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Container(
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
                                        ))),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 70,
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 10),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: Text(
                                                '',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                  color: TextColor(),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                width: 30,
                                                child: InkWell(
                                                    onTap: () {
                                                      //수정
                                                      CreateCalandmemoSuccessFlushbar(
                                                          context);
                                                      firestore
                                                          .collection(
                                                              'CalendarDataBase')
                                                          .where('calname',
                                                              isEqualTo: widget
                                                                  .doc)
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
                                                                          .split(
                                                                              '-')[
                                                                      1] +
                                                                  '-' +
                                                                  widget.date
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
                                                          updateid
                                                              .add(element.id);
                                                        }
                                                        for (int i = 0;
                                                            i < updateid.length;
                                                            i++) {
                                                          firestore
                                                              .collection(
                                                                  'CalendarDataBase')
                                                              .doc(updateid[i])
                                                              .update({
                                                            'Daytodo':
                                                                textEditingController1
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
                                                                ? widget.finish
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
                                                        });
                                                      });
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 30,
                                                      height: 30,
                                                      child: NeumorphicIcon(
                                                        Icons.edit,
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
                                                    ))),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                                width: 30,
                                                child: InkWell(
                                                    onTap: () async {
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
                                                                  'CalendarDataBase')
                                                              .where('calname',
                                                                  isEqualTo: widget
                                                                      .doc)
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
                                                                      widget.date
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
                                                            deleteid.clear();
                                                            for (var element
                                                                in value.docs) {
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
                                                                  .doc(deleteid[
                                                                      i])
                                                                  .delete();
                                                            }
                                                          }).whenComplete(() {
                                                            Future.delayed(
                                                                const Duration(
                                                                    seconds: 2),
                                                                () {
                                                              CreateCalandmemoFlushbardelete(
                                                                  context,
                                                                  '일정');
                                                            });
                                                          });
                                                        });
                                                      }
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 30,
                                                      height: 30,
                                                      child: NeumorphicIcon(
                                                        Icons.delete,
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
                                                    ))),
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
    return SizedBox(
      height: 30,
      child: Text(
        '일정제목',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: contentTitleTextsize(),
            color: TextColor()),
      ),
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
        style: TextStyle(fontSize: contentTextsize(), color: TextColor()),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isCollapsed: true,
        ),
        controller: textEditingController1,
      ),
    );
  }

  buildContentTitle() {
    return SizedBox(
      height: 30,
      child: Text(
        '일정세부사항',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: contentTitleTextsize(),
            color: TextColor()),
      ),
    );
  }

  Content() {
    return SizedBox(
        height: 200,
        child: Column(
          children: [
            SizedBox(
              height: 80,
              child: ContainerDesign(
                color: BGColor(),
                child: ListTile(
                  leading: NeumorphicIcon(
                    Icons.schedule,
                    size: 30,
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        depth: 2,
                        surfaceIntensity: 0.5,
                        color: TextColor(),
                        lightSource: LightSource.topLeft),
                  ),
                  title: Text(
                    '시작시간',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize(),
                        color: TextColor()),
                  ),
                  subtitle: TextFormField(
                    readOnly: true,
                    style: TextStyle(
                        fontSize: contentTextsize(), color: TextColor()),
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
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: TextColor(),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 80,
              child: ContainerDesign(
                color: BGColor(),
                child: ListTile(
                  leading: NeumorphicIcon(
                    Icons.schedule,
                    size: 30,
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        depth: 2,
                        surfaceIntensity: 0.5,
                        color: TextColor(),
                        lightSource: LightSource.topLeft),
                  ),
                  title: Text(
                    '종료시간',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize(),
                        color: TextColor()),
                  ),
                  subtitle: TextFormField(
                    readOnly: true,
                    style: TextStyle(
                        fontSize: contentTextsize(), color: TextColor()),
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
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: TextColor(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  buildAlarmTitle() {
    print(widget.alarm);
    return SizedBox(
        height: 30,
        child: Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Text(
                '알람설정',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: contentTitleTextsize(),
                    color: TextColor()),
              ),
            ),
            widget.alarm == '설정off'
                ? Transform.scale(
                    scale: 0.7,
                    child: Switch(
                        activeColor: Colors.blue,
                        inactiveThumbColor: TextColor(),
                        inactiveTrackColor: Colors.grey.shade100,
                        value: isChecked_pushalarm,
                        onChanged: (bool val) {
                          setState(() {
                            isChecked_pushalarm = val;
                            print(isChecked_pushalarm);
                          });
                        }),
                  )
                : Transform.scale(
                    scale: 0.7,
                    child: Switch(
                        activeColor: Colors.blue,
                        inactiveThumbColor: TextColor(),
                        inactiveTrackColor: Colors.grey.shade100,
                        value: !isChecked_pushalarm,
                        onChanged: (bool val) {
                          setState(() {
                            isChecked_pushalarm = !val;
                            print(isChecked_pushalarm);
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
        height: 200,
        child: Column(
          children: [
            SizedBox(
              height: 80,
              child: ContainerDesign(
                color: BGColor(),
                child: ListTile(
                  leading: NeumorphicIcon(
                    Icons.alarm,
                    size: 30,
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        depth: 2,
                        surfaceIntensity: 0.5,
                        color: TextColor(),
                        lightSource: LightSource.topLeft),
                  ),
                  title: Text(
                    '알람',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize(),
                        color: TextColor()),
                  ),
                  trailing: widget.alarm == '설정off'
                      ? (isChecked_pushalarm == true
                          ? DropdownButton(
                              value: changevalue,
                              dropdownColor: BGColor(),
                              items: dropdownItems,
                              icon: NeumorphicIcon(
                                Icons.arrow_drop_down,
                                size: 20,
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.convex,
                                    depth: 2,
                                    surfaceIntensity: 0.5,
                                    color: TextColor(),
                                    lightSource: LightSource.topLeft),
                              ),
                              style: TextStyle(
                                  color: TextColor(),
                                  fontSize: contentTextsize()),
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
                                  fontSize: contentTextsize(),
                                  color: TextColor()),
                            ))
                      : (!isChecked_pushalarm == true
                          ? DropdownButton(
                              value: changevalue,
                              dropdownColor: BGColor(),
                              items: dropdownItems,
                              icon: NeumorphicIcon(
                                Icons.arrow_drop_down,
                                size: 20,
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.convex,
                                    depth: 2,
                                    surfaceIntensity: 0.5,
                                    color: TextColor(),
                                    lightSource: LightSource.topLeft),
                              ),
                              style: TextStyle(
                                  color: TextColor(),
                                  fontSize: contentTextsize()),
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
                                  fontSize: contentTextsize(),
                                  color: TextColor()),
                            )),
                ),
              ),
            ),
          ],
        ));
  }
}
