import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/BACKENDPART/Getx/calendarsetting.dart';
import 'package:clickbyme/BACKENDPART/Getx/memosetting.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../Tool/BGColor.dart';
import '../Tool/FlushbarStyle.dart';
import '../BACKENDPART/Getx/PeopleAdd.dart';
import '../BACKENDPART/Getx/navibool.dart';
import '../Tool/IconBtn.dart';
import '../Tool/NoBehavior.dart';

pushalarmsettingcal(
  BuildContext context,
  FocusNode setalarmhourNode,
  FocusNode setalarmminuteNode,
  String hour,
  String minute,
  String docTitle,
  String id,
  int isCheckedPushalarmwhat,
  DateTime date,
) {
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
                      return GestureDetector(
                          onTap: () {
                            setalarmhourNode.unfocus();
                            setalarmminuteNode.unfocus();
                          },
                          child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: SheetPage(
                                context,
                                setalarmhourNode,
                                setalarmminuteNode,
                                hour,
                                minute,
                                docTitle,
                                id,
                                isCheckedPushalarmwhat,
                                date,
                              )));
                    }),
                  ),
                ),
              ),
            ));
      });
}

SheetPage(
  BuildContext context,
  FocusNode setalarmhourNode,
  FocusNode setalarmminuteNode,
  String hour,
  String minute,
  String docTitle,
  String id,
  int isCheckedPushalarmwhat,
  DateTime date,
) {
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
              title(context, docTitle),
              const SizedBox(
                height: 20,
              ),
              content(
                context,
                setalarmhourNode,
                setalarmminuteNode,
                hour,
                minute,
                docTitle,
                id,
                isCheckedPushalarmwhat,
                date,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}

title(
  BuildContext context,
  String docTitle,
) {
  return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          docTitle != ''
              ? RichText(
                  maxLines: 2,
                  text: TextSpan(children: [
                    TextSpan(
                        text: docTitle,
                        style: TextStyle(
                            color: Colors.blue.shade400,
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize())),
                    TextSpan(
                        text: ' 일정의 알람 설정',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: contentTextsize()))
                  ]))
              : RichText(
                  maxLines: 2,
                  text: TextSpan(children: [
                    TextSpan(
                        text: '알람 설정',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: contentTextsize()))
                  ]))
        ],
      ));
}

content(
  BuildContext context,
  FocusNode setalarmhourNode,
  FocusNode setalarmminuteNode,
  String hour,
  String minute,
  String docTitle,
  String id,
  int isCheckedPushalarmwhat,
  DateTime date,
) {
  DateTime now = DateTime.now();
  final draw = Get.put(navibool());
  final controllCal = Get.put(calendarsetting());
  final controllMemo = Get.put(memosetting());
  TimeOfDay? pickednow;
  final calSharePerson = Get.put(PeopleAdd());

  return StatefulBuilder(builder: (_, StateSetter setState) {
    return SizedBox(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ContainerDesign(
            child: SizedBox(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: RichText(
                      maxLines: 3,
                      text: TextSpan(
                        text: '알람은 설정하신 시각에 울리게 됩니다',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTextsize(),
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
            color: Colors.orange.shade400),
        const SizedBox(
          height: 20,
        ),
        GetBuilder<calendarsetting>(
            builder: (_) => SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                              '시간 설정',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize(),
                                  color: Colors.black),
                            ),
                          ),
                          IconBtn(
                              child: InkWell(
                                  onTap: () async {
                                    pickednow = await showTimePicker(
                                        context: context,
                                        initialEntryMode:
                                            TimePickerEntryMode.inputOnly,
                                        helpText: '시간을 설정해주세요',
                                        cancelText: '닫기',
                                        confirmText: '설정',
                                        initialTime:
                                            controllCal.hour1 == '99' &&
                                                    controllCal.minute1 == '99'
                                                ? TimeOfDay.now()
                                                : TimeOfDay(
                                                    hour: int.parse(
                                                        controllCal.hour1),
                                                    minute: int.parse(
                                                        controllCal.minute1)));
                                    if (pickednow != null) {
                                      if (docTitle != '') {
                                        controllCal.settimeminute(
                                            pickednow!.hour,
                                            pickednow!.minute,
                                            docTitle,
                                            id);
                                      } else {
                                        controllCal.settimeminute(
                                            pickednow!.hour,
                                            pickednow!.minute,
                                            '',
                                            '');
                                      }
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Text(
                                      'Click',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: contentTextsize(),
                                          color: Colors.blue),
                                    ),
                                  )),
                              color: Colors.black)
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          docTitle != ''
                              ? (controllCal.hour1 != '99' ||
                                      controllCal.minute1 != '99'
                                  ? (controllCal.hour1.toString().length < 2
                                      ? (controllCal.minute1.toString().length <
                                              2
                                          ? Text(
                                              '설정시간 : ' +
                                                  '0' +
                                                  controllCal.hour1.toString() +
                                                  '시 ' +
                                                  '0' +
                                                  controllCal.minute1
                                                      .toString() +
                                                  '분',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize(),
                                                  color: Colors.black),
                                            )
                                          : Text(
                                              '설정시간 : ' +
                                                  '0' +
                                                  controllCal.hour1.toString() +
                                                  '시 ' +
                                                  controllCal.minute1
                                                      .toString() +
                                                  '분',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize(),
                                                  color: Colors.black),
                                            ))
                                      : (controllCal.minute1.toString().length <
                                              2
                                          ? Text(
                                              '설정시간 : ' +
                                                  controllCal.hour1.toString() +
                                                  '시 ' +
                                                  '0' +
                                                  controllCal.minute1
                                                      .toString() +
                                                  '분',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize(),
                                                  color: Colors.black),
                                            )
                                          : Text(
                                              '설정시간 : ' +
                                                  controllCal.hour1.toString() +
                                                  '시 ' +
                                                  controllCal.minute1
                                                      .toString() +
                                                  '분',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize(),
                                                  color: Colors.black),
                                            )))
                                  : Text(
                                      '설정시간 : 없음',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: contentTextsize(),
                                          color: Colors.black),
                                    ))
                              : (controllCal.hour1 != '99' ||
                                      controllCal.minute1 != '99'
                                  ? (controllCal.hour1.toString().length < 2
                                      ? (controllCal.minute1.toString().length <
                                              2
                                          ? Text(
                                              '설정시간 : ' +
                                                  '0' +
                                                  controllCal.hour1.toString() +
                                                  '시 ' +
                                                  '0' +
                                                  controllCal.minute1
                                                      .toString() +
                                                  '분',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize(),
                                                  color: Colors.black),
                                            )
                                          : Text(
                                              '설정시간 : ' +
                                                  '0' +
                                                  controllCal.hour1.toString() +
                                                  '시 ' +
                                                  controllCal.minute1
                                                      .toString() +
                                                  '분',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize(),
                                                  color: Colors.black),
                                            ))
                                      : (controllCal.minute1.toString().length <
                                              2
                                          ? Text(
                                              '설정시간 : ' +
                                                  controllCal.hour1.toString() +
                                                  '시 ' +
                                                  '0' +
                                                  controllCal.minute1
                                                      .toString() +
                                                  '분',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize(),
                                                  color: Colors.black),
                                            )
                                          : Text(
                                              '설정시간 : ' +
                                                  controllCal.hour1.toString() +
                                                  '시 ' +
                                                  controllCal.minute1
                                                      .toString() +
                                                  '분',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize(),
                                                  color: Colors.black),
                                            )))
                                  : Text(
                                      '설정시간 : 없음',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: contentTextsize(),
                                          color: Colors.black),
                                    )),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 1,
                                child: SizedBox(
                                    height: 50,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (controllCal.hour1.toString() ==
                                                  '99' ||
                                              controllCal.minute1.toString() ==
                                                  '99') {
                                            Snack.snackbars(
                                                context: context,
                                                title: '시간 설정안됨!',
                                                backgroundcolor: Colors.black,
                                                bordercolor:
                                                    draw.backgroundcolor);
                                          } else {
                                            Snack.snackbars(
                                                context: context,
                                                title: '설정 완료!',
                                                backgroundcolor: Colors.green,
                                                bordercolor:
                                                    draw.backgroundcolor);
                                            Snack.isopensnacks();
                                          }
                                        });
                                      },
                                      child: Container(
                                        color: ButtonColor(),
                                        child: Center(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: NeumorphicText(
                                                  '설정하기',
                                                  style: const NeumorphicStyle(
                                                    shape: NeumorphicShape.flat,
                                                    depth: 3,
                                                    color: Colors.white,
                                                  ),
                                                  textStyle:
                                                      NeumorphicTextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: contentTextsize(),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )),
                              ),
                              Flexible(
                                  flex: 1,
                                  child: SizedBox(
                                      height: 50,
                                      child: InkWell(
                                        onTap: () {
                                          controllCal.setalarmcal(docTitle, id);
                                          Snack.snackbars(
                                              context: context,
                                              title: '해제 완료!',
                                              backgroundcolor: Colors.green,
                                              bordercolor:
                                                  draw.backgroundcolor);
                                          Snack.isopensnacks();
                                        },
                                        child: Container(
                                          color: Colors.red.shade400,
                                          child: Center(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: NeumorphicText(
                                                    '해제하기',
                                                    style:
                                                        const NeumorphicStyle(
                                                      shape:
                                                          NeumorphicShape.flat,
                                                      depth: 3,
                                                      color: Colors.white,
                                                    ),
                                                    textStyle:
                                                        NeumorphicTextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          contentTextsize(),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ))),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )),
      ],
    ));
  });
}
